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
