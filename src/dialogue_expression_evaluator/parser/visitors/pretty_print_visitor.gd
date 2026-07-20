extends Visitor
class_name PrettyPrintVisitor

func visit(node:ASTNode)->void:
	print(node.accept(self))

func parenthesize(given_name:String,arguments:Array[ASTNode])->String:
	var returning_string:String = ""
	returning_string += "( " + given_name + " "
	
	for i:ASTNode in arguments:
		returning_string += " " + i.accept(self)
	returning_string += " )"
	
	return returning_string

func visit_binary(node:BinaryASTNode)->String:
	return parenthesize(node.operator._lexme, [node.left,node.right])

func visit_grouping(node:GroupingASTNode)->String:
	return parenthesize("group",[node.ast_node])

func visit_literal(node:LiteralASTNode)->String:
	if node.value == null:
		return "null"
	return str(node.value)

func visit_unary(node:UnaryASTNode)->String:
	return parenthesize(node.operator._lexme, [node.right])

func visit_variable(node:VariableASTNode)->String:
	return "(%s)" % node.identifier_name._lexme

func visit_assignment(node:AssignmentASTNode)->String:
	return parenthesize("= " + node.identifier_name._lexme,[node.value])

func visit_logical(node:LogicalASTNode)->String:
	return parenthesize(node.operator._lexme, [node.left,node.right])

func visit_ternary(node:TernaryASTNode)->String:
	return parenthesize("?:",[node.condition,node.true_branch,node.false_branch])
