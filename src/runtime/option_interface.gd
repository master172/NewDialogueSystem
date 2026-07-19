extends Control
class_name DialogueOptionsInterface

@export var OPTION: PackedScene

@export var options_list: VBoxContainer
@export var panel_padding:Vector2 = Vector2(8.0,8.0)

enum STATES {
	IDLE,
	PROCESSING
}

var max_selected:int = 0
var current_selected:int = -1

var current_state:STATES:
	set(value):
		current_state = value
		process_visibility()

signal option_selected(option:int)

func _ready() -> void:
	current_state = STATES.IDLE
	
func process_visibility()->void:
	if current_state == STATES.IDLE: visible = false
	else: visible = true

func add_option(option:UIOptionResource)->void:
	var option_scene:DialogueOption = OPTION.instantiate()
	option_scene.setup_option(option)
	options_list.add_child(option_scene)
	
func display_options(options:Array[UIOptionResource])->void:
	if options.is_empty():
		push_error("option array empty")
		return
	for i:UIOptionResource in options:
		add_option(i)
	setup_options_state(options)
	current_state = STATES.PROCESSING

func setup_options_state(options:PackedStringArray)->void:
	max_selected = options.size()
	current_selected = 0
	
	if max_selected > 0:
		update_option_display(true)
		
func update_option_display(selected:bool)->void:
	var option:DialogueOption = options_list.get_child(current_selected)
	option.set_selected(selected)

func _input(event: InputEvent) -> void:
	if current_state == STATES.IDLE:
		return
	if max_selected <= 0 or current_selected < 0:
		push_error("state variables not configured properly for option ui")
		return
	if event.is_action_pressed("ui_up"):
		update_option_display(false)
		current_selected = (current_selected + max_selected - 1) % max_selected
		update_option_display(true)
	elif event.is_action_pressed("ui_down"):
		update_option_display(false)
		current_selected = (current_selected + 1) % max_selected
		update_option_display(true)
	if event.is_action_pressed("ui_accept"):
		process_selected(current_selected)
		#print("selected option: ",current_selected)

func process_selected(selected:int)->void:
	if (options_list.get_child(selected) as DialogueOption).disabled == true:
		return
	option_selected.emit(selected)

func stop_processing()->void:
	max_selected = 0
	current_selected = -1
	for i:Node in options_list.get_children():
		i.queue_free()
	current_state = STATES.IDLE
