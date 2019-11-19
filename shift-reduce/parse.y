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
    A . B Q まで解析したとき
    先読みトークン `B` が
    A . B P なのか -        > shift する
    . B Q なのか判断できない -> A を x として reduce する
*/