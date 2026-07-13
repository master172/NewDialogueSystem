extends Node2D

@export var dialogue_expression_evaluator: DialogueExpressionEvaluator
@export var dialogue_variable_interface: DialogueVariableInterface
@export var de_evaluator: DEEvaluator

var result:ASTNode

@export var message:String
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var tokens:Array[Token] = ExpressionEvaluatorLexer.lex(message,dialogue_expression_evaluator)
	result = DEParser.parse(tokens,dialogue_expression_evaluator)
	print(de_evaluator.evaluate_ast(result,dialogue_expression_evaluator))
