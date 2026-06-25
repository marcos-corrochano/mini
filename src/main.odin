package main

import "core:fmt"
import "core:os"
import "lexer"
import "parser"

main :: proc() {
	data, ok := os.read_entire_file("main.mini", context.allocator)
	if ok != nil do panic("Error while reading mini file!")

	lexer.init(string(data))
	tokens := lexer.tokenize()
	for token in tokens do fmt.println(token)

	parser.init(tokens)
	program := parser.parse()
	for node in program.nodes do fmt.println(node^)
}
