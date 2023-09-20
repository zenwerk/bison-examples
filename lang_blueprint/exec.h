#ifndef EXEC_H
#define EXEC_H

#include <stack>

#include "ast.h"

using Val = int;

class Executor {
public:
  explicit Executor() : stack(std::stack<Val>()) {}
  void exec(ast::Node* node);

  std::stack<Val> stack;
};


#endif //EXEC_H
