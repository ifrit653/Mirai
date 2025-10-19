extends Node2D

@onready var audio_stream_player_2d: AudioStreamPlayer2D = $AudioStreamPlayer2D

func _ready() -> void:
	visible = false

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("choose"):  # choose is mapped to Enter
		turn_visible()

func turn_visible() -> void:
	visible = !visible
	audio_stream_player_2d.play()

func _on_release_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/badending1.tscn")

func _on_arrest_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/goodending1.tscn")
