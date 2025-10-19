extends Node2D

@onready var paper_sprite: Sprite2D = $Sprite2D
@onready var label: Label = $Label
@onready var next_button: Button = $NextButton
@onready var prev_button: Button = $PrevButton

var pages: Array[String] = []
var current_page := 0

func _ready():
	visible = true
	print("Parent type:", get_parent().name, "(", get_parent().get_class(), ")")
func show_paper(paper_id: String):
	pages = _load_paper_pages(paper_id)
	current_page = 0
	_update_page()


func _update_page():
	if pages.size() > 0:
		label.text = pages[current_page]


func _on_next_pressed() -> void:
	if current_page < pages.size() - 1:
		current_page += 1
		_update_page()


func _on_prev_pressed() -> void:
	if current_page > 0:
		current_page -= 1
		_update_page()
func _load_paper_pages(paper_id: String) -> Array[String]:
	# later, this could load from JSON, file, or dictionary
	match paper_id:
		"note_01":
			return [
				"Page 1: A crumpled note reads:\n\n'The truth lies beneath the floorboards...'",
			    "Page 2: The handwriting is shaky:\n\n'Find the key before it's too late.'"
			]
		"note_02":
			return [
				"Page 1: A torn diary page:\n\n'Today, I saw something move in the cellar...'",
			    "Page 2: The rest is unreadable."
			]
		_:
			return ["This page is blank."]

func _on_close_button_pressed() -> void:
	queue_free()
