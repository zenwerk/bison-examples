/* Generated by re2c 2.0.3 on Tue Nov 10 02:20:32 2020 */
#line 1 "eof_enable_yyfill_disable.re.c"
// re2c $INPUT -o $OUTPUT
#include <assert.h>
#include <stdlib.h>
#include <string.h>

// expect a string without terminating null
static int lex(const char *str, unsigned int len)
{
    const char *cur = str, *lim = str + len, *mar;
    int count = 0;

loop:
    
#line 17 "eof_enable_yyfill_disable.c"
{
	char yych;
	yych = cur < lim ? *cur : 0;
	switch (yych) {
	case ' ':	goto yy4;
	case '\'':	goto yy7;
	default:
		if (cur >= lim) goto yyeof1;
		goto yy2;
	}
yy2:
	++cur;
yy3:
#line 25 "eof_enable_yyfill_disable.re.c"
	{ return -1; }
#line 33 "eof_enable_yyfill_disable.c"
yy4:
	++cur;
	yych = cur < lim ? *cur : 0;
	switch (yych) {
	case ' ':	goto yy4;
	default:	goto yy6;
	}
yy6:
#line 28 "eof_enable_yyfill_disable.re.c"
	{ goto loop; }
#line 44 "eof_enable_yyfill_disable.c"
yy7:
	++cur;
	mar = cur;
	yych = cur < lim ? *cur : 0;
	if (yych >= 0x01) goto yy9;
	if (cur >= lim) goto yy3;
yy8:
	++cur;
	yych = cur < lim ? *cur : 0;
yy9:
	switch (yych) {
	case '\'':	goto yy10;
	case '\\':	goto yy12;
	default:
		if (cur >= lim) goto yy13;
		goto yy8;
	}
yy10:
	++cur;
#line 27 "eof_enable_yyfill_disable.re.c"
	{ ++count; goto loop; }
#line 66 "eof_enable_yyfill_disable.c"
yy12:
	++cur;
	yych = cur < lim ? *cur : 0;
	if (yych <= 0x00) {
		if (cur >= lim) goto yy13;
		goto yy8;
	}
	goto yy8;
yy13:
	cur = mar;
	goto yy3;
yyeof1:
#line 26 "eof_enable_yyfill_disable.re.c"
	{ return count; }
#line 81 "eof_enable_yyfill_disable.c"
}
#line 30 "eof_enable_yyfill_disable.re.c"

}

// make a copy of the string without terminating null
static void test(const char *str, unsigned int len, int res)
{
    char *s = (char*) malloc(len);
    memcpy(s, str, len);
    int r = lex(s, len);
    free(s);
    assert(r == res);
}

#define TEST(s, r) test(s, sizeof(s) - 1, r)
int main()
{
    TEST("", 0);
    TEST("'qu\0tes' 'are' 'fine: \\'' ", 3);
    TEST("'unterminated\\'", -1);
    return 0;
}
