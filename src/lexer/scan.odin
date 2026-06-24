package lexer

import "core:fmt"
import "core:os"
import "core:unicode"

scan_literal :: proc() -> Token {
	for !is_done() {
		char := peek()

		if !is_ascii(char) {
			fmt.println("Invalid character!")
			os.exit(1)
		}

		if !unicode.is_letter(char) && !unicode.is_number(char) && char != '_' do break
		next()
	}

	return token(.Identifier)
}

scan_number :: proc() -> Token {
	for !is_done() {
		char := peek()

		if !is_ascii(char) {
			fmt.println("Invalid character!")
			os.exit(1)
		}

		if char == '.' {
			next()
			continue
		}

		if !unicode.is_number(char) do break
		next()
	}

	return token(.Int8)
}
