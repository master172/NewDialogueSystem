class_name AssignmentASTNode
extends ASTNode

var identifier_name : Token
var value : ASTNode

func _init(identifier_name_ : Token = Token.new(), value_ : ASTNode = ASTNode.new(), )->void:
	identifier_name = identifier_name_
	value = value_
