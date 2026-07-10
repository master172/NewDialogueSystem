extends Node2D

@export var dialogue_runtime: DialogueRuntime

@export var base_dialogue_graph:DialogueGraph

func _ready() -> void:
	dialogue_runtime.variable_interface.write_to_dictionary("player.name","Swirtez")
	dialogue_runtime.event_bus.subscribe("test_event",callback_function)
	dialogue_runtime.start_dialog(base_dialogue_graph)


func callback_function(test_data:String)->void:
	print_debug("got here through event: ",test_data)
