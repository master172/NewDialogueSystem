extends Panel
class_name DialogueBox

signal advance_signal

@export var text_box: RichTextLabel

var can_advance:bool = false

func display_text(text:String)->void:
	can_advance = false
	text_box.visible_ratio = 0
	text_box.text = text
	var tween:Tween = get_tree().create_tween()
	tween.tween_property(text_box,"visible_ratio",1.0,1.0)
	tween.finished.connect(text_display_finished)

func text_display_finished()->void:
	can_advance = true

func _physics_process(delta: float) -> void:
	if Input.is_action_just_pressed("ui_accept") and can_advance:
		advance_signal.emit()
