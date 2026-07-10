extends Node
class_name DialogueEventInterface

@export var event_bus: EventBus


func brodcast(event_name:String,data:Array[Variant])->void:
	event_bus.broadcast(event_name,data)
