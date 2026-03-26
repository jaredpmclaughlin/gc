
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
// Group 1 
%token G00 G01 G02 G03 G382 G80 G81 G82 G83 G84 G85 G86 G87 G88 G89
// Group 2
%token G17 G18 G19
// Group 3
%token G90 G91
// Group 5
%token G93 G94
// Group 6
%token G20 G21
// Group 7
%token G40 G41 G42
// Group 8
%token G43 G49
// Group 10
%token G98 G99
// Group 12
%token G54 G55 G56 G57 G58 G59 G591 G592 G593
// Group 13
%token G61 G611 G64
// Group 0
%token G04 G10 G28 G30 G53 G92 G921 G922 G923
// Group 4
%token M00 M01 M02 M30 M60 
// Group 6
%token M06 
// Group 7
%token M03 M04 M05 
// Group 8
%token M07 M08 M09
// Group 9
%token M48 M49

%token X Y Z A B C
%token I J K R
%token T D S
%token H F
%token INTEGER FLOAT
%token WS
%token EOL
%token COMMENT 
%token SLASH

%%

/*
arc_tangent_combo = arc_tangent + expression + divided_by + expression .
binary_operation = binary_operation1 | binary_operation2 | binary_operation3 .
binary_operation1 = power .
binary_operation2 = divided_by | modulo | times .
binary_operation3 = and | exclusive_or | minus | non_exclusive_or | plus .
comment = message | ordinary_comment .
comment_character = see explanation above .
digit = zero | one | two | three | four | five | six | seven | eight | nine .
expression = left_bracket + real_value + { binary_operation + real_value } + right_bracket .
line = [block_delete] + [line_number] + {segment} + end_of_line .
line_number = letter_n + digit + [digit] + [digit] + [digit] + [digit] .
message = left_parenthesis + {white_space} + letter_m + {white_space} + letter_s +
{white_space} + letter_g + {white_space} + comma + {comment_character} +
right_parenthesis .
mid_line_letter = letter_a | letter_b | letter_c| letter_d | letter_f | letter_g | letter_h | letter_i
| letter_j | letter_k | letter_l | letter_m | letter_p | letter_q | letter_r | letter_s | letter_t
| letter_x | letter_y | letter_z .
mid_line_word = mid_line_letter + real_value .
ordinary_comment = left_parenthesis + {comment_character} + right_parenthesis .
ordinary_unary_combo = ordinary_unary_operation + expression .
ordinary_unary_operation =
absolute_value | arc_cosine | arc_sine | cosine | e_raised_to |
fix_down | fix_up | natural_log_of | round | sine | square_root | tangent .
parameter_index = real_value .
parameter_setting = parameter_sign + parameter_index + equal_sign + real_value .
parameter_value = parameter_sign + parameter_index .
real_number =
[ plus | minus ] +
(( digit + { digit } + [decimal_point] + {digit}) | ( decimal_point + digit + {digit})) .
real_value = real_number | expression | parameter_value | unary_combo .
segment = mid_line_word | comment | parameter_setting .
unary_combo = ordinary_unary_combo | arc_tangent_combo .
white_space = space | tab .
*/

program: percent oword lines_opt percent;

lines_opt: %empty | lines;
lines: lines line | line;
line: block_delete_opt line_no.opt blocks_opt comm_opt eol ; 
// line = [block_delete] + [line_number] + {segment} + end_of_line .
block_delete_opt: %empty | SLASH ;
blocks_opt: %empty | blocks ;
blocks: blocks block | block ;
block: gcode | coordinate | tool | mcode | speed | feed ;
gcode: group0 | group1 | group2 | group3 |
       group5 | group6 | group7 | group8 | 
       group10 | group12 | group13;
mcode: mcode4 | mcode6 | mcode7 | mcode8 | mcode9 ;

eol: eol EOL | EOL
percent: PERCENT eol 
oword: O INTEGER comm_opt eol 

line_no.opt: %empty | INTEGER;
comm_opt: %empty | COMMENT;

group0 : G04 | G10 | G28 | G30 | 
         G53 | G92 | G921 | G922 | G923;

group1 : G00 | G01 | G02 | G03 | 
         G382 | G80 | G81 | G82 |
         G83 | G84 | G85 | G86 |
         G87 | G88 | G89;

group2 : G17 | G18 | G19 ; 

group3 : G90 | G91 ; 

group5 : G93 | G94 ; 

group6 : G20 | G21; 

group7 : G40 | G41 | G42 ; 

group8 : G43 | G49 ; 

group10 : G98 | G99 ; 

group12 : G54 | G55 | G56 | G57 | G58 | G59 | G591 | G592 | G593; 

group13 : G61 | G611 | G64 ; 

mcode4 : M00 | M01 | M02 | M30 | M60;

mcode6 : M06 ; 

mcode7 : M03 | M04 |M05 ;

mcode8 : M07 | M08 | M09 ; 

mcode9 : M48 | M49 ;

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

