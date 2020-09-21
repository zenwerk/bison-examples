%{
/* C宣言部 */
#include <stdio.h>

#define YYDEBUG 1
#define YYERROR_VERBOSE 1
%}


/* bison-option */
%union {
    int intval;
}

%define api.pure full /* 再入可能パーサー */
%define api.push-pull push /* プッシュパーサー */
%define parse.error verbose

%{
void yyerror(const char *s);
static int syntax_check(FILE*, const char*);
static int syntax_check_file(const char*);
%}

%token END
%token NL
%token <intval> NUMBER
%token LP RP
%left ADDOP SUBOP
%left MULOP DIVOP
%right UMINUS
%right POWOP
%left FACTOP

%type<intval> expr

%start start

%%
/* 規則部 */
start: list { printf("終了\n"); }
;

list: /* empty */ { printf("電卓('end' で終了)\n"); }
    | list line
      {
        printf("enter expression or 'end': \n");
      }
;

line: expr NL
      {
        printf("答: %ld, 0x%lx, 0o%lo\n", $1, $1, $1);
      }
    | END NL
      {
        printf("終了します\n");
        YYACCEPT;
      }
    | error NL
;

expr: expr ADDOP expr { $$ = $1 + $3; }
    | expr SUBOP expr { $$ = $1 - $3; }
    | expr MULOP expr { $$ = $1 * $3; }
    | expr DIVOP expr
      {
        if ($3 == 0) {
          printf("0除算エラー\n");
          YYERROR;
        }
        $$ = $1 / $3;
      }
    | expr POWOP expr
      {
        if ($3 < 0) {
          printf("負の累乗\n");
          YYERROR;
        }
        $$ = power($1, $3);
      }
    | SUBOP expr %prec UMINUS { $$ = -$2; }
    | expr FACTOP
      {
        if ($1 < 0) {
          printf("負の階乗");
          YYERROR;
        }
        $$ = fact($1);
      }
    | LP expr RP { $$ = $2; }
    | NUMBER { $$ = $1; }
;

%%

#include "lex.yy.c"

int
power(int x, int y)
{
  int pw = 0;
  if (x == 0)
    return 0;
  else {
    pw = 1;
    for (int i = y; i; --i)
      pw *= x;
  }
  return pw;
}

int
fact(int x)
{
  int fc = 1;
  for (int i = x; i; --i)
    fc *= i;
  return fc;
}

void
yyerror(const char *s)
{
  fprintf (stderr, "%s\n", s);
}

static void
init(input_t *in, FILE *file)
{
    in->file = file;
    // 初期化のためSIZE分、下駄を履かせておく
    in->cursor = in->marker = in->token = in->limit = in->buf + SIZE;
    in->eof = 0;
    // ファイルを読み込む
    fill(in, 1);
}

static int
syntax_check(FILE *f, const char *fname)
{
  int n;
  input_t in;
  init(&in, f);

  n = yylex(&in);

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