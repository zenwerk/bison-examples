%option noyywrap

%%
"+"     return (ADDOP);
"-"     return (SUBOP);
"*"     return (MULOP);
"/"     return (DIVOP);
"("     return (LP);
")"     return (RP);
[0-9]+  { yylval = atoi(yytext); return (NUMBER); }
[ \t]   ;
\n      return (NL);
.       return (yytext[0]);
%%