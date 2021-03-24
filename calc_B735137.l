%{
#include <stdio.h>
#include <stdlib.h>
#include "y.tab.h"
void yyerror(char*);
%}
%%
[0-9]+	{yylval = atoi(yytext); return INTEGER;}
[a-z|A-z]+	{yyerror("invalid character");}
[-+/*]	{return *yytext;}
[()]	{return *yytext;}
[\n]	{return *yytext;}
%%

int yywrap(void){
	return 1;
}

