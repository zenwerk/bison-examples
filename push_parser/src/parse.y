%{
/* C宣言部 */
#include <stdio.h>

#define YYDEBUG 1
#define YYERROR_VERBOSE 1
%}
/* bison-option */

%union {
    int intval;
    char* str;
}

%define api.pure full /* 再入可能パーサー */
%define api.push-pull push /* プッシュパーサー */
%define parse.error verbose

%{
void yyerror(const char *s);
static int syntax_check(FILE*, const char*);
static int syntax_check_file(const char*);
%}

%token <str> KEYWORD
%token <intval> NUMBER
%start start

%%
/* 規則部 */
// start: factors
//      | factors start
// ;

// factors: keywords
//        | numbers
//        ;
start: keywords
     | numbers
;

keywords: /* empty */
        | keywords keyword
;

keyword: KEYWORD
           {
             printf("you entered 'keyword'\n");
           }
;

numbers: /* empty */
       | numbers number
;

number: NUMBER
         {
           printf("number -> %d\n", $1);
         }
;

%%

#include "lex.yy.c"


void
yyerror(const char *s)
{
  fprintf (stderr, "%s\n", s);
}

static int
syntax_check(FILE *f, const char *fname)
{
  int n;

  yyin = f;
  n = yylex();

  if (n == 0) {
    printf("%s: Syntax OK\n", fname);
    return 0;
  }
  else {
    printf("%s: Syntax NG\n", fname);
    return 1;
  }
}

static int
syntax_check_file(const char* fname)
{
  int n;
  FILE *f = fopen(fname, "r");

  if (f == NULL) {
    fprintf(stderr, "failed to open file: %s\n", fname);
    return 1;
  }
  n = syntax_check(f, fname);
  fclose(f);
  return n;
}

int
main(int argc, const char **argv)
{
  int i, n = 0;
  if (argc == 1) {
    n = syntax_check(stdin, "stdin");
  }
  else {
    for (i=1; i<argc; i++) {
      n += syntax_check_file(argv[i]);
    }
  }

  if (n > 0) return 1;
  return 0;
}