#!/bin/bash

set -e

# Run JS build process
(cd "$(dirname "$0")" && yarn install --frozen-lockfile && yarn build)

if [ -n "$(git status --porcelain)" ]
then
  git status --porcelain
  >&2 echo "Please rebuild the JavaScript and commit the changes."
  >&2 echo "The above files changed when we built the JavaScript assets. This most often occurs when a user makes changes to the JavaScript sources but doesn't rebuild and commit them."
  exit 1
else
  echo "No difference detected; JavaScript build is current."
fi


# Build Shiny's CSS
R -e "if (!require('rprojroot')) install.packages('rprojroot')"
R -e "if (!require('sass')) install.packages('sass')"
Rscript tools/updateShinyCSS.R

if [ -n "$(git status --porcelain)" ]
then
  git status --porcelain
  >&2 echo "Please run tools/updateShinyCSS.R and commit the changes."
  exit 1
else
  echo "No difference detected; shiny.css build is current."
fi
