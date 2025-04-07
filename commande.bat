flex lexical.l
bison -d syntax.y
gcc lex.yy.c syntax.tab.c -lfl -o compiler.exe