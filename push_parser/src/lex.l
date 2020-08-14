%{
#include <stdlib.h>

/* C言語部 */
#define SEND(token, yylval) do {                              \
  int status = yypush_parse(pstate, token, yylval);  \
  if (status != YYPUSH_MORE) {                        \
    yypstate_delete(pstate);                          \
    return status;                                    \
  }                                                   \
} while (0)

%}

%option noyywrap

%%
  /* Cコードであることを示すためインデントする*/
  /* Initialize a parser state object */
  yypstate* pstate = yypstate_new();
  /* A semantic value which can be sent to the parser on each call */
  YYSTYPE yylval;
  /* Some example scanner actions */
[ \t]  ; /* eat whitespace */
"\\\n" ; /* eat newline */
"keyword" {
    /* Simple keyword which just sends a value-less token */
    SEND(KEYWORD, NULL);
}

[[:digit:]]+ {
    /* Token with a semantic value */
    yylval.intval = atoi(yytext);
    SEND(NUMBER, &yylval);
}

"dice-roll" {
    /* sends three random numbers */
    for (int i = 0; i < 3; ++i) {
        yylval.intval = rand() % 6;
        SEND(NUMBER, &yylval);
    }
}

<<EOF>> {
    /* Obligatory EOF rule */
    /* Send the parser the end token (0) */
    int status = yypush_parse(pstate, 0, NULL);
    /* Free the pstate */
    yypstate_delete(pstate);
    /* return the parser status; 0 is success */
    return status;
}
%%