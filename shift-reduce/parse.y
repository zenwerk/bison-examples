/* shift/reduce conflict */
%token A B P Q
%%
s   : list
    ;

list: x
    | list x

x   : A
    | A B P
    | B Q
    ;

%%
/*
    A B Q という入力列のとき
    A . B まで解析したとき先読みトークン `B` の解析は以下の2パターンになる

    1.  (x: A) (x: B Q)
    2.  (x: A B P)

    すなわち A . B までトークンを読み込んだとき
    先読みの `A` が 1 に属するものか 2 に属するものかが判断できない

    (x: A) ならば reduce して別の状態に遷移する
    (x: A B P) ならば `B` を shift してさらなるトークンを読み込む

    bison はデフォルトで shift するため `A B Q` の場合、`A B . Q` となり、対応するルールが無く syntax error となる
*/