package lexer

Kind :: enum {
	// Arithmetic operators
	Plus,
	Minus,
	Star,
	Slash,
	Percentage,

	// Comparison operators
	Gt,
	Lt,
	GtEq,
	LtEq,
	Equals,

	// Logical operators
	Bang,
	And,
	Or,

	// Assignment
	Assign,
	Arrow,

	// Delimiters
	LeftParen,
	RightParen,
	LeftBracket,
	RightBracket,
	LeftBrace,
	RightBrace,

	// Punctuation
	Dot,
	Comma,
	Semi,
	Colon,

	// Literals
	Identifier,
	String,
	Rune,
	Number,
	Float,
	Quote,

	// Types
	Bool,
	Byte,
	Int8,
	Int16,
	Int32,
	Int64,
	Uint8,
	Uint16,
	Uint32,
	Uint64,
	Float32,
	Float64,

	// Keywords
	True,
	False,
	If,
	Else,
	For,
	Break,
	Continue,
	When,
	Pub,
	Fn,

	// Control
	EOF,
}

Keyword := #partial [Kind]string {
	.String   = "string",
	.Bool     = "bool",
	.Byte     = "byte",
	.True     = "true",
	.False    = "false",
	.If       = "if",
	.Else     = "else",
	.For      = "for",
	.Break    = "break",
	.Continue = "continue",
	.When     = "when",
	.Pub      = "pub",
	.Fn       = "fn",
	.Float32  = "f32",
	.Float64  = "f64",
	.Int8     = "i8",
	.Int16    = "i16",
	.Int32    = "i32",
	.Int64    = "i64",
	.Uint8    = "u8",
	.Uint16   = "u16",
	.Uint32   = "u32",
	.Uint64   = "u64",
	.Rune     = "rune",
}

Token :: struct {
	kind:  Kind,
	value: Maybe(string),
	start: int,
	end:   int,
	line:  int,
}

token :: proc(kind: Kind) -> Token {
	lexeme: Maybe(string)
	lexeme = lexer.source[lexer.start:lexer.offset]

	if kind == .EOF {
		lexeme = nil
		lexer.start = -1
		lexer.offset = -1
		lexer.column = -1
	}

	return Token {
		kind = kind,
		value = lexeme,
		start = lexer.start,
		end = lexer.offset,
		line = lexer.line,
	}
}
