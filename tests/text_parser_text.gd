extends Node2D

@export var dialogue_expression_interface: DialogueExpressionInterface
@export var dialogue_variable_interface: DialogueVariableInterface

@export_multiline() var input:String
var context:DialogueContext = DialogueContext.new()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	context.expression_interface = dialogue_expression_interface
	context.variable_interface = dialogue_variable_interface
	print(TextParser.parse(input,context))


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
