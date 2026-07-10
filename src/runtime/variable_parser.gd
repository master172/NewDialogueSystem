extends Node
class_name VariableParser

static var symbol_regex:RegEx = RegEx.new()

static func init_symbol_regex()->void:
	symbol_regex.compile("\\{[^}]*\\}")

static func name_from_symbol(input:String)->String:
	return input.trim_prefix("{").trim_suffix("}").replace("$","")

static func parse_symbols(input:String)->String:
	var result:RegExMatch = symbol_regex.search(input)
	if result:
		return result.get_string()
	return ""

static func replace_symbols(input:String,variable_interface:DialogueVariableInterface)->String:
	var result:String = ""
	result = input
	var symbol:String = parse_symbols(result)
	while symbol != "":
		var variable_name:String = name_from_symbol(symbol)
		var value:Variant = variable_interface.get_from_dictionary(variable_name)
		if value == null:
			value = variable_name
		result  = result.replace(symbol,value)
		symbol = parse_symbols(result)
	
	return result

static func replace_symbols_from_array(input:PackedStringArray,variable_interface:DialogueVariableInterface)->PackedStringArray:
	var returning_array:PackedStringArray = []
	for i:String in input:
		returning_array.append(replace_symbols(i,variable_interface))
	return returning_array
