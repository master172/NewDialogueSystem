class_name VariableASTNode
extends ASTNode

var identifier_name : Token

func _init(identifier_name_ : Token = Token.new(), )->void:
	identifier_name = identifier_name_
