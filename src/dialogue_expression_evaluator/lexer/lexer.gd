extends Node
class_name ExpressionEvaluatorLexer

static var DEReserved:Dictionary[String,DETokenTypes.TokenTypes] = {
	"and":DETokenTypes.TokenTypes.AND,
	"or":DETokenTypes.TokenTypes.OR,
	"true":DETokenTypes.TokenTypes.TRUE,
	"false":DETokenTypes.TokenTypes.FALSE,
	#"null":DETokenTypes.TokenTypes.NULL,
}

class SourceInfo:
	var start:int = 0
	var current:int = 0
	var line:int = 1
	var source:String = ""
	
	func _init(source_:String="",start_:int=0,current_:int=0,line_:int=1) -> void:
		start = start_
		current = current_
		line = line_
		source = source_



static func lex(input:String,DERuntime:DialogueExpressionEvaluator)->Array[Token]:
	var source:SourceInfo = SourceInfo.new(input)
	var returning_tokens:Array[Token] = []
	returning_tokens = scan_tokens(source,DERuntime)
	return returning_tokens

static func scan_tokens(source:SourceInfo,DERuntime:DialogueExpressionEvaluator)->Array[Token]:
	var returning_tokens:Array[Token] = []
	while !is_at_end(source):
		#at the beginning of the next lexme
		source.start = source.current
		scan_token(source,returning_tokens,DERuntime)
	
	returning_tokens.append(Token.new(DETokenTypes.TokenTypes.EOF,"",null))
	return returning_tokens

static func is_at_end(source:SourceInfo)->bool:
	return source.current >= source.source.length()

static func scan_token(source:SourceInfo,returning_tokens:Array[Token],DERuntime:DialogueExpressionEvaluator)->void:
	var character:String = advance(source)
	match character:
		"(":
			returning_tokens.append(Token.new(DETokenTypes.TokenTypes.LEFT_PAREN))
		")":
			returning_tokens.append(Token.new(DETokenTypes.TokenTypes.RIGHT_PAREN))
		"{":
			variable(source,returning_tokens,DERuntime)
		"+":
			returning_tokens.append(Token.new(DETokenTypes.TokenTypes.PLUS))
		"-":
			returning_tokens.append(Token.new(DETokenTypes.TokenTypes.MINUS))
		"*":
			returning_tokens.append(Token.new(DETokenTypes.TokenTypes.STAR))
		"/":
			returning_tokens.append(Token.new(DETokenTypes.TokenTypes.SLASH))
		"%":
			returning_tokens.append(Token.new(DETokenTypes.TokenTypes.MODULO))
		"?":
			returning_tokens.append(Token.new(DETokenTypes.TokenTypes.TERENARY))
		":":
			returning_tokens.append(Token.new(DETokenTypes.TokenTypes.COLON))
		"!":
			returning_tokens.append(Token.new(DETokenTypes.TokenTypes.NOT_EQUAL if match_token(source,"=") else DETokenTypes.TokenTypes.NOT))
		"=":
			returning_tokens.append(Token.new(DETokenTypes.TokenTypes.EQUAL_EQUAL if match_token(source,"=") else DETokenTypes.TokenTypes.EQUAL))
		"<":
			returning_tokens.append(Token.new(DETokenTypes.TokenTypes.LESSER_EQUAL if match_token(source,"=") else DETokenTypes.TokenTypes.LESSER))
		">":
			returning_tokens.append(Token.new(DETokenTypes.TokenTypes.GREATER_EQUAL if match_token(source,"=") else DETokenTypes.TokenTypes.GREATER))
		" ":
			pass
		"\r":
			pass
		"\t":
			pass
		"\n":
			source.line += 1
			pass
		'"':
			string(source,returning_tokens,DERuntime)
		_:
			if is_digit(character):
				number(source,returning_tokens,DERuntime)
			elif is_alpha(character):
				identifier(source,returning_tokens,DERuntime)
			else:
				push_error("unidentified token type")
				DERuntime.throw_error(source.line,"Unexpected character")

static func advance(source:SourceInfo)->String:
	source.current += 1
	return source.source[source.current-1]

static func match_token(source:SourceInfo,expected:String)->bool:
	if is_at_end(source):return false
	if (source.source[source.current] != expected): return false
	
	source.current += 1
	return true

static func peek(source:SourceInfo)->String:
	if is_at_end(source):return ""
	return source.source[source.current]

static func peek_next(source:SourceInfo)->String:
	if source.current + 1 >= source.source.length():return ""
	return source.source[source.current + 1]

static func string(source:SourceInfo,resulting_tokens:Array[Token],runtime:DialogueExpressionEvaluator)->void:
	while (!is_at_end(source) and peek(source) != '"'):
		if peek(source) == "\n": source.line += 1
		advance(source)
	
	if is_at_end(source):
		runtime.throw_error(source.line,"Unterminated String")
		return
	
	advance(source) #this is done to include the closing "
	var lexme:String = source.source.substr(source.start + 1, (source.current - source.start) - 2)
	var value:String = source.source.substr(source.start,(source.current - source.start))
	resulting_tokens.append(Token.new(DETokenTypes.TokenTypes.STRING, value,lexme,source.line))

static func number(source:SourceInfo,returning_tokens:Array[Token],rintime:DialogueExpressionEvaluator)->void:
	var is_float:bool = false
	
	while is_digit(peek(source)):advance(source)
	
	if peek(source) == "." and is_digit(peek_next(source)):
		advance(source)
		is_float = true
		while is_digit(peek(source)):advance(source)
	
	if is_float:
		var value:float = float(source.source.substr(source.start,(source.current - source.start)))
		returning_tokens.append(Token.new(DETokenTypes.TokenTypes.FLOAT,str(value),value,source.line))
	else:
		var value:int = int(source.source.substr(source.start,(source.current - source.start)))
		returning_tokens.append(Token.new(DETokenTypes.TokenTypes.INT,str(value),value,source.line))

static func identifier(source:SourceInfo,returning_tokens:Array[Token],Runtime:DialogueExpressionEvaluator)->void:
	while is_alpha_numeric(peek(source)):advance(source)
	
	var text:String = source.source.substr(source.start,(source.current - source.start))
	var token_type:DETokenTypes.TokenTypes = DEReserved.get(text,-1)
	if token_type == -1:
		token_type = DETokenTypes.TokenTypes.IDENTIFIER
	returning_tokens.append(Token.new(token_type,text,text,source.line))

static func variable(source:SourceInfo,returning_tokens:Array[Token],Runtime:DialogueExpressionEvaluator)->void:
	while is_variable_name_allowed(peek(source)):advance(source)
	if peek(source) != "}":
		Runtime.throw_error(source.line,"Unterminated variable identifier")
		return
	
	advance(source)
	var value:String = source.source.substr(source.start + 1,(source.current - source.start)-2)
	var lexme:String = source.source.substr(source.start, (source.current - source.start))
	returning_tokens.append(Token.new(DETokenTypes.TokenTypes.VAR,lexme,value,source.line))

#region numeric helpers
static func is_digit(c:String)->bool:
	if c.is_empty():
		return false
	var ascii:int = ord(c)
	return ascii >= 48 and ascii <= 57

static func is_alpha(c:String)->bool:
	if c.is_empty():
		return false
	var value:int  = ord(c)
	return value >= ord('a') and value <= ord('z') or value >= ord('A') and value <= ord('Z') or value == ord("_")

static func is_alpha_numeric(c:String)->bool:
	return is_alpha(c) or is_digit(c)

static func variable_allowed(c:String)->bool:
	return ord(c) == ord("$") or ord(c) == ord(".")

static func is_variable_name_allowed(c:String)->bool:
	return is_alpha_numeric(c) or variable_allowed(c)
#endregion
