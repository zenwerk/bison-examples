YACC = bison -y
RE2C = re2c
TARGET = bin/push_parser

ifeq (Windows_NT,$(OS))
TARGET:=$(TARGET).exe
endif

TESTS=$(wildcard examples/*.txt)

all : $(TARGET)

.PHONY : all

test : all
	$(TARGET) $(TESTS)

.PHONY : test

src/y.tab.c : src/parse.y
	$(YACC) -v -o src/y.tab.c src/parse.y

src/lex.yy.c : src/lex.re2c
	$(RE2C) -o src/lex.yy.c src/lex.re2c

src/parse.o : src/y.tab.c src/lex.yy.c
	$(CC) -g -c src/y.tab.c -o src/parse.o

$(TARGET) : src/parse.o
	mkdir -p "$$(dirname $(TARGET))"
	$(CC) -g src/parse.o -o $(TARGET)

clean :
	rm -f src/y.output src/y.tab.c
	rm -f src/y.tab.c
	rm -f src/*.o $(TARGET)
.PHONY : clean

rebuild: clean all