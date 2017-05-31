#!/bin/bash

release_version=
# The next development version
development_version=
# Provide an optional comment prefix, e.g. for your bug tracking system
scm_comment_prefix='[maven-release-plugin] '

assert_exit_status() {

  lambda() {
    local val_fd=$(echo $@ | tr -d ' ' | cut -d':' -f2)
    local arg=$1
    shift
    shift
    local cmd=$(echo $@ | xargs -E ':')
    local val=$(cat $val_fd)
    eval $arg=$val
    eval $cmd
  }

  local lambda=$1
  shift

  eval $@
  local ret=$?
  $lambda : <(echo $ret)

}

exit_if_error() {
  assert_exit_status 'lambda status -> [[ $status -ne 0 ]] && echo [ERROR] Exiting because of mvn errors. && exit $status' $@
}

show_help() {
cat << EOF

   Usage: ${0##*/} [-r release_version] [-d development_version] [-c scm_comment_prefix] [-h]

   Release a new version of the project.

       -r release_version          Set the release version.
       -d development_version      Set the next development version.
       -c scm_comment_prefix       Provide an optional comment prefix.
       -h                          Print this help

EOF
}

while getopts ":r:d:c:h" opt; do

  case $opt in
    r)
      release_version=$OPTARG
      ;;
    d)
      development_version=$OPTARG
      ;;
    c)
      scm_comment_prefix=$OPTARG
      ;;
    h)
      show_help
      exit 0
      ;;
    \?)
      echo
      echo "   Invalid option: -$OPTARG" >&2
      show_help
      exit 1
      ;;
    :)
      echo
      echo "   Option -$OPTARG requires an argument." >&2
      show_help
      exit 1
      ;;
  esac

done

if [[ -z $release_version ]]; then
  release_version=$(mvn -q -Dexec.executable="echo" -Dexec.args='${project.version}' --non-recursive org.codehaus.mojo:exec-maven-plugin:1.3.1:exec 2>/dev/null)
  release_version=${release_version%%-SNAPSHOT}
fi

if [[ ! -z $development_version ]]; then
  development_version=${development_version%%-SNAPSHOT}-SNAPSHOT
fi


echo "release_version=$release_version"
echo "development_version=$development_version"

# Start the release by creating a new release branch
exit_if_error git checkout -b release/$release_version develop

# The Maven release

args="--batch-mode -DreleaseVersion=$release_version -DscmCommentPrefix=\"$scm_comment_prefix\" -Darguments=\"-Drelease\""

if [[ ! -z $development_version ]]; then
  args=$args" -DdevelopmentVersion=$development_version"
fi

args=$(echo $args | xargs)

exit_if_error mvn release:prepare release:perform $args

# Clean up and finish
# get back to the develop branch
git checkout develop

# merge the version back into develop
exit_if_error git merge --no-ff -m "$scm_comment_prefix Merge release/$release_version into develop" release/$release_version
# go to the master branch
git checkout master
# merge the version back into master but use the tagged version instead of the release/$releaseVersion HEAD
exit_if_error git merge --no-ff -m "$scm_comment_prefix Merge previous version into master to avoid the increased version number" release/$release_version~1
# Get back on the develop branch
git checkout develop
# Finally push everything
exit_if_error git push local develop master
exit_if_error git push --tags
# Removing the release branch
git branch -D release/$release_version
