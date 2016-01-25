#!/bin/bash

# @author Frosty-Z
# @date 2015-12-22
# @desc Processes .MD files from https://github.com/sveinburne/lets-play-science
#       to get .html files then upload them to https://github.com/dirtylab/dirtylab.github.io

# requires PHP 5+ to be installed on the system

# execution context agnostic
cd "${BASH_SOURCE%/*}" || (echo "FAILURE: impossible de trouver le répertoire courant" ; exit 1)

source_dir=$(pwd)

# lower-case definitions, not to risk any system-wide env conflict
wiki_repo_url="https://github.com/dirtylab/wiki"
wiki_repo_dir="$source_dir/../wiki"
jekyll_tmp_dir="$source_dir/../jekyll-build"
jekyll_templates_dir="$source_dir/../jekyll"
jekyll_includes_dir="_includes"
jekyll_build_dir="_site"
npm_dir="$source_dir/../client/"
fix_script_path="$source_dir/fixlinks.php"
emojize_script_path="$source_dir/emojize/emojize.php"


echo "*** Bundle and minify javascript sources with webpack"

cd $npm_dir
if [ "$1" = "--prod" ]; then
    grunt pack:prod
else
    grunt pack:dev
fi

echo "*** Clean/refresh directories"

if [ ! -d "$wiki_repo_dir" ]; then
  echo "*** Create $DEST_DIR directory from $wiki_repo_url"
  git clone $wiki_repo_url
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
