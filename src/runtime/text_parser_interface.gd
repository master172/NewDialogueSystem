extends Node
class_name TextParser

class TextSource:
	var start:int = -1
	var pos:int = -1
	var text:String = ""
	var context:DialogueContext
	
	func _init(begin:int,position:int,input:String,requirements:DialogueContext) -> void:
		start = begin
		pos = position
		text = input
		context = requirements
		
static func parse(text:String,context:DialogueContext)->String:
	var source:TextSource = TextSource.new(0,0,text,context)
	var returning_parts:PackedStringArray
	
	while is_in_bounds(source):
		returning_parts.append(parse_loop(source))
	
	var returning_string:String = "".join(returning_parts)
	
	return returning_string

static func parse_loop(source:TextSource)->String:
	source.start = source.pos
	var current_char:String = source.text[source.pos]
	match current_char:
		"{":
			return parse_variables(source)
		"[":
			return parse_expressions(source)
		_:
			return parse_text(source)

static func parse_expressions(source:TextSource)->String:
	var end_found:bool = false
	
	while is_in_bounds(source):
		var c:String = source.text[source.pos]
		if c == "]":
			end_found = true
			source.pos += 1
			break
		
		source.pos += 1
	
	if not end_found:
		push_error("expression declaration not terminated with ]")
		return ""
		
	var expression:String =  source.text.substr(source.start + 1, (source.pos -source.start) -2)
	return str(source.context.expression_interface.evaluate(expression))
	
static func parse_text(source:TextSource)->String:
	while is_in_bounds(source):
		var c:String = source.text[source.pos]
		if is_non_expression_character(c):
			break
		source.pos += 1
	
	return source.text.substr(source.start,source.pos-source.start)
	
static func parse_variables(source:TextSource)->String:
	var end_found:bool = false
	
	while is_in_bounds(source):
		var c:String = source.text[source.pos]
		if c == "}":
			end_found = true
			source.pos += 1
			break
		
		source.pos += 1
	
	if not end_found:
		push_error("variable declaration not terminated with }")
		return ""
	
	var identifier_name:String =  source.text.substr(source.start + 1, (source.pos -source.start) -2)
	return str(source.context.variable_interface.get_from_dictionary(identifier_name))

static func is_non_expression_character(c:String)->bool:
	return c == "{" or c == "["

static func is_in_bounds(source:TextSource)->bool:
	return source.pos < source.text.length()
