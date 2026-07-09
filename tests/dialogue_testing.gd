extends Node2D

@export var dialogue_runtime: DialogueRuntime

@export var base_dialogue_graph:DialogueGraph

func _ready() -> void:
	dialogue_runtime.start_dialog(base_dialogue_graph)
