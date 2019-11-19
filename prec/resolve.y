/* shift/reduce conflict */
%token NUMBER
%left '-'
%left '*'
%right UMINUS
%%
s   : expr
    ;

expr: expr '-' expr
    | expr '*' expr
    | '-' expr      %prec UMINUS
    | NUMBER
    ;
%%