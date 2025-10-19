extends Area2D

var shader = preload("res://Shader/suspect.gdshader")
@onready var  paper_sprite : Sprite2D = $Sprite2D 

func _input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		show_paper()

func show_paper():
	var paper_view_scene = preload("res://Scenes/paper_view.tscn")
	var paper_view = paper_view_scene.instantiate()

	# Add to UI layer (so it's always on top and uses screen coordinates)
	var ui_layer = get_tree().current_scene.get_node("UILayer")
	if ui_layer:
		ui_layer.add_child(paper_view)
	else:
		push_error("UILayer not found in current scene!")
		return

	# Center it in the screen
	var viewport_rect = get_viewport().get_visible_rect()
	var paper_size = paper_view.paper_sprite.texture.get_size() * paper_view.paper_sprite.scale
	paper_view.position = viewport_rect.size / 2 - paper_size / 2


func _on_mouse_entered() -> void:
	var material = ShaderMaterial.new()
	material.shader = shader
	paper_sprite.material = material

func _on_mouse_exited() -> void:
	paper_sprite.material = null
