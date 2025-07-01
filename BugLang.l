%{
#include <stdio.h>
#include <string.h>
%}

INICIO "start"
FIM "end"
VAR "var" 
STRING \"[^\"]*\"
NUMBER [0-9]+(\.[0-9]+)?

MAIOR ">"
MENOR "<"
MAI ">="
MEI "<="
II "=="
DIF "!="

PRINT "print"
SCAN "read"
IF "if"
ELSE "else"
WHILE "while"

ID [a-zA-Z_][a-zA-Z0-9_]*
CL "//".* 
CB "/""*"(.|\n)*"*""/"

%%

{INICIO} { return INICIO; }
{FIM} { return FIM; }
{VAR} { return VAR; }
{STRING} {
    strcpy(yylval.str, yytext);
    return STRING;
}
{NUMBER} {
    yylval.flo = atof(yytext);
    return NUMBER;
}
{PRINT} { return PRINT; }
{SCAN} { return SCAN; }
{IF} { return IF; }
{ELSE} { return ELSE; }
{WHILE} { return WHILE; }
{MAIOR} { yylval.fn = 1; return CMP; }
{MENOR} { yylval.fn = 2; return CMP; }
{MAI} { yylval.fn = 3; return CMP; }
{MEI} { yylval.fn = 4; return CMP; }
{II} { yylval.fn = 5; return CMP; }
{DIF} { yylval.fn = 6; return CMP; }
{ID} {
    strcpy(yylval.str, yytext);
    return ID;
}
{CL} {;}
{CB} {;}
"+"|"-"|"/"|"*"|"%"|"=" { return *yytext; }
[(){};] { return *yytext; }
[ \t\n\r]* {;}
%%

int yywrap() {
    return 1;
}