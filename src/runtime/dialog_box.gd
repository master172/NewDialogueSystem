extends Panel
class_name DialogueTextBoxInterface

enum STATES {
	IDLE,
	TYPING,
	WAITING_FOR_INPUT
}

var current_state:STATES = STATES.IDLE

signal advance_signal

@export var text_box: RichTextLabel

var pages:PackedStringArray = []
var current_page:int = -1

var current_tween:Tween

var can_skip:bool = true

@export var seconds_per_character:float = 0.03

func start_dialog_processing(text:String)->bool:
	pages = TextPaginator.basic_paginate(text)
	print(TextPaginator.basic_paginate(text))

	if pages.is_empty():
		push_error("no text to be paginated")
		return false
	current_page = 0
	
	return true

func clear()->void:
	text_box.text = ""

func end_dialog_processing()->void:
	pages.clear()
	current_page = -1
	current_state = STATES.IDLE
	
	if current_tween:
		current_tween.kill()
		current_tween = null
	
func display_dialog(text:String)->void:
	text_box.visible_ratio = 0
	if not start_dialog_processing(text):
		return
	show_current_page()

func show_current_page()->void:
	if current_page == -1:
		push_error("pagination not setup properly")
		return
	if current_page >= pages.size():
		push_error("attempting going over pages limit")
		return
	display_text(pages[current_page])

func display_text(text:String)->void:
	current_state = STATES.TYPING
	
	text_box.visible_ratio = 0
	text_box.text = text
	
	if current_tween:
		current_tween.kill()
		
	current_tween = get_tree().create_tween()
	var tween_time:float = text.length() * seconds_per_character
	current_tween.tween_property(text_box,"visible_ratio",1.0,tween_time)
	current_tween.finished.connect(text_display_finished)

func text_display_finished()->void:
	
	current_tween = null
	current_state = STATES.WAITING_FOR_INPUT

func manage_advancement_request()->void:
	match current_state:
		STATES.TYPING:
			skip_typing()
		STATES.WAITING_FOR_INPUT:
			advance_page_or_finish()
		STATES.IDLE:
			return

func skip_typing()->void:
	if not can_skip:
		return
	if current_tween:
		current_tween.kill()
		current_tween = null
	
	text_box.visible_ratio = 1.0
	current_state = STATES.WAITING_FOR_INPUT

func advance_page_or_finish()->void:
	current_page += 1
	if current_page >= pages.size():
		advance_signal.emit()
		end_dialog_processing()
	else:
		show_current_page()

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_accept"):
		manage_advancement_request()
