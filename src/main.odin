package main

import "core:fmt"
import "core:os"
import "lexer"

main :: proc() {
	data, ok := os.read_entire_file("main.mini", context.allocator)
	if ok != nil do panic("Error while reading mini file!")

	lexer.init(string(data))
	for token in lexer.tokenize() do fmt.println(token)
}
