extends Node2D
class_name DecisionPaper

# References
@onready var paper_sprite = $Paper
@onready var stamp_preview = $StampPreview
@onready var stamp = $StampSpriteArea

# Stamp types
enum StampType {
	APPROVED,
	DENIED,
	NONE
}

# Current stamp placed
var current_stamp = null
var stamp_textures = {}
var current_region = null

func _ready():
	# Load stamp textures
	stamp_textures[StampType.APPROVED] = preload("res://Assets/icones/released.png")
	stamp_textures[StampType.DENIED] = preload("res://Assets/icones/arrested.png")
	
	# Setup stamp preview (invisible by default)
	if stamp_preview:
		stamp_preview.modulate.a = 0.5
		stamp_preview.visible = false
	
	# Connect all Area2D regions
	connect_regions()
	
	push_warning("DecisionPaper ready! Found regions:")
	print("test print")

func connect_regions():
	var regions = get_tree().get_nodes_in_group("stamp_region")
	push_warning("Found ", regions.size(), " regions in stamp_region group")
	
	for region in regions:
		if region is Area2D:
			push_warning("Connecting region: ", region.name)
			# Make sure the Area2D can receive input
			region.input_pickable = true
			region.mouse_entered.connect(_on_region_entered.bind(region))
			region.mouse_exited.connect(_on_region_exited.bind(region))
			region.input_event.connect(_on_region_input_event.bind(region))

func _on_region_entered(region: Area2D):
	push_warning("Mouse entered region: ", region.name)
	current_region = region
	var stamp_type = get_stamp_type_from_region(region)
	
	if stamp_type != StampType.NONE:
		stamp_preview.texture = stamp_textures[stamp_type]
		stamp_preview.visible = true
		push_warning("Showing stamp preview for: ", stamp_type)

func _on_region_exited(region: Area2D):
	push_warning("Mouse exited region: ", region.name)
	if current_region == region:
		current_region = null
		stamp_preview.visible = false

func _on_region_input_event(viewport: Node, event: InputEvent, shape_idx: int, region: Area2D):
	push_warning("Input event on region: ", region.name, " Event: ", event)
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		var stamp_type = get_stamp_type_from_region(region)
		push_warning("Placing stamp type: ", stamp_type)
		
		if stamp_type != StampType.NONE:
			var local_pos = get_local_mouse_position()
			place_stamp(local_pos, stamp_type)

func get_stamp_type_from_region(region: Area2D) -> StampType:
	var name_lower = region.name.to_lower()
	
	if "approved" in name_lower:
		return StampType.APPROVED
	elif "denied" in name_lower or "dennied" in name_lower:
		return StampType.DENIED
	return StampType.NONE

func _process(_delta):
	# Update stamp preview position every frame if visible
	if stamp_preview.visible:
		stamp_preview.position = get_local_mouse_position()

func place_stamp(pos: Vector2, stamp_type: StampType):
	push_warning("Placing stamp at position: ", pos)
	
	# Remove previous stamp if exists
	if current_stamp:
		current_stamp.queue_free()
	
	# Create new stamp sprite
	var stamp = Sprite2D.new()
	stamp.texture = stamp_textures[stamp_type]
	stamp.position = pos
	stamp.z_index = 10
	stamp.scale = Vector2(0.5, 0.5)
	stamp.rotation_degrees = randf_range(-10, 10)
	
	paper_sprite.add_child(stamp)
	current_stamp = stamp
	push_warning("Stamp placed!")

func clear_stamp():
	if current_stamp:
		current_stamp.queue_free()
		current_stamp = null

func close_decision_paper():
	queue_free()
func _on_close_button_pressed() -> void:
	close_decision_paper()
