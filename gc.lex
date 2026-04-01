%{
#include "parser.h"
%}

N "n"|"N"
G "g"|"G"
M "m"|"M"
O "o"|"O"

X "x"|"X"
Y "y"|"Y"
Z "z"|"Z"

I "i"|"I"
J "j"|"J"
K "k"|"K"

A "a"|"A"
B "b"|"B"
C "c"|"C"

R "r"|"R"
T "t"|"T"
D "d"|"D"
S "s"|"S"
H "h"|"H"
F "f"|"F"

SLASH "/"
DIGIT [0-9]
FLOAT "-"?([0-9]+\.[0-9]*|[0-9]*\.[0-9]+)
COMMENT "(".*")"
WS [ \t] 

%option noyywrap

%%

{N}         return N;
"%"         return PERCENT; 
{O}         return O;

    /* Motion codes */
    /* Group 1 */
{G}(0|00)   return G00; 
{G}(1|01)   return G01;
{G}(2|02)   return G02; 
{G}(3|03)   return G03;
{G}38.2     return G382;
{G}80       return G80;
{G}81       return G81;
{G}82       return G82;
{G}83       return G83;
{G}84       return G84;
{G}85       return G85;
{G}86       return G86;
{G}87       return G87;
{G}88       return G88;
{G}89       return G89;

    /* Plane Selection */
    /* Group 2 */
{G}17       return G17; 
{G}18       return G18; 
{G}19       return G19; 

    /* Distance Mode */
    /* Group 3 */
{G}90       return G90; 
{G}91       return G91; 

    /* Feed Rate Mode */
    /* Group 5 */
{G}93       return G93; 
{G}94       return G94;

    /* Unit */
    /* Group 6 */
{G}20       return G20; 
{G}21       return G21; 

    /* Cutter Radius Compensation */
    /* Group 7 */
{G}40       return G40; 
{G}41       return G41; 
{G}42       return G42; 

    /* Tool Length Offset */
    /* Group 8 */
{G}43       return G43; 
{G}49       return G49; 

    /* Canned Cycle Return */
    /* Group 10 */
{G}98       return G98; 
{G}99       return G99; 

    /* Coordinate System */
    /* Group 12 */
{G}54       return G54; 
{G}55       return G55; 
{G}56       return G56; 
{G}57       return G57; 
{G}58       return G58; 
{G}59       return G59; 
{G}59.1     return G591; 
{G}59.2     return G592; 
{G}59.3     return G593; 

    /* Path Control */
    /* Group 13 */
{G}61       return G61; 
{G}61.1     return G611; 
{G}64       return G64; 

    /* Non-Modal */
    /* Group 0 */
{G}(4|04)   return G04; 
{G}10       return G10; 
{G}28       return G28; 
{G}30       return G30; 
{G}53       return G53; 
{G}92       return G92; 
{G}92.1     return G921; 
{G}92.2     return G922; 
{G}92.3     return G923; 

    /* Miscellaneous Codes */

    /* Stopping */
    /* Group 4 */
{M}(0|00)   return M00; 
{M}(1|01)   return M01; 
{M}(2|02)   return M02; 
{M}30       return M30; 
{M}60       return M60; 

    /* Tool Change */
    /* Group 6 */
{M}(6|06)   return M06; 

    /* Spindle Turning */
    /* Group 7 */
{M}(3|03)   return M03; 
{M}(4|04)   return M04; 
{M}(5|05)   return M05; 

    /* Coolant */
    /* Group 8 */
{M}(7|07)   return M07; 
{M}(8|08)   return M08; 
{M}(9|09)   return M09; 

    /* speed and feed override */
    /* Group 9 */
{M}48       return M48; 
{M}49       return M49; 

{COMMENT}   return COMMENT; 

    /* axis commands */
{X}         return X;
{Y}         return Y;
{Z}         return Z;

{A}         return A;
{B}         return B;
{C}         return C;

    /* CENTERPOINTS */
{I}         return I;
{J}         return J;
{K}         return K;

    /* Radius */
{R}         return R;

{T}         return T;
{D}         return D;
{S}         return S;

{H}         return H;
{F}         return F;

{DIGIT}+    {sscanf(yytext,"%d",&yylval); return INTEGER;}
{FLOAT}     {sscanf(yytext,"%f",&yylval); return FLOAT;}

\n          return EOL; 
\r          return EOL; 
{SLASH}     return SLASH;
{WS}+       ;


%%

