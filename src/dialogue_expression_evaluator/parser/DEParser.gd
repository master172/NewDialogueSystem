extends Node
class_name DEParser

class SourcePackage:
	var tokens:Array[Token]
	var current:int = 0
	var runtime:DialogueExpressionEvaluator
	
	func _init(tokens_:Array[Token]=[],current_:int=0,runtime_:DialogueExpressionEvaluator=null) -> void:
		tokens = tokens_
		current = current_
		runtime = runtime_

#region helper_functions
static func previous(source:SourcePackage)->Token:
	return source.tokens.get(source.current-1)

static func peek(source:SourcePackage)->Token:
	return source.tokens.get(source.current)

static func is_at_end(source:SourcePackage)->bool:
	return peek(source)._type == DETokenTypes.TokenTypes.EOF

static func advance(source:SourcePackage)->Token:
	if !is_at_end(source): source.current += 1
	return previous(source)

static func check(type:DETokenTypes.TokenTypes,source:SourcePackage)->bool:
	if is_at_end(source): return false
	return peek(source)._type == type

static func match_token(types:Array[DETokenTypes.TokenTypes],source:SourcePackage)->bool:
	for type:DETokenTypes.TokenTypes in types:
		if check(type,source):
			advance(source)
			return true
	
	return false

static func consume(type:DETokenTypes.TokenTypes,message:String,source:SourcePackage)->void:
	if check(type,source):return advance(source)
	throw_error(source,peek(source),message)
	
static func throw_error(source:SourcePackage,token:Token,message:String)->void:
	source.runtime.error(token,message)
	push_error(peek(source),message)
	assert(false)
#endregion

static func parse(tokens:Array[Token],runtime:DialogueExpressionEvaluator)->ASTNode:
	var source_package:SourcePackage=SourcePackage.new(tokens,0,runtime)
	return expression(source_package)

static func expression(source:SourcePackage)->ASTNode:
	return equality(source)

static func equality(source:SourcePackage)->ASTNode:
	var expr:ASTNode = comparison(source)
	
	while match_token([DETokenTypes.TokenTypes.NOT_EQUAL,DETokenTypes.TokenTypes.EQUAL_EQUAL],source):
		var operator:Token = previous(source)
		var right:ASTNode = comparison(source)
		expr = BinaryASTNode.new(expr,operator,right)
	
	return expr

static func comparison(source:SourcePackage)->ASTNode:
	var expr:ASTNode = term(source)
	
	while match_token([DETokenTypes.TokenTypes.GREATER,DETokenTypes.TokenTypes.GREATER_EQUAL,\
	DETokenTypes.TokenTypes.LESSER,DETokenTypes.TokenTypes.LESSER_EQUAL],source):
		var operator:Token = previous(source)
		var right:ASTNode = term(source)
		expr = BinaryASTNode.new(expr,operator,right)
	
	return expr

static func term(source:SourcePackage)->ASTNode:
	var expr:ASTNode = factor(source)
	
	while match_token([DETokenTypes.TokenTypes.PLUS,DETokenTypes.TokenTypes.MINUS],source):
		var operator:Token = previous(source)
		var right:ASTNode = factor(source)
		expr = BinaryASTNode.new(expr,operator,right)
	
	return expr
	
static func factor(source:SourcePackage)->ASTNode:
	var expr:ASTNode = unary(source)
	
	while match_token([DETokenTypes.TokenTypes.SLASH,DETokenTypes.TokenTypes.STAR],source):
		var operator:Token = previous(source)
		var right:UnaryASTNode = unary(source)
		expr = BinaryASTNode.new(expr,operator,right)
	
	return expr

static func unary(source:SourcePackage)->ASTNode:
	var returning_token:UnaryASTNode
	
	if match_token([DETokenTypes.TokenTypes.NOT, DETokenTypes.TokenTypes.MINUS],source):
		var operator:Token = previous(source)
		var right:UnaryASTNode = unary(source)
		returning_token = UnaryASTNode.new(operator,right)
		return returning_token
		
	return primary(source)
	
static func primary(source:SourcePackage)->ASTNode:
	if match_token([DETokenTypes.TokenTypes.FALSE],source): return LiteralASTNode.new(false)
	if match_token([DETokenTypes.TokenTypes.TRUE],source): return LiteralASTNode.new(true)
	
	if match_token([DETokenTypes.TokenTypes.FLOAT,DETokenTypes.TokenTypes.INT,DETokenTypes.TokenTypes.STRING],source):
		return LiteralASTNode.new(previous(source)._literal)
	
	if match_token([DETokenTypes.TokenTypes.LEFT_PAREN],source):
		var expr:ASTNode = expression(source)
		consume(DETokenTypes.TokenTypes.RIGHT_PAREN,"expected ')' after expression",source)
		return GroupingASTNode.new(expr)
	else:
		throw_error(source,peek(source),"Expeceted expression.")
		return null
		

static func synchronize(source:SourcePackage)->void:
	advance(source)
	
	while !is_at_end(source):
		if previous(source)._type == DETokenTypes.TokenTypes.EOF: return
		
		match peek(source)._type:
			DETokenTypes.TokenTypes.VAR:
				pass
			_:
				pass
		
		advance(source)
