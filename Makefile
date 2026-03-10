gc: parser.c  lex.yy.c
	g++ parser.c -o gc

parser.c: gc.y
	bison -d -o parser.c gc.y

lex.yy.c: gc.lex
	flex -s -d gc.lex
