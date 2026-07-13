extends Visitor
class_name DEEvaluator

var runtime:DialogueExpressionEvaluator

func evaluate_ast(node:ASTNode,dialog_runtime:DialogueExpressionEvaluator)->Variant:
	runtime = dialog_runtime
	return evaluate(node)
	
func evaluate(node:ASTNode)->Variant:
	return node.accept(self)

func is_truth(variant:Variant)->bool:
	if variant == null:return false
	if variant is bool: return variant
	return true

func check_number_operand(operator:Token,operand:Variant)->void:
	if operand is float or operand is int: return
	push_error(operator, " Operand must be a number")
	assert(false, " Operand must be a number")

func check_number_operands(operator:Token, left:Variant,right:Variant)->void:
	if (left is float or left is int) and (right is float or right is int):return
	push_error(operator, " Operands must be a number")
	assert(false, " Operands must be a number")

func handle_addition(left:Variant,right:Variant,operator:Token)->Variant:
	if (left is int or left is float) and (right is int or right is float): return left + right
	elif (left is String and right is String): return left + right
	else:
		push_error(operator, " Operands must be a number or a string")
		assert(false, " Operands must be a number or a string")
		return null
	
func visit_binary(node:BinaryASTNode)->Variant:
	var left:Variant = evaluate(node.left)
	var right:Variant = evaluate(node.right)
	
	match node.operator._type:
		DETokenTypes.TokenTypes.EQUAL_EQUAL:
			return left == right
		DETokenTypes.TokenTypes.NOT_EQUAL:
			return left != right
		DETokenTypes.TokenTypes.GREATER:
			check_number_operands(node.operator,left,right)
			return left > right
		DETokenTypes.TokenTypes.LESSER:
			check_number_operands(node.operator,left,right)
			return left < right
		DETokenTypes.TokenTypes.GREATER_EQUAL:
			check_number_operands(node.operator,left,right)
			return left >= right
		DETokenTypes.TokenTypes.LESSER_EQUAL:
			check_number_operands(node.operator,left,right)
			return left <= right
		DETokenTypes.TokenTypes.MINUS:
			check_number_operands(node.operator,left,right)
			return left - right
		DETokenTypes.TokenTypes.PLUS:
			return handle_addition(left,right,node.operator)
		DETokenTypes.TokenTypes.SLASH:
			check_number_operands(node.operator,left,right)
			if right == 0:
				push_error("error divison by zero")
				assert(false, "divisor cannot be zero")
			return left / right
		DETokenTypes.TokenTypes.STAR:
			check_number_operands(node.operator,left,right)
			return left * right
	
	return null

func visit_grouping(node:GroupingASTNode)->Variant:
	return evaluate(node.ast_node)

func visit_literal(node:LiteralASTNode)->Variant:
	return node.value

func visit_unary(node:UnaryASTNode)->Variant:
	var right:Variant = evaluate(node.right)
	
	match node.operator._type:
		DETokenTypes.TokenTypes.MINUS:
			check_number_operand(node.operator, right)
			return -right
		DETokenTypes.TokenTypes.NOT:
			return !is_truth(right)
	
	return null
	

func visit_variable(node:VariableASTNode)->Variant:
	return runtime.variable_interface.get_from_dictionary(node.identifier_name._literal)

func visit_assignment(node:AssignmentASTNode)->Variant:
	var identifier_name:Token = node.identifier_name
	var value:Variant = evaluate(node.value)
	runtime.variable_interface.write_to_dictionary(identifier_name._literal,value)
	return value
	
func visit_logical(node:LogicalASTNode)->Variant:
	var left:Variant = evaluate(node.left)
	
	match node.operator._type:
		DETokenTypes.TokenTypes.OR:
			if is_truth(left):
				return left
		DETokenTypes.TokenTypes.AND:
			if !is_truth(left):
				return left
			
	return evaluate(node.right)

func visit_ternary(node:TernaryASTNode)->Variant:
	if is_truth(evaluate(node.condition)):
		return evaluate(node.true_branch)
	
	return evaluate(node.false_branch)
