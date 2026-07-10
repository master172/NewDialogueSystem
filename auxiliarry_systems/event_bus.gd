extends Node
class_name EventBus

var subscribers:Dictionary[StringName,Array] = {
}

func subscribe(event:StringName,callback:Callable)->void:
	if not subscribers.has(event):
		subscribers[event] = []
	if subscribers[event].has(callback):
		return
	subscribers[event].append(callback)

func unsubscribe(event:StringName,callback:Callable)->void:
	if not subscribers.has(event):
		return
	subscribers[event].erase(callback)
	
	if subscribers[event].is_empty():
		subscribers.erase(event)
	
func broadcast(event:StringName,data:Array[Variant] = [])->void:
	if not subscribers.has(event):
		return
	
	var callbacks:Array = subscribers[event].duplicate()
	
	for callback:Callable in callbacks:
		callback.callv(data)
