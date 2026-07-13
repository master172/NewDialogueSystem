extends Node
class_name DialogueExpressionInterface

@export var dialogue_expression_evaluator: DialogueExpressionEvaluator
@export var de_evaluator: DEEvaluator

func evaluate(input:String)->Variant:
	var tokens:Array[Token] = ExpressionEvaluatorLexer.lex(input,dialogue_expression_evaluator)
	var ast:ASTNode = DEParser.parse(tokens,dialogue_expression_evaluator)
	return de_evaluator.evaluate_ast(ast,dialogue_expression_evaluator)
