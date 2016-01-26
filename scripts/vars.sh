#!/bin/bash
# lower-case definitions, not to risk any system-wide env conflict

# wiki
wiki_repo_url="https://github.com/dirtylab/wiki"
wiki_repo_dir=$(cd "$source_dir/../wiki" && pwd)

# jekyll
jekyll_tmp_dir=$(cd "$source_dir/../jekyll-build" && pwd)
jekyll_templates_dir=$(cd "$source_dir/../jekyll" && pwd)
jekyll_includes_dir="_includes"
jekyll_build_dir="_site"

# npm
npm_dir=$(cd "$source_dir/../client/"  && pwd)

# static site
dest_repo_url="https://github.com/dirtylab/dirtylab.github.io"
dest_repo_path=$(cd "$source_dir/../dirtylab.github.io"  && pwd)

# scripts
fix_script_path="$source_dir/fixlinks.php"
emojize_script_path="$source_dir/emojize/emojize.php"

# meta
meta_dir=$(cd "$source_dir/../.build-meta"  && pwd)
last_commit_file="$meta_dir/lastCommit"