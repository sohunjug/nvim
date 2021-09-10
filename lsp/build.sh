#!/bin/sh

cd lua-language-server/3rd/luamake
./compile/install.sh
cd ../..
./3rd/luamake/luamake rebuild
