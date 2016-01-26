#!/bin/bash

# @author Frosty-Z
# @date 2015-12-22
# @desc push changes made by 1_process.sh to 'dirtylab.github.io' repo

# execution context agnostic
cd "${BASH_SOURCE%/*}" || (echo "FAILURE: impossible de trouver le répertoire courant" ; exit 1)

source_dir=$(pwd)

tmp_dir="$source_dir/../jekyll-build"

dest_repo_url="https://github.com/dirtylab/dirtylab.github.io"
dest_repo_path="$source_dir/../dirtylab.github.io"

if [ ! -d "$dest_repo_path" ]; then
  echo "*** Create $dest_repo_path directory"
  mkdir $dest_repo_path
  cd $dest_repo_path
  git clone $dest_repo_url .
else
  cd $dest_repo_path && git pull
fi


cp -rf $tmp_dir/* .

# may be generated by a local Jekyll
rm -rf _site

git add -A .

# you may need to do
# git config --global --edit
# before running this:
git commit -m "commit depuis script"
pwd

git push origin master