extends Node
class_name DialogueExpressionEvaluator

@export var variable_interface:DialogueVariableInterface
var had_error:bool = false

func throw_error(line:int, message:String)->void:
	had_error = DialogueErrorHandling.error(line, message)

func error(token:Token,messgae:String)->void:
	if token._type == DETokenTypes.TokenTypes.EOF:
		had_error = true
		DialogueErrorHandling.report(token._line," at end ", messgae)
	else:
		had_error = true
		DialogueErrorHandling.report(token._line, " at "+ token._lexme+  "'" , messgae)
