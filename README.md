# bison サンプル

### left-right
`%left`, `%right` を使った shift/reduceコンフリクトの解消

### prec
`%prec` を使った演算子優先順位の調整

### prec-2
`%prec` を使った演算子優先順位の調整 その２

### reduce-reduce
reduce/reduceコンフリクトの解消

### shift-reduce
shift/reduceコンフリクトの解消

## yacc の優先度・結合規則の決定ルール
1. `%left`, `%right` に書かれたトークン, リテラル文字列の優先度・結合規則が yacc 側に記録される
2. 各構文規則の右辺の最後のトークン or リテラル文字列の優先度・結合規則が、その構文規則の優先度・結合規則となる
     - `%prec` がある場合はそっちが優先される
     - 規則によっては優先度・結合規則がない場合もある
3. 優先度・結合規則が未定義時の競合発生時は以下の動作
    - `reduce/reduce` なら先に記述されたルールで還元
    - `shift/reduce` なら `shift`
4. shift/reduce時
    - 規則と先読みトークンが優先度・結合規則があるとき
        - 優先度 -> 先読みトークン > 規則 then `shift`, else `reduce`
        - 優先度 -> 先読みトークン = 規則 then `%left`, `%right` で結合, `%nonassoc` のときは `syntax error`

## 参考文献
[yacc/lex―プログラムジェネレータon UNIX](https://www.amazon.co.jp/dp/4924998141)