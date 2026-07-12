extends Node2D

@export var dialogue_expression_evaluator: DialogueExpressionEvaluator

var result:ASTNode

@export var message:String
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var tokens:Array[Token] = ExpressionEvaluatorLexer.lex(message,dialogue_expression_evaluator)
	result = DEParser.parse(tokens,dialogue_expression_evaluator)
	var printer:PrettyPrintVisitor = PrettyPrintVisitor.new()
	printer.visit(result)
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
