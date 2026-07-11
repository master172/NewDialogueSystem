extends Node
class_name DialogueExpressionEvaluator

var had_error:bool = false

func throw_error(line:int, message:String)->void:
	had_error = DialogueErrorHandling.error(line, message)
