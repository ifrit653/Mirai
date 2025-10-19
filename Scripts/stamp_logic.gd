extends Node2D
# References
@onready var paper = $Paper
@onready var stamp_preview = $StampPreview

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

func _process(delta):
	print("fdsfdsfdsfdsf")
func _ready():
	print("sxcfdscxds")
	# Load stamp textures (replace with your actual stamp images)
	stamp_textures[StampType.APPROVED] = preload("res://Assets/icones/released.png")
	stamp_textures[StampType.DENIED] = preload("res://Assets/icones/arrested.png")
	
	# Setup stamp preview (invisible by default)
	stamp_preview.modulate.a = 0.5
	stamp_preview.visible = false
	
	# Connect all Area2D regions
	connect_regions()

func connect_regions():
	"""Connect mouse enter/exit signals for all stamp regions"""
	var regions = get_tree().get_nodes_in_group("stamp_region")
	for region in regions:
		if region is Area2D:
			region.mouse_entered.connect(_on_region_entered.bind(region))
			region.mouse_exited.connect(_on_region_exited.bind(region))

func _on_region_entered(region: Area2D):
	"""Called when mouse enters a stamp region"""
	current_region = region
	var stamp_type = get_stamp_type_from_region(region)
	if stamp_type != StampType.NONE:
		stamp_preview.texture = stamp_textures[stamp_type]
		stamp_preview.visible = true

func _on_region_exited(region: Area2D):
	"""Called when mouse exits a stamp region"""
	if current_region == region:
		current_region = null
		stamp_preview.visible = false

func get_stamp_type_from_region(region: Area2D) -> StampType:
	"""Determines stamp type based on the region's name or group"""
	# Check the region's name
	if "approved" in region.name.to_lower():
		return StampType.APPROVED
	elif "denied" in region.name.to_lower():
		return StampType.DENIED
	return StampType.NONE

func _input(event):
	if event is InputEventMouseMotion:
		# Update stamp preview position
		stamp_preview.global_position = event.position
	
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		# Place stamp on click if over a region
		if current_region:
			var stamp_type = get_stamp_type_from_region(current_region)
			if stamp_type != StampType.NONE:
				place_stamp(event.position, stamp_type)

func place_stamp(pos: Vector2, stamp_type: StampType):
	"""Places a stamp on the paper at the given position"""
	# Remove previous stamp if exists
	if current_stamp:
		current_stamp.queue_free()
	
	# Create new stamp sprite
	var stamp = Sprite2D.new()
	stamp.texture = stamp_textures[stamp_type]
	stamp.global_position = pos
	paper.add_child(stamp)
	
	current_stamp = stamp
	
	# Add rotation for authenticity
	stamp.rotation_degrees = randf_range(-10, 10)
	
	# Play stamp sound effect
	play_stamp_sound()
	
	print("Stamp placed: ", StampType.keys()[stamp_type])

func play_stamp_sound():
	"""Play stamp sound effect"""
	# Add your stamp sound effect here
	# $StampSound.play()
	pass

# Optional: Clear the stamp
func clear_stamp():
	if current_stamp:
		current_stamp.queue_free()
		current_stamp = null
