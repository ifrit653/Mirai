extends Node2D

# Optional: Keep track of all documents
var documents: Array[Area2D] = []
var next_z_index := 1  # For bringing documents to front

func _ready() -> void:
	# Find all documents in the scene
	for child in get_children():
		if child is Area2D and child.is_in_group("document"):
			documents.append(child)
			# Set initial z-index
			child.z_index = next_z_index
			next_z_index += 1

func bring_document_to_front(document: Area2D) -> void:
	"""Bring a document to the front by giving it the highest z-index"""
	document.z_index = next_z_index
	next_z_index += 1
	print("Document '%s' brought to front (z: %d)" % [document.name, document.z_index])
