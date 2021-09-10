#!/bin/sh

pip3 install -U pynvim pip
pip install -U pynvim pip
npm i -g bash-language-server typescript-language-server neovim pyright vscode-json-languageserver dockerfile-language-server-nodejs
GO111MODULE=on go get -u golang.org/x/tools/gopls@latest
wget https://github.com/tree-sitter/tree-sitter/releases/download/v0.20.0/tree-sitter-linux-x64.gz
gzip -d tree-sitter-linux-x64.gz
chmod +x tree-sitter-linux-x64
mv tree-sitter-linux-x64 /usr/bin/tree-sitter

# cargo install rnix-lsp
# cargo install stylua --features luau
# wget https://github.com/rust-analyzer/rust-analyzer/releases/download/2021-09-06/rust-analyzer-aarch64-apple-darwin.gz
# gzip -d rust-analyzer-aarch64-apple-darwin.gz

