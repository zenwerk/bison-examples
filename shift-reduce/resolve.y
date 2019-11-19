/* avoid shift/reduce conflict */
%token A B BP Q /* B, BP の区別は lex 側で行う */
%%
s   : list
    ;

list: x
    | list x

x   : A
    | A BP
    | B Q
    ;

%%

/*
    コンフリクト解消例

    BP は `B P` が連なる場合に字句解析木(flex)から渡されるトークン.
    これによって 1つの先読みトークンだけで
    `B` が `A B P` なのか `B Q` のどちらの構文規則に属するものなのか判断できる
*/