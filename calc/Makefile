YACC = bison -y
LEX = flex
TARGET = calc

ifeq (Windows_NT,$(OS))
TARGET:=$(TARGET).exe
endif


all : $(TARGET)

.PHONY : all


y.tab.c : parse.y
	$(YACC) -v -o y.tab.c parse.y

lex.yy.c : lex.l
	$(LEX) -o lex.yy.c lex.l

parse.o : y.tab.c lex.yy.c
	$(CC) -g -c y.tab.c -o parse.o

$(TARGET) : parse.o
	$(CC) -g parse.o -o $(TARGET)

clean :
	rm -f y.output y.tab.c
	rm -f lex.yy.c
	rm -f *.o $(TARGET)
.PHONY : clean

rebuild: clean all