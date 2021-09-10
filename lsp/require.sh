#!/bin/sh

pip3 install -U pynvim pip
pip install -U pynvim pip
npm i -g bash-language-server typescript-language-server neovim pyright
GO111MODULE=on go get -u golang.org/x/tools/gopls@latest
wget https://github.com/tree-sitter/tree-sitter/releases/download/v0.20.0/tree-sitter-linux-x64.gz
gzip -d tree-sitter-linux-x64.gz
chmod +x tree-sitter-linux-x64
mv tree-sitter-linux-x64 /usr/bin/tree-sitter
