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