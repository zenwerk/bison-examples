/* reduce/reduce conflict が起きる例 */
%token A B X
%%
s   : ab1 X
    | ab2 X
    ;

ab1 : A B
    ;

ab2 : A B
    ;

%%

/*
    A B X の入力列があるとき解析木が以下の2パターンになる
    1.  (ab1: A B) X
    2.  (ab2: A B) X

    すなわち A B . X までトークンを読み込んだとき
    先読みの `A B` が ab1 に属するものか ab2 に属するものかが判断できない
*/