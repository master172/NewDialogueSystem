extends Node
class_name DialogueErrorHandling

static func error(line:int, message:String)->bool:
	return report(line,"",message)

static func report(line:int, where:String ,message:String)->bool:
	push_error("[line "+str(line)+ " ] Error" + where + ": "+message)
	return true
