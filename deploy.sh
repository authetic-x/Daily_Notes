#!/usr/bin/env sh

# throw error
set -e

# build static
npm run build
cd .vuepress/dist
# echo "xin-tan.com" > CNAME

git init
git add -A
git commit -m 'deploy'

git push -f git@github.com:authetic-x/FE-Notes.git master:gh-pages

cd -

 