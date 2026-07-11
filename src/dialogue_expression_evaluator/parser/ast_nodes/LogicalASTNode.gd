class_name LogicalASTNode
extends ASTNode

var left : ASTNode
var operator : Token
var right : ASTNode

func _init(left_ : ASTNode = ASTNode.new(), operator_ : Token = Token.new(), right_ : ASTNode = ASTNode.new(), )->void:
	left = left_
	operator = operator_
	right = right_

func accept(visitor:Visitor)->Variant:
	return visitor.visit_logical(self)
