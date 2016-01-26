#!/bin/bash

# @author Frosty-Z
# @date 2015-12-22
# @desc push changes made by 1_process.sh to 'dirtylab.github.io' repo. adapted for Travis-CI.

# execution context agnostic
cd "${BASH_SOURCE%/*}" || (echo "FAILURE: impossible de trouver le répertoire courant" ; exit 1)

source_dir=$(pwd)

tmp_dir="$source_dir/../tmp_site"
dest_repo="https://$GH_USER:$GH_TOKEN@$GH_REF"
dest_dir="$source_dir/../dirtylab.github.io"

if [ ! -d "$dest_dir" ]; then
  echo "*** Create $dest_dir directory"
  git clone $dest_repo $dest_dir
fi

cd $dest_dir

git pull origin master

cp -rf $tmp_dir/* .

# may be generated by a local Jekyll
rm -rf _site

git add -A .

git config user.name "$GH_USER"
git config user.email "$GH_EMAIL"

git commit -m "commit depuis Travis-CI (build number $TRAVIS_BUILD_NUMBER)"

git push --force --quiet origin master > /dev/null 2>&1
#pour debug
#git push origin master
