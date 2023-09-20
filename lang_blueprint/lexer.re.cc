#include <stdlib.h>
#include <string.h>
#include <memory>

#include "lexer.h"
#include "compiler.h"

#define PUSH_TOKEN(token, yylval) do {               \
  int status = yypush_parse(pstate, token, yylval, cmp);  \
  if (status != YYPUSH_MORE) {                       \
    return status;                                   \
  }                                                  \
} while (0)

int yylex(char *cursor, Compiler* cmp, yypstate *pstate)
{
    int num;
    char *marker;
    char *token;

loop:
    token = cursor;
/*!re2c
    re2c:api:style = free-form;
    re2c:define:YYCTYPE  = char;
    re2c:define:YYCURSOR = cursor;
    re2c:define:YYMARKER = marker;
    re2c:yyfill:enable   = 0;

    D = [0-9];
    N = [1-9];

    *      { return -1; }
    [\x00] { return 1; }
    [ \t]  { goto loop; }

    "exit" { return 0; }

    "+"  { PUSH_TOKEN(ADDOP, NULL); goto loop; }
    "-"  { PUSH_TOKEN(SUBOP, NULL); goto loop; }
    "*"  { PUSH_TOKEN(MULOP, NULL); goto loop; }
    "/"  { PUSH_TOKEN(DIVOP, NULL); goto loop; }
    "("  { PUSH_TOKEN(LP, NULL); goto loop; }
    ")"  { PUSH_TOKEN(RP, NULL); goto loop; }
    "\n" { PUSH_TOKEN(NL, NULL); goto loop; }

    "0" {
        num = 0;
        YYSTYPE *token;
        token->num = 0;
        PUSH_TOKEN(NUMBER, token);
        goto loop;
    }

    N{1}D* {
        size_t size = cursor - token;
        char *yytext = (char *)calloc(size, sizeof(char));
        memcpy(yytext, token, size);
        num = atoi(yytext);
        YYSTYPE *token;
        token->num = num;
        PUSH_TOKEN(NUMBER, token);
        free(yytext);
        goto loop;
    }
*/
}