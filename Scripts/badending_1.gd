extends Node2D

func _ready() -> void:
	# Wait 10 seconds then auto-switch
	await get_tree().create_timer(10.0).timeout
	change_to_menu()

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_accept"):  # ui_accept is mapped to Space by default
		change_to_menu()

func change_to_menu() -> void:
	get_tree().change_scene_to_file("res://Scenes/menu.tscn")
