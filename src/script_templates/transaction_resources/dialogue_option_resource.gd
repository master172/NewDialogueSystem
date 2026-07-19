extends Resource
class_name DialogueOptionResource

@export var text:String = ""

##if this condition evaluates to false the dialog will not be visible
@export var visible_condition:String = ""

##if this condition evaluates to true the option will be disabled
@export var disabled_condtion:String = ""
