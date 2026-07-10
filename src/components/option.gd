extends Panel
class_name DialogueOption

@export var label: Label

const default_color:Color = Color("1f1f1f")
const selected_color:Color = Color("ffffff")

func _ready() -> void:
	var panel_style:StyleBox = get_theme_stylebox("panel").duplicate(true) as StyleBoxFlat
	add_theme_stylebox_override("panel", panel_style)
	panel_style.bg_color = default_color
	
func set_selected(selected:bool)->void:
	var style:StyleBox = get_theme_stylebox("panel") as StyleBoxFlat
	style.bg_color = selected_color if selected else default_color

func setup_option(option:String)->void:
	label.text = option
