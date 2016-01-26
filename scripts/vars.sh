#!/bin/bash
# lower-case definitions, not to risk any system-wide env conflict

echo $source_dir
# wiki
wiki_repo_url="https://github.com/dirtylab/wiki"
wiki_repo_dir=$(dirname "$source_dir/../wiki" )

# jekyll

jekyll_tmp_dir=$(dirname "$source_dir/../jekyll-build"  )
jekyll_templates_dir=$(dirname "$source_dir/../jekyll"  )
jekyll_includes_dir="_includes"
jekyll_build_dir="_site"

# npm
npm_dir=$(dirname "$source_dir/../client/"   )

# static site
dest_repo_url="https://github.com/dirtylab/dirtylab.github.io"
dest_repo_path=$(dirname "$source_dir/../dirtylab.github.io"   )

# scripts
fix_script_path="$source_dir/fixlinks.php"
emojize_script_path="$source_dir/emojize/emojize.php"

# meta
meta_dir=$(dirname "$source_dir/../.build-meta"   )
last_commit_file="$meta_dir/lastCommit"