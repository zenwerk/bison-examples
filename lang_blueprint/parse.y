%{
#define YYDEBUG 1
#define YYERROR_VERBOSE 1
#define SIZE 4096

#include <stdlib.h>

#include "compiler.h"

void yyerror(Compiler* cmp, const char* s);
%}

%code requires {
#include "compiler.h"
}

%union {
  ast::Node *node;
  int num;
}

%parse-param {Compiler* cmp}

%type <node> expr

%define api.pure full /* 再入可能パーサー */
%define api.push-pull push /* プッシュパーサー */
%define parse.error verbose

%token NL
%token <num> NUMBER
%token LP
%token RP
%left ADDOP SUBOP
%left MULOP DIVOP
%right UMINUS

%%

s    : list
     ;

list : %empty
     | list expr NL { cmp->node = $2; }
     ;

expr : expr ADDOP expr { $$ = ast::new_node_bin_expr("+", $1, $3); }
     | expr SUBOP expr { $$ = ast::new_node_bin_expr("-", $1, $3); }
     | expr MULOP expr { $$ = ast::new_node_bin_expr("*", $1, $3); }
     | expr DIVOP expr
       {
           if ($3 == 0) { // TODO: 0 check は AST の実行時に行うべき?
               fprintf(stderr, "Zero Division Error\n");
               YYERROR;
           }
           $$ = ast::new_node_bin_expr("/", $1, $3);;
       }
     | SUBOP expr %prec UMINUS { $$ = ast::new_node_unary_expr("-", $2); }
     | LP expr RP              { $$ = $2; }
     | NUMBER                  { $$ = ast::new_node_int($1); }
     ;
%%

#include "lexer.cc"

void yyerror(Compiler* cmp, const char* s) {
    fprintf(stderr, "Parse error: %s\n", s);
}

/*
int interpret()
{
    int n;
    char buffer[SIZE];
    yypstate *ps = yypstate_new();

    do {
        printf("> ");
        fgets(buffer, SIZE, stdin);
        n = yylex(buffer, ps);
    } while (n > 0);

    if (ps != NULL) {
        printf("exit state = %d\n", n);
        yypstate_delete(ps);
    }

    return n;
}


int main(void)
{
    int n = 0;
    n = interpret();
    if (n != 0) return 1;

    return 0;
}
*/