/* shift/reduce conflict */
%token NUMBER
%left '-'
%left '*'
%right UMINUS
%%
s   : expr
    ;

expr: expr '-' expr
    | expr '*' expr
    | '-' expr      %prec UMINUS
    | NUMBER
    ;
%%

/*
    %prec で単項マイナス演算子を優先度高くする
*/