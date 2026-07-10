extends Node
class_name DialogueEventInterface

@export var event_bus: EventBus


func broadcast(event_name:String,data:Array[Variant])->void:
	event_bus.broadcast(event_name,data)
