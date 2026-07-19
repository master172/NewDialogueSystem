extends Panel
class_name DialogueOption

@export var label: Label

var selected_color:Color
var default_color:Color

const enabled_default_color:Color = Color("1f1f1f")
const enabled_selected_color:Color = Color("ffffff")

const disabled_default_color:Color = Color.DIM_GRAY
const disabled_selected_color:Color = Color.DARK_GRAY

var disabled:bool = false

func _ready() -> void:
	if not disabled:
		selected_color = enabled_selected_color
		default_color = enabled_default_color
	else:
		selected_color = disabled_selected_color
		default_color = disabled_default_color
		
	var panel_style:StyleBox = get_theme_stylebox("panel").duplicate(true) as StyleBoxFlat
	add_theme_stylebox_override("panel", panel_style)
	panel_style.bg_color = default_color
	
func set_selected(selected:bool)->void:
	var style:StyleBox = get_theme_stylebox("panel") as StyleBoxFlat
	style.bg_color = selected_color if selected else default_color

func setup_option(option:UIOptionResource)->void:
	label.text = option.text
	disabled = option.disabled
