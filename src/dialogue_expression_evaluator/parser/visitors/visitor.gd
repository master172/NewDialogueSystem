@abstract extends Node
class_name Visitor

func visit(node:ASTNode)->void:
	node.accept(self)
