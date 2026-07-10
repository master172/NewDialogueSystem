extends Node
class_name DialogueVariableInterface

@export var variables:Dictionary[String,Variant] = {}

func write_to_dictionary(input:String,value:Variant)->void:
	var directories:PackedStringArray = input.split(".")
	var pointer:Dictionary = variables
	
	if directories.is_empty():
		push_error("empty key provided")
		return
	
	if directories.size() == 1:
		variables[directories[0]] = value
		return
	
	for i:int in directories.size() - 1:
		if not pointer.has(directories[i]):
			pointer[directories[i]] = {}
		if not pointer[directories[i]] is Dictionary:
			push_error("value already exsits but not of type dictionary")
			return
		pointer = pointer[directories[i]]
	
	var last:int = directories.size() - 1
	var key:String = directories[last]
	pointer[key] = value

func get_from_dictionary(input:String)->Variant:
	var path:PackedStringArray = input.split(".")
	var pointer:Dictionary = variables
	
	if path.is_empty():
		push_error("empty path provided")
		return
	
	if path.size() == 1:
		return variables.get(path[0],null)
		
	for i:int in path.size() -1:
		if not pointer.has(path[i]):
			push_error("Invalid Path")
			return null
		pointer = pointer[path[i]]
	
	var last:int = path.size() -1
	var key:String = path[last]
	return pointer.get(key,null)

func has_in_dictionary(input:String)->bool:
	var path:PackedStringArray = input.split(".")
	var pointer:Dictionary = variables
	
	if path.is_empty():
		push_error("empty path provided")
		return false
	
	if path.size() == 1:
		return variables.has(path[0])
		
	for i:int in path.size() -1:
		if not pointer.has(path[i]):
			return false
		pointer = pointer[path[i]]
	
	var last:int = path.size() -1
	var key:String = path[last]
	return pointer.has(key)
	
