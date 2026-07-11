class_name TernaryASTNode
extends ASTNode

var condition : ASTNode
var true_branch : ASTNode
var false_branch : ASTNode

func _init(condition_ : ASTNode = ASTNode.new(), true_branch_ : ASTNode = ASTNode.new(), false_branch_ : ASTNode = ASTNode.new(), )->void:
	condition = condition_
	true_branch = true_branch_
	false_branch = false_branch_

func accept(visitor:Visitor)->Variant:
	return visitor.visit_ternary(self)
