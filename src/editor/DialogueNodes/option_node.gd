extends GraphNode

@export var option: PackedScene


func _on_add_option_button_pressed() -> void:
	add_child(option.instantiate())
	set_slot(
		get_child_count()-1,
		false,
		0,
		Color.WHITE,
		true,
		0,
		Color.WHITE,
		)
