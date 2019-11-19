/* shift/reduce conflict */
%token NUMBER
%%
s   : expr
    ;

expr: expr '-' expr
    | expr '*' expr
    | '-' expr
    | NUMBER
    ;
%%