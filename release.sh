#!/bin/bash

release_version=1.4
# The next development version
development_version=1.5-SNAPSHOT
# Provide an optional comment prefix, e.g. for your bug tracking system
scm_comment_prefix='Prefix: '

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