extends Area2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	position = get_global_mouse_position()
	var count = len(get_overlapping_bodies())
	if (count == 0):
		pass
	elif (count == 1):
		get_overlapping_bodies()[0].chosen()
		if(Input.is_action_just_pressed("mouse_click")):
			get_parent().push_paper_to_top(get_overlapping_bodies()[0])
	else:
		var max_index = -1 
		var top_paper = null 
		for b in get_overlapping_bodies():
			if(b.z_index > max_index):
				max_index = b.z_index
				top_paper = b
		top_paper.chosen()
		for b in get_overlapping_bodies():
			if b != top_paper:
				b.chosen = false
		if (Input.is_action_just_pressed("mouse_click")):
			get_parent().push_paper_to_top(top_paper)
