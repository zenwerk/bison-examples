%{
#define YYDEBUG 1
#define YYERROR_VERBOSE 1

int yylex();
void yyerror(const char* s);
%}


%token NL
%token NUMBER
%token LP
%token RP
%left ADDOP SUBOP
%left MULOP DIVOP

%%

s    : list

list : /* empty */
     | list expr NL { printf("%d\n", $2); }
     ;

expr : expr ADDOP expr { $$ = $1 + $3; }
     | expr SUBOP expr { $$ = $1 - $3; }
     | expr MULOP expr { $$ = $1 * $3; }
     | expr DIVOP expr { $$ = $1 / $3; }
     | LP expr RP      { $$ = $2; }
     | NUMBER          { $$ = $1; }
     ;
%%

#include "lex.yy.c"

int main() {
	yyin = stdin;

	do {
		yyparse();
	} while(!feof(yyin));

	return 0;
}


void yyerror(const char* s) {
	fprintf(stderr, "Parse error: %s\n", s);
	exit(1);
}