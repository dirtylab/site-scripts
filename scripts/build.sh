#!/bin/bash

# @author Frosty-Z
# @date 2015-12-22
# @desc Processes .MD files from https://github.com/sveinburne/lets-play-science
#       to get .html files then upload them to https://github.com/dirtylab/dirtylab.github.io

# requires PHP 5+ to be installed on the system
# assert context in source dir
cd "${BASH_SOURCE%/*}" || (echo "FAILURE: impossible de trouver le répertoire courant" ; exit 1)

source_dir=$(pwd)

# include vars
. vars.sh

shall_build_js_sources=true

[[ -e $last_commit_file ]] && [[ -n "$TRAVIS_COMMIT" ]] && {
    cd "$source_dir/.."
    pwd
    last_commit=$(cat $last_commit_file)
    # if any, commit between last build and current commit that saw changes in "client" dir
    diff_commit=$(git rev-list -1 $last_commit..$TRAVIS_COMMIT -- "client")
    [[ -z "$diff_commit" ]] && {
        shall_build_js_source=false
        echo "*** Prevented from building js sources as no changes since last build were noticed in client/ dir."
    } || {
        echo "*** Changes detected in client/ dir at commit $diff_commit"
    }
}

[ $shall_build_js_source = true ] && {
    cd $npm_dir
    if [ "$1" = "--prod" ]; then
        echo "*** Bundle and minify javascript sources with webpack"
        grunt pack:prod
    else
        echo "*** Bundle javascript sources with webpack"
        grunt pack:dev
    fi
}

echo "*** Clean/refresh directories"

if [ ! -d "$wiki_repo_dir" ]; then
  echo "*** Create $DEST_DIR directory from $wiki_repo_url"
  mkdir $wiki_repo_dir
  cd $wiki_repo_dir
  git clone $wiki_repo_url .
else
  cd $wiki_repo_dir
  git pull
fi

if [ ! -d "$jekyll_tmp_dir" ]; then
  mkdir $jekyll_tmp_dir
else
  # clear content but avoid rm -rf /*
  if [ -n "$jekyll_tmp_dir" ]; then
    rm -rf $jekyll_tmp_dir/*
  fi
fi

cp -r $wiki_repo_dir/* $jekyll_tmp_dir

cd $jekyll_tmp_dir && rm -rf .git


echo '*** Remove <a name="hi"></a> anchor at top of README.MD to avoid a CSS issue'

sed -i.bak -e 's/<a name="hi"><\/a>//g' README.MD


echo "*** Copy .MD files to $jekyll_includes_dir recursively + fix links and emoji"

mkdir $jekyll_includes_dir

# required to handle spaces in filenames
OLDIFS=$IFS
IFS=$'\n'

for f in `find . -type f -regextype sed -regex ".*/.*\.\(MD\|md\)"`
do
  # Links fixing
  php $fix_script_path $f
  
  # Emoji conversion
  php $emojize_script_path $f

  # copy with directory structure preservation
  mkdir -p `dirname "$jekyll_includes_dir/$f"`
  cp "$f" "$jekyll_includes_dir/$f"
done

# clean .bak files created by sed.
# note that rm -rf *.bak only remove files from current directory, not subdirs
# see http://unix.stackexchange.com/questions/116389
find . -type f -name '*.bak' -delete

echo "*** Create one .html file per .MD file, with appropriate 'Front Matter' content"

STR_NAV=$'\n\nfiles:\n'

for f in `find . -type f -regextype sed -regex ".*/.*\.\(MD\|md\)" -not -path "./$jekyll_includes_dir/*" -not -path "./$jekyll_build_dir/*"`
do
  if [[ "$f" == *MD ]]; then
    NEW_FILENAME="${f%.MD}.html"
  else
    NEW_FILENAME="${f%.md}.html"
  fi
  
  mv "$f" "$NEW_FILENAME"

  CONTENT=$'---\n'
  CONTENT+=$'layout: convert_md_to_html\n'
  CONTENT+="markdown_file: ${f:2}" # strip './' at the beginning of the filename, otherwise Jekyll crashes !
  CONTENT+=$'\n---\n'
  echo "$CONTENT" > "$NEW_FILENAME"

  STR_NAV+="- ${NEW_FILENAME:2:-5}" # remove './'' at the beginning + .html extension
  STR_NAV+=$'\n'
done

IFS=$OLDIFS



echo "*** Retrieve templates"

cp -r $jekyll_templates_dir/* .

if [ "$1" = "--prod" ]; then
  mv _config.yml.prod _config.yml
else
  mv _config.yml.local _config.yml
fi

echo "*** Add navigation array to _config.yml"

echo "$STR_NAV" >> _config.yml

cd $source_dir
