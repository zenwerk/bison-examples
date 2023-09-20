#include <cstdlib>
#include <fstream>
#include <iostream>
#include <string>

#include "lexer.h"
#include "compiler.h"
#include "exec.h"

int interpret(const std::string& src, yypstate* ps) {
  char *in = const_cast<char *>(src.c_str());
  // コンパイラ構造体の作成. TODO: 作成のタイミングはここでよいか?
  auto cmp = std::make_unique<Compiler>();
  auto exe = new Executor(); // TODO: make_uniqueで作るとエラーになる

  int n = yylex(in, cmp.get(), ps);

  printf("AST: ");
  ast::dump_node(cmp->node);
  printf("\n");

  if (n > 0) {
    exe->exec(cmp->node);
    printf("Result: %d\n", exe->stack.top());
    exe->stack.pop();
  }
  delete(exe);

  return n;
}

int run_file(const char *filename) {
  std::ifstream file(filename, std::ios::binary);
  if (!file) {
    std::cerr << "Error: Could not open file '" << filename << "'." << std::endl;
    exit(74);
  }

  std::string source;
  std::string line;
  while (std::getline(file, line)) {
    source += line + '\n';
  }

  if (file.bad()) {
    std::cerr << "Error: An error occurred while reading the file." << std::endl;
    exit(1);
  }

  int n;
  yypstate *ps = yypstate_new();
  n = interpret(source, ps);
  yypstate_delete(ps);

  return n;
}

int repl() {
  int n;
  std::string source;
  yypstate *ps = yypstate_new();

  std::cout << "\"exit\"で終了" << std::endl;
  do {
    std::cout << "> ";
    std::getline(std::cin, source);
    source += "\n";
    n = interpret(source, ps);
  } while (n > 0);

  yypstate_delete(ps);
  return n;
}

int main(int argc, char *argv[]) {
  int n = 0;
  if (argc == 1) {
    n = repl();
  } else if (argc == 2) {
    // TODO: 1. ファイル読み込み
    n = run_file(argv[1]);
  } else {
    fprintf(stderr, "Usage: calc [path]\n");
    exit(64);
  }

  // TODO: 3. コンパイル処理の起動
  // TODO: 4. VMの初期化と起動 | init_vm();
  // TODO: 5. 実行 | run();

  return n;
}