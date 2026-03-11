gc: parser.c  lex.yy.c
	g++ parser.c -o gc

parser.c: gc.y
	bison -d -o parser.c gc.y

lex.yy.c: gc.lex
	flex -s -d gc.lex

clean:
	rm gc
	rm *.c
	rm parser* 
	rm test.* 
	
test:
	./gc test/3.NCF 2> test.3.NCF
