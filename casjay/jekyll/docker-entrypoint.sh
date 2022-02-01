#!/bin/bash

if [ ! -f "./Gemfile" ]; then
  echo "NOTE: hmm, I don't see a Gemfile so I don't think there's a jekyll site here"
  echo "Either you didn't mount a volume, or you mounted it incorrectly."
  echo "Be sure you're in your jekyll site root and use something like this to launch"
  echo ""
  echo "docker run --name jekyll --rm -p 4000:4000 -v \$PWD:/site casjay/jekyll"
  echo ""
  echo "NOTE: To create a new site, you can use the sister image casjay/jekyll like:"
  echo ""
  echo "docker run -v \$(pwd):/site casjay/jekyll jekyll new ."
  exit 1
else
  bundle install --retry 5 --jobs 20
fi


case $1 in
  bash | sh | shell)
    shift 1
    [ $# -eq 0 ] && exec bash -l || exec bash "$@"
  ;;

  build)
    shift 1
    bundle exec jekyll build
  ;;

  *)
    bundle exec jekyll serve --force_polling -H 0.0.0.0 -P 4000
  ;;
esac
