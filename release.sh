#!/bin/bash

release_version=1.5
# The next development version
development_version=1.6-SNAPSHOT
# Provide an optional comment prefix, e.g. for your bug tracking system
scm_comment_prefix='[maven-release-plugin] '

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

exit 2

# Start the release by creating a new release branch
git checkout -b release/$release_version develop

# The Maven release
mvn --batch-mode release:prepare release:perform \
 -DscmCommentPrefix="$scm_comment_prefix" \
 -DreleaseVersion=$release_version \
 -DdevelopmentVersion=$development_version

# Clean up and finish
# get back to the develop branch
git checkout develop

# merge the version back into develop
git merge --no-ff -m "$scm_comment_prefix Merge release/$release_version into develop" release/$release_version
# go to the master branch
git checkout master
# merge the version back into master but use the tagged version instead of the release/$releaseVersion HEAD
git merge --no-ff -m "$scm_comment_prefix Merge previous version into master to avoid the increased version number" release/$release_version~1
# Removing the release branch
git branch -D release/$release_version
# Get back on the develop branch
git checkout develop
# Finally push everything
git push --all && git push --tags
