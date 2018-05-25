#!/bin/bash

dotfiles_root="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"/..
fonts_root=$dotfiles_root/fonts

if [[ $(uname) == 'Darwin' ]]; then
  dest_root=$HOME/Library/Fonts
else
  dest_root=$HOME/.fonts
  mkdir -p $dest_root
fi

echo 'Downloading fonts...'
mkdir $fonts_root/download
curl -Lo $fonts_root/download/SourceCodePro.zip https://github.com/ryanoasis/nerd-fonts/releases/download/v2.0.0/SourceCodePro.zip

echo 'Unpacking fonts...'
unzip $fonts_root/download/SourceCodePro.zip -d $fonts_root/download/

echo 'Copying fonts...'
find $fonts_root \( -name '*.[o,t]tf' -or -name '*.pcf.gz' \) -type f -print0 | xargs -0 -I {} cp "{}" "$dest_root/"

if command -v fc-cache @>/dev/null ; then
  echo 'Updating font cache...'
  fc-cache -f $dest_root
fi
