#ifndef lexer_h
#define lexer_h

#include <memory>
#include "y.tab.h"
#include "compiler.h"

int yylex(char*, Compiler*, yypstate*);

#endif