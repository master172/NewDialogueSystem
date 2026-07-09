extends Node
class_name TextPaginator

static func basic_paginate(text:String)->PackedStringArray:
	var returning_array:PackedStringArray = []
	
	returning_array = text.split("[page]")
	
	for i:int in returning_array.size():
		returning_array[i] = returning_array[i].strip_edges()
	
	return returning_array
