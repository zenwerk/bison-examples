#ifndef AST_H
#define AST_H

#include <iostream>
#include <memory>

namespace ast {

enum class NodeType {
  INT,
  UNARY_OP,
  BIN_OP,
};

struct Node {
  NodeType type;
  int lineno = 0;
};

struct NodeInt {
  explicit NodeInt(int v) : value(v) {}
  Node node;
  int value;
};

struct NodeUnaryExpr {
  Node node;
  std::string op;
  Node* value;
};

struct NodeBinExpr : Node {
  Node node;
  std::string op;
  Node* lhs;
  Node* rhs;
};

Node* new_node_int(int);
Node* new_node_unary_expr(std::string, Node*);
Node* new_node_bin_expr(std::string, Node*, Node*);

void dump_node(Node* node);

}

#endif //AST_H
