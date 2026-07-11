extends Node2D

@export var expression_evaluator_lexer: ExpressionEvaluatorLexer
@export var dialogue_expression_evaluator: DialogueExpressionEvaluator

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	print(expression_evaluator_lexer.lex('{player.gold} <= 500 ? "you ar rich" : "you are broke"',dialogue_expression_evaluator))


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
