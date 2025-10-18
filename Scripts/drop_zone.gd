extends Area2D

@onready var sprite: Sprite2D = $Sprite2D  # Optional background sprite
var original_modulate := Color.WHITE
var hover_modulate := Color(0.8, 1.0, 0.8, 1.0)  # Green tint
var documents: Array[Area2D] = []

func _ready() -> void:
	add_to_group("drop_zone")
	if sprite:
		original_modulate = sprite.modulate

func on_document_hover(is_hovering: bool) -> void:
	"""Called when a document enters/exits this zone"""
	if sprite:
		if is_hovering:
			sprite.modulate = hover_modulate
		else:
			sprite.modulate = original_modulate

func on_document_dropped(document: Area2D) -> void:
	"""Called when a document is dropped in this zone"""
	documents.append(document)
	if sprite:
		sprite.modulate = original_modulate
	print("Document accepted! Total: ", documents.size())
