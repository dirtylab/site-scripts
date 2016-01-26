#!/bin/bash

# @author Frosty-Z
# @date 2015-12-22
# @desc push changes made by 1_process.sh to 'dirtylab.github.io' repo

# assert context in source dir
cd "${BASH_SOURCE%/*}" || (echo "FAILURE: impossible de trouver le répertoire courant" ; exit 1)
source_dir=$(pwd)
# include vars
. vars.sh

if [ ! -d "$dest_repo_path" ]; then
  echo "*** Create $dest_repo_path directory"
  mkdir $dest_repo_path
  cd $dest_repo_path
  git init
  git remote add origin $dest_repo_url
else
  cd $dest_repo_path
fi

git pull origin master
cp -rf $jekyll_tmp_dir/* .

# may be generated by a local Jekyll
rm -rf _site
pwd

git add -A .
# you may need to do
# git config --global --edit
# before running this:
git commit -m "commit depuis script"

git push origin master