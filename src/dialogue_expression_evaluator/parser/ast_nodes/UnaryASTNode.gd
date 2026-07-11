class_name UnaryASTNode
extends ASTNode

var operator : Token
var right : ASTNode

func _init(operator_ : Token = Token.new(), right_ : ASTNode = ASTNode.new(), )->void:
	operator = operator_
	right = right_

func accept(visitor:Visitor)->Variant:
	return visitor.visit_unary(self)
