/* avoid reduce/reduce conflict */
%token A B X Y
%%
s   : ab1 X
    | ab2 Y
    ;

ab1 : A B
    ;

ab2 : A B
    ;

%%

/*
    コンフリクト解消例

    ab1, ab2 が同じ `A B` の規則でも先読みトークンが X, Y でそれぞれ異なるなら
    どちらの構文規則で reduce するか明らかにできる
*/