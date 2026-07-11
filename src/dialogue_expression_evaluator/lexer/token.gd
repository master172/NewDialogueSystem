extends Resource
class_name Token

var _type:DETokenTypes.TokenTypes
var _lexme:String = ""
var _literal:Variant = null
var _line:int = -1

func _init(type:DETokenTypes.TokenTypes = DETokenTypes.TokenTypes.NULL, lexme:String = "",literal:Variant = null,line:int = -1) -> void:
	_type = type
	_lexme = lexme
	_literal = literal
	_line = line
	
func _to_string() -> String:
	return str(DETokenTypes.TokenTypes.keys()[_type]) + " " + _lexme + " " + str(_literal)
