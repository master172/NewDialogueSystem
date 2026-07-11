@tool
extends EditorScript

var base_line:String = "extends ASTNode"

var ast_definition:PackedStringArray = [
	"Binary : left ASTNode, operator Token, right ASTNode",
	"Grouping : ast_node ASTNode",
	"Literal: value Variant",
	"Unary : operator Token, right ASTNode",
	"Variable : identifier_name Token",
	"Assignment : identifier_name Token, value ASTNode",
	"Logical : left ASTNode, operator Token, right ASTNode",
	"Ternary : condition ASTNode, true_branch ASTNode, false_branch ASTNode"
	]

var output_directory:String = "res://src/dialogue_expression_evaluator/parser/ast_nodes/"
var output_file:String = "ASTNode.gd"

class DefinedAST:
	var default_map:Dictionary[String,String] = {
		"ASTNode":"ASTNode.new()",
		"Token":"Token.new()",
		"Variant":"null"
	}
	var base:String
	var parameters:Dictionary[String,String]
	
	func _get_content()->String:
		return _to_string()
	
	func _to_string() -> String:
		var returning_string:String = "class_name " + base  + "ASTNode\n"
		returning_string += "extends ASTNode\n\n"
		for i:String in parameters.keys():
			returning_string += "var "+i + " : " + parameters[i] + "\n"
		returning_string += "\n"
		var parameter_list_defined:String = ""
		for i:String in parameters.keys():
			parameter_list_defined += i+"_" + " : " + parameters[i] + " = " + default_map[parameters[i]]+ ", "
		
		returning_string += "func _init(" + parameter_list_defined + ")->void:\n"
		for i:String in parameters.keys():
			var function_line:String = "\t"
			function_line += i + " = " + i + "_\n" 
			returning_string += function_line
		return returning_string

func iterate_and_create(list:PackedStringArray)->void:
	for i:String in list:
		var ast_node:DefinedAST = create_from_string(i)
		var base_name:String = ast_node.base + "ASTNode.gd"
		var content:String = ast_node._get_content()
		if FileAccess.file_exists(output_directory+output_file):
			print("exsists")
			return
		var file:FileAccess = FileAccess.open(output_directory + base_name,FileAccess.WRITE)
		file.store_string(content)
		file.close()

func create_from_string(value:String)->DefinedAST:
	var defined_ast:DefinedAST = DefinedAST.new()
	var base:String = value.split(":")[0].strip_edges()
	defined_ast.base = base
	var parameters:PackedStringArray = value.split(":")[1].split(",")

	for i:String in parameters:
		i = i.strip_edges()
		var literal_name:String = i.split(" ")[0].strip_edges()
		var literal_type:String = i.split(" ")[1].strip_edges()
		defined_ast.parameters[literal_name] = literal_type
	
	return defined_ast

func _run() -> void:
	iterate_and_create(ast_definition)
