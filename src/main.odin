package main

import "core:fmt"
import "core:os"
import "core:unicode"

Token :: struct {
	type:  string,
	value: Maybe(string),
}

Lexer :: struct {
	source: string,
	start:  int, // Where the token starts
	column: int,
	line:   int,
	offset: int,
}

lexer: Lexer

main :: proc() {
	data, ok := os.read_entire_file("main.mini", context.allocator)
	if ok != nil do panic("Error while reading mini file!")

	lexer.source = string(data)
	lexer.line = 1
	tokens := make([dynamic]Token)

	for !done() {
		char := peek()
		lexer.start = lexer.offset

		if !is_utf8(char) {
			fmt.println("Invalid character!")
			os.exit(1)
		}

		if unicode.is_space(char) {
			next()
			continue
		}

		switch {
		case unicode.is_letter(char), char == '_':
			append(&tokens, literal())
		case unicode.is_number(char):
			append(&tokens, number())
		case:
			fmt.println("Unhandled character '%s'", char)
			os.exit(1)
		}
	}

	for token in tokens do fmt.println(token)
}

peek :: proc() -> rune {
	if done() do return -1
	return rune(lexer.source[lexer.offset])
}

next :: proc() -> rune {
	if done() do return -1
	current := lexer.source[lexer.offset]

	if current == '\n' {
		lexer.column = 0
		lexer.line += 1
	}

	lexer.column += 1
	lexer.offset += 1
	return rune(current)
}

done :: proc() -> bool {
	return lexer.offset >= len(lexer.source)
}

tok :: proc(type: string) -> Token {
	lexeme := lexer.source[lexer.start:lexer.offset]
	return Token{type = type, value = lexeme}
}

is_utf8 :: proc(char: rune) -> bool {
	return char <= unicode.MAX_ASCII
}

literal :: proc() -> Token {
	next(); for !done() {
		char := peek()
		if !is_utf8(char) do break
		if !unicode.is_letter(char) && !unicode.is_number(char) && char != '_' do break
		next()
	}

	return tok(".Literal")
}

number :: proc() -> Token {
	next(); for !done() {
		char := peek()
		if !is_utf8(char) do break

		if char == '.' {
			next()
			continue
		}

		if !unicode.is_number(char) do break
		next()
	}

	return tok(".Number")
}
