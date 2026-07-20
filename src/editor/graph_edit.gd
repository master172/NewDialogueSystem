extends GraphEdit

@export var _end_node: PackedScene
@export var _start_node: PackedScene


func _ready() -> void:
	_prepare()

func _prepare()->void:
	var start_node:GraphNode = _start_node.instantiate()
	start_node.position_offset = Vector2(20,200)
	var end_node:GraphNode = _end_node.instantiate()
	end_node.position_offset = Vector2(600,200)
	add_child(start_node)
	add_child(end_node)


func _on_connection_request(from_node: StringName, from_port: int, to_node: StringName, to_port: int) -> void:
	connect_node(from_node,from_port,to_node,to_port)

func add_new_node(node_type:PackedScene)->void:
	add_child(node_type.instantiate())
