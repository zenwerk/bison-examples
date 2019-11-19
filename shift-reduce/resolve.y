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