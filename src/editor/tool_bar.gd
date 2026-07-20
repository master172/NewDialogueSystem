extends HBoxContainer
@export_category("Dialog Nodes")
@export_group("Dialog Nodes")
@export var dialogue_node: PackedScene
@export var event_node: PackedScene
@export var expression_node: PackedScene
@export var option_node: PackedScene
@export var condition_node: PackedScene


@export_category("Editor Nodes")
@export_group("Main")
@export var graph_edit: GraphEdit

@export_group("Tools")
@export var add_button: MenuButton

@onready var options_map:Dictionary[int,Dictionary] = {
	0:{
		"name":"DialogNode",
		"node":dialogue_node
	},
	1:{
		"name":"EventNode",
		"node":event_node
	},
	2:{
		"name":"OptionNode",
		"node":option_node
	},
	3:{
		"name":"ExpressionNode",
		"node":expression_node
	},
	4:{
		"name":"ConditionNode",
		"node":condition_node
	}
	
}
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	add_button.get_popup().id_pressed.connect(_on_id_pressed)
	_add_menu_options()
	
func _add_menu_options()->void:
	for i:Dictionary in options_map.values():
		add_button.get_popup().add_item(i["name"])
	
func _on_id_pressed(id:int)->void:
	graph_edit.add_new_node(options_map[id]["node"])
