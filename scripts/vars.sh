#!/bin/bash
# lower-case definitions, not to risk any system-wide env conflict

projet_root_dir=$(cd "$source_dir/../" && pwd)

echo "project root dir computed to : $projet_root_dir"

# wiki
wiki_repo_url="https://github.com/dirtylab/wiki"
wiki_repo_dir="$projet_root_dir/wiki" 

# jekyll

jekyll_tmp_dir= "$projet_root_dir/jekyll-build"
jekyll_templates_dir= "$projet_root_dir/jekyll"
jekyll_includes_dir="_includes"
jekyll_build_dir="_site"

# npm
npm_dir= "$projet_root_dir/client/"

# static site
dest_repo_url="https://github.com/dirtylab/dirtylab.github.io"
dest_repo_path= "$projet_root_dir/dirtylab.github.io"

# scripts
fix_script_path="$source_dir/fixlinks.php"
emojize_script_path="$source_dir/emojize/emojize.php"

# meta
meta_dir= "$projet_root_dir/.build-meta"
last_commit_file="$meta_dir/lastCommit"