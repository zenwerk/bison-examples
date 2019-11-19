/* shift/reduce conflict sample */
%token A B C
%%
s   : x y
    ;

x   : A
    | A B
    ;

y   : B C
    | C
    ;

%%
/*
    A B C の入力列があるとき解析木が以下の2パターンになる
    1.  (x: A B) (y: C)
    2.  (x: A) (y: B C)

    すなわち A . B ... までトークンを読み込んだとき
    先読みの `B` が x に属するものか y に属するものかが判断できない
    x に属するなら shift して `A B .` に遷移
    y に属するなら A を reduce して別の状態に遷移しなければならない
*/