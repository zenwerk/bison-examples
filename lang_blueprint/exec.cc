#include "exec.h"

void Executor::exec(ast::Node *node) {
  switch (node->type) {
    case ast::NodeType::INT: {
      auto intnd = (ast::NodeInt *) node;
      auto v = intnd->value;
      if (&this->stack == nullptr) {
        printf("NULLだよ\n");
      }
      this->stack.push(v);
    }
      break;
    case ast::NodeType::UNARY_OP: {
      auto unary_expr = (ast::NodeUnaryExpr *) node;
      this->exec(unary_expr->value);
      auto val = this->stack.top();
      this->stack.pop();
      auto op = unary_expr->op;
      if (op == "-")
        this->stack.push(-1 * val);
    }
      break;
    case ast::NodeType::BIN_OP: {
      auto bin_expr = (ast::NodeBinExpr *) node;
      this->exec(bin_expr->lhs);
      this->exec(bin_expr->rhs);
      auto rhs = this->stack.top();
      this->stack.pop();
      auto lhs = this->stack.top();
      this->stack.pop();

      auto op = bin_expr->op;
      if (op == "+")
        this->stack.push(lhs + rhs);
      else if (op == "-")
        this->stack.push(lhs - rhs);
      else if (op == "*")
        this->stack.push(lhs * rhs);
      else if (op == "/")
        // TODO: 0除算時にエラー値を返す
        this->stack.push(lhs / rhs);
    }
      break;
    default:
      break;
  }
}
