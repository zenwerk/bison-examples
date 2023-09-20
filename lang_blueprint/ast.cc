#include <stdlib.h>
#include "ast.h"

namespace ast {

#define ALLOCATE_NODE(type, nodeType) \
    (type*)allocateNode(sizeof(type), nodeType)

// allocateObject は size 分のメモリを確保し, その Obj ポインタを返す
static Node *allocateNode(size_t size, NodeType type) {
  // Nodeの初期化
  Node *node = (Node *) malloc(size);
  node->type = type;
  // node->lineno = 0; TODO: lexer から現在の行数を受け取る

  return node;
}

Node *new_node_int(int val) {
  NodeInt *node = ALLOCATE_NODE(NodeInt, NodeType::INT);
  node->value = val;
  return (Node *) node;
}

Node *new_node_unary_expr(std::string op, Node *nd) {
  NodeUnaryExpr *node = ALLOCATE_NODE(NodeUnaryExpr, NodeType::UNARY_OP);
  node->op = op;
  node->value = nd;
  return (Node *) node;
}

Node *new_node_bin_expr(std::string op, Node *lhs, Node *rhs) {
  NodeBinExpr *node = ALLOCATE_NODE(NodeBinExpr, NodeType::BIN_OP);
  node->op = op;
  node->lhs = lhs;
  node->rhs = rhs;
  return (Node *) node;
}

void dump_node(Node *node) {
  switch (node->type) {
    case NodeType::INT: {
      auto intnd = (NodeInt *) node;
      printf("%d", intnd->value);
    }
      break;
    case NodeType::UNARY_OP: {
      auto unary_expr = (NodeUnaryExpr *) node;
      printf("%s", unary_expr->op.c_str());
      dump_node(unary_expr->value);
    }
      break;
    case NodeType::BIN_OP: {
      auto bin_expr = (NodeBinExpr *) node;
      printf("(");
      dump_node(bin_expr->lhs);
      printf("%s", bin_expr->op.c_str());
      dump_node(bin_expr->rhs);
      printf(")");
    }
      break;
    default:
      break;
  }
}

};