
%{
#include <iostream>
#include <stdio.h>
#include "lex.yy.c"
extern int yylex();
extern int yylval;
void yyerror(const char* s) { std::cout<<"ERROR: "<<s<<" "<<yylval; }
%}

%define parse.error verbose
%verbose
%define parse.trace


%token PERCENT O
%token G00 G01 G02 G03 G80 G81 G82 G83 G84 G85 G86 G87 G88 G89
%token G17 G18 G19
%token G90 G91
%token G93 G94
%token G20 G21
%token G40 G41 G42
%token G43 G49
%token G98 G99
%token G54 G55 G56 G57 G58 G59
%token G61 G64
%token G04 G10 G28 G30 G53 G92
%token M00 M01 M02 M30 M60 M06 M03 M04 M05 M07 M08 M09 M48 M49
%token X Y Z A B C
%token I J K R
%token T D S
%token H F
%token INTEGER FLOAT
%token WS
%token EOL
%token COMMENT 

%%

program: percent oword lines percent;
lines: lines line | line;
line: blocks comm_opt eol | comm_opt eol | eol;
blocks: blocks block | block ;
block: gcode | coordinate | tool | mcode | speed | feed ;
gcode: group0 | group1 | group2 | group3 | group8 | group12 ;

eol: eol EOL | EOL
percent: PERCENT eol 
oword: O INTEGER comm_opt eol 

line_no.opt: %empty | INTEGER;
comm_opt: %empty | COMMENT;

group0 : G04 | G10 | G28 | G30 | G53 | G92;
group1 : G00 | G01 | G02 | G03 | G80 | G81 | G82 | G83 | G84 | G85 | G86 | G87 | G88 | G89;
group2 : G17 | G18 | G19 ; 
group3 : G90 | G91 ; 
group5 : G93 | G94 ; 
group6 : G20 | G21; 
group7 : G40 | G41 | G42 ; 
group8 : G43 | G49 ; 
group10 : G98 | G99 ; 
group12 : G54 | G55 | G56 | G57 | G58 | G59 ; 
group13 : G61 | G64 ; 
mcode : M06 | M03 | M05 | M09 | M30

coordinate: axis FLOAT
axis: X | Y | Z | A | B | C
tool: T INTEGER | H INTEGER
speed: S FLOAT | S INTEGER
feed: F FLOAT

%%
int main(int argc, char **argv)
{
    ++argv, --argc;
    yydebug=15;
    if(argc>0)
        yyin=fopen(argv[0],"r");
    else
        yyin=stdin;
    
    yyparse();

    return 0;
}

