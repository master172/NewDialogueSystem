extends Resource
class_name ASTNode

func accept(visitor:Visitor)->Variant:
	push_error("error using undintialized node in the AST")
	return
