class_name LiteralASTNode
extends ASTNode

var value : Variant

func _init(value_ : Variant = null, )->void:
	value = value_

func accept(visitor:Visitor)->Variant:
	return visitor.visit_literal(self)
