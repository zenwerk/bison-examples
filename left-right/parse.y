/* shift/reduce conflict */
%token NUMBER
%%
s   : expr
    ;

expr: expr '-' expr
    | expr '**' expr
    | NUMBER
    ;
%%

/*
    1 - 2 ** 3 という入力文字列は以下のように解釈されてほしい
    (1 - (2 ** 3))
*/