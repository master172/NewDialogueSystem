extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var node:BinaryASTNode = BinaryASTNode.new(
		UnaryASTNode.new(
			Token.new(DETokenTypes.TokenTypes.MINUS,"-",null,1),
			LiteralASTNode.new(123)
		),
		Token.new(DETokenTypes.TokenTypes.STAR,"*",null,1),
		GroupingASTNode.new(
			LiteralASTNode.new(45.67)
		)
	)
	var printer:PrettyPrintVisitor = PrettyPrintVisitor.new()
	printer.visit(node)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
