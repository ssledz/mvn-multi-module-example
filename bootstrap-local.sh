#!/bin/bash

root=$(pwd)
dest=$1

[[ -z $dest ]] && echo "What is dest ?" && exit 1

cd $dest
mkdir mvn-repo
mdkir -p git-repo/mvn-multi-module-example.git
cd git-repo/mvn-multi-module-example.git && git init --bare

cd $root
git remote add local file:///$dest/git-repo/mvn-multi-module-example.git

cat << EOF
<settings xmlns="http://maven.apache.org/SETTINGS/1.0.0" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
  xsi:schemaLocation="http://maven.apache.org/SETTINGS/1.0.0 https://maven.apache.org/xsd/settings-1.0.0.xsd">
  <profiles>
    <profile>
      <id>local</id>
      <properties>
        <local.mvn.repo.path>file://${user.home}/mvn-repo/releases</local.mvn.repo.path>
        <local.mvn.snapshots-repo.path>file://${user.home}/mvn-repo/snapshots</local.mvn.snapshots-repo.path>
        <local.git.repo.path>scm:git:file://${user.home}/git-repo</local.git.repo.path>
      </properties>
    </profile>
  </profiles>
  <activeProfiles>
    <activeProfile>local</activeProfile>
  </activeProfiles>
</settings>
EOF
