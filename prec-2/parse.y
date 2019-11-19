/* shift/reduce conflict */
%token CHAR
%left '|'
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
    正規表現ぽい構文を受理したい構文定義

    ab+  なら (ab)+
    a|bc なら a|(ab)
    として解釈されたい

    よって演算子が存在しない単なる文字の並び `expr expr` に %prec で優先度を付与する

    しかし abc という入力列のとき
    ab . c まで解析したとき、後続のトークン `c`(CHAR) の優先度, 結合規則が未指定のため
    shift/reduce conflict が起きる
    '(' の競合も同じ理由
*/