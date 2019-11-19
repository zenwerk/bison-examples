/* shift/reduce conflict */
%token NUMBER
%left '-'
%right '*'
%%
s   : expr
    ;

expr: expr '-' expr
    | expr '*' expr
    | NUMBER
    ;
%%