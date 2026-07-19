extends Node
class_name DETokenTypes

enum TokenTypes {
	#single-character tokens
	LEFT_PAREN,RIGHT_PAREN,
	PLUS,MINUS,STAR,SLASH,MODULO,
	TERENARY,COLON,
	
	#assignment
	EQUAL,
	
	#LITERALS
	IDENTIFIER,STRING,INT,FLOAT,VAR,
	
	#comparison
	EQUAL_EQUAL,NOT_EQUAL,GREATER,LESSER,
	GREATER_EQUAL,LESSER_EQUAL,
	
	#boolean logic
	AND,OR,NOT,
	
	#keywords
	NULL, EOF, TRUE, FALSE, DEL
}
