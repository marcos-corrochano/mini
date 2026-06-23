package lexer

import "core:unicode"

scan_literal :: proc() -> Token {
	next(); for !is_done() {
		char := peek()
		if !is_utf8(char) do break
		if !unicode.is_letter(char) && !unicode.is_number(char) && char != '_' do break
		next()
	}

	return token(".Literal")
}

scan_number :: proc() -> Token {
	next(); for !is_done() {
		char := peek()
		if !is_utf8(char) do break

		if char == '.' {
			next()
			continue
		}

		if !unicode.is_number(char) do break
		next()
	}

	return token(".Number")
}
