extends Node2D

# References to container nodes
@onready var interphone_0: Node2D = $Interphone
@onready var officer_0: Node2D = $Officer
@onready var stamp_0: Node2D = $Stamp
@onready var suspect_0: Node2D = $Suspect0

# References to Sprite2D nodes
@onready var interphone: Sprite2D = $Interphone/Interphone
@onready var officer: Sprite2D = $Officer/Hands
@onready var stamp: Sprite2D = $Stamp/Stamp
@onready var suspect: Sprite2D = $Suspect0/Suspect

# References to Area2D nodes
@onready var suspect_area: Area2D = $Suspect0/Suspect/Area2D
@onready var stamp_area: Area2D = $Stamp/Stamp/Area2D
@onready var officer_area: Area2D = $Officer/Hands/Area2D
@onready var interphone_area: Area2D = $Interphone/Interphone/Area2D

# Track the current state
var order_stage = 0  # 0: Start, 1: After Interphone clicked

func _ready():
	# Initialize: Only Interphone is clickable
	_set_node_clickable(interphone_area, true)
	_set_node_clickable(stamp_area, false)
	_set_node_clickable(suspect_area, false)
	_set_node_clickable(officer_area, false)
	
	# Make Suspect invisible at start
	suspect.visible = false
	
	# Connect signals from Area2D nodes
	interphone_area.area_clicked.connect(_on_interphone_clicked)
	stamp_area.area_clicked.connect(_on_stamp_clicked)
	suspect_area.area_clicked.connect(_on_suspect_clicked)
	officer_area.area_clicked.connect(_on_officer_clicked)

func _set_node_clickable(area: Area2D, clickable: bool) -> void:
	area.input_pickable = clickable

func _fade_in(sprite: Sprite2D) -> void:
	var tween = create_tween()
	sprite.modulate.a = 0.0
	tween.tween_property(sprite, "modulate:a", 1.0, 2.5)

func _on_interphone_clicked() -> void:
	if order_stage == 0:
		order_stage = 1
		
		# Make Officer and Stamp clickable immediately
		_set_node_clickable(officer_area, true)
		_set_node_clickable(stamp_area, true)
		
		
		# Wait 2 seconds then make Suspect visible and clickable
		await get_tree().create_timer(2.0).timeout
		suspect.visible = true
		_fade_in(suspect)
		_set_node_clickable(suspect_area, true)

func _on_stamp_clicked() -> void:
	pass  # Add your logic here

func _on_suspect_clicked() -> void:
	pass  # Add your logic here

func _on_officer_clicked() -> void:
	pass  # Add your logic here
