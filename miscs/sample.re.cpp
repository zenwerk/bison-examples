// re2c $INPUT -o $OUTPUT
#include <assert.h>
#include <stdio.h>
#include <string.h>

/*!max:re2c*/
#define SIZE 4096

typedef struct {
    FILE *file;
    char buf[SIZE + YYMAXFILL], *limit, *cursor, *marker, *token;
    int eof;
} Input;

static int fill(Input *in, size_t need)
{
    // ファイル終端到達済みなら 1
    if (in->eof) {
        return 1;
    }
    // 残り容量が少ないなら 2
    // (現在解析している箇所 - バッファの開始地点) = これまで解析済みの領域
    const size_t free = in->token - in->buf;
    if (free < need) {
        return 2;
    }
    // in->buf       = バッファの開始地点
    // in->token     = 現在解析している箇所
    // (limit-token) = (バッファ末尾 - 現在解析している箇所) = 現在解析している箇所から後ろを捨てる
    memmove(in->buf, in->token, in->limit - in->token);
    // 解析済み容量分、アドレスをシフトしている
    in->limit -= free;
    in->cursor -= free;
    in->marker -= free;
    in->token -= free;
    in->limit += fread(in->limit, 1, free, in->file); // limit が指す箇所から 1byte, free分, fileから読み込んでコピー / 返り値は読み込んだバイト数
    // (末尾のアドレス < 開始 + SIZE のアドレス) -> 通常の読み込みサイズより少ない容量しか読み込んでいない -> ファイル終端まで読み込み済みである
    if (in->limit < in->buf + SIZE) {
        in->eof = 1; // 末尾まで到達しましたよーとフラグを立てる
        // 末尾から YYMAXFILL まで 0 で埋める
        memset(in->limit, 0, YYMAXFILL);
        in->limit += YYMAXFILL; // YYMAXFILL まで伸長する
    }

    return 0;
}

static void init(Input *in, FILE *file)
{
    in->file = file;
    // 初期化のためSIZE分、下駄を履かせておく
    in->cursor = in->marker
               = in->token
               = in->limit
               = in->buf + SIZE;
    in->eof = 0;
    // ファイルを読み込む
    fill(in, 1);
}

static int lex(Input *in)
{
    int count = 0;
loop:
    in->token = in->cursor;
    /*!re2c
    re2c:api:style = free-form;
    re2c:define:YYCTYPE  = char;
    re2c:define:YYCURSOR = in->cursor;
    re2c:define:YYMARKER = in->marker;
    re2c:define:YYLIMIT  = in->limit;
    re2c:define:YYFILL   = "if (fill(in, @@) != 0) return -1;";

    *                           { return -1; }
    [\x00]                      { return (YYMAXFILL == in->limit - in->token) ? count : -1; }
    ['] ([^'\\] | [\\][^])* ['] { ++count; goto loop; }
    [ ]+                        { goto loop; }

    */
}

int main()
{
    const char *fname = "input";  // ファイル名
    const char str[] = "'qu\0tes' 'are' 'fine: \\'' ";
    FILE *f;
    Input in;

    // prepare input file: a few times the size of the buffer,
    // containing strings with zeroes and escaped quotes
    // エラー回避のため読み込みファイルを自前で準備する
    f = fopen(fname, "w");
    for (int i = 0; i < SIZE; ++i) {
        fwrite(str, 1, sizeof(str) - 1, f);
    }
    fclose(f);

    f = fopen(fname, "r");
    init(&in, f);
    assert(lex(&in) == SIZE * 3);
    fclose(f);

    remove(fname);
    return 0;
}
