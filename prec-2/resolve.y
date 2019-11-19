/* shift/reduce conflict */
%left '|'
%left CHAR '('
%left CAT
%left '+'

%%
s   : expr '\n'
    ;

expr: '(' expr ')'
    | expr '+'
    | expr expr %prec CAT
    | expr '|' expr
    | CHAR
    ;

%%

/*
    abc という入力列のとき
    ab . c まで解析したとき、後続のトークン `c`(CHAR) の優先度, 結合規則が未指定のため
    shift/reduce conflict が起きる
    '(' の競合も同じ理由

    よって CHAR, '(' に結合規則を定義する
*/