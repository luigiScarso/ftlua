##
##
##
DIR=/usr
rm -vf freetype_wrap.c
swig   -lua freetype.i 
echo %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
gcc -Wall -fPIC -I. -c freetype_wrap.c -I$DIR/include  -I$DIR/include/freetype2 -I/usr/include/lua5.1 -o freetype_wrap.o
rm -vf freetype.so
gcc -Wall -shared -I. -I$DIR/include -I$DIR/include/freetype2 -I/usr/include/lua5.1 -L. -L$DIR/lib  freetype_wrap.o  -lfreetype -lm  -lz -lbz2  -o freetype.so
strip --strip-unneeded freetype.so
lua -e 'require("freetype")'





