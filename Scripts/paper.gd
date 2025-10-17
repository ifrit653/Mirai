extends CharacterBody2D
var dragginDistance
var dir
var dragging : bool
var mouse_in := false
var chosen := false
var newPosition = Vector2()
func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if chosen and event.is_pressed() && mouse_in:
			dragginDistance = position.direction_to(get_viewport().get_mouse_position())
			dir = (get_viewport().get_mouse_position() - position).normalized()
			dragging = true
			newPosition = get_viewport().get_mouse_position() - dragginDistance * dir
		else: 
			dragging = false
			chosen = false 
	elif event is InputEventMouseMotion:
		if dragging:
			newPosition = get_viewport().get_mouse_position() - dragginDistance * dir		
func _physics_process(delta: float) -> void:
		if dragging:
			velocity = (newPosition - position) * Vector2(30, 30)
			move_and_slide() 
 
## Called when the node enters the scene tree for the first time.
#func _ready() -> void:
	#pass # Replace with function body.
#
#
## Called every frame. 'delta' is the elapsed time since the previous frame.



func _on_mouse_entered() -> void:
	mouse_in = true


func _on_mouse_exited() -> void:
	mouse_in = false
