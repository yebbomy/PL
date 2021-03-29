%{
#include <stdio.h>
#include <stdlib.h>
float * stack = NULL;
int stackSize = 0;
int top = -1;
void push(float num);
float pop();
void yyerror(char * s);
%}

%token INTEGER

%%
start: 
	start '\n'
	|nothing
	|start expr '\n' {printf("\n==========\n%g\n==========\n",pop());}


expr:
	expr'+'parts {float s2 = pop(); float s1 = pop(); printf("+\n"); push(s1+s2);}
	| expr'-'parts {float s2= pop(); float s1 = pop(); printf("-\n"); push(s1-s2);} 
	| parts
parts:
	parts'*'unit {float s2 = pop(); float s1 = pop(); printf("*\n"); push(s1*s2);}
	| parts'/'unit {float s2 = pop(); float s1 = pop(); if(s2 == 0){yyerror("Cannot Dividing by 0!!\n");exit(1);}
printf("/\n"); push(s1/s2);}
	| unit
unit:
	primary
	| '+' unit /*do nothing*/
	| '-' unit {float s1 = pop(); s1 *= -1; printf("-\n"); push(s1);} 
primary:	
	'('expr')' {printf("()\n");} | INTEGER {float val = $1; push(val); printf("%g\n",val);}
nothing:
;
%%
void push(float num){
	if( top >= stackSize){stack = (float*)realloc(stack, (sizeof(float)*stackSize*2));
	stackSize *= 2;}
	top++;
	stack[top] = num;
}
float pop(void){
	if( top < 0 ) exit(1);
	else{
		float result = stack[top];
		top--; return result;
	}
}
void yyerror(char * s){
	fprintf(stderr,"%s\n",s);
}
int main(void){
	stack = (float *)malloc(sizeof(float)*100);
	if(stack == NULL){
		printf("malloc error!!\ntry again!\n"); exit(1);
	}
	stackSize = 100;
	yyparse();
	printf("end\n");
	free(stack);
	return 0;
}
