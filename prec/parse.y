/* shift/reduce conflict */
%token NUMBER
%left '-'
%left '*'
%%
s   : expr
    ;

expr: expr '-' expr
    | expr '*' expr
    | '-' expr
    | NUMBER
    ;
%%

/*
    - 5 * 4 という入力列があったら
    -(5 * 4) ではなく
    (-5) * 4 として解釈されてほしい

    `-` より `*` の方が優先度が高いので
    - 5 . * 4 まで解析したときに `shift` してしまう
    そのため - (5 * 4) と解析される
*/