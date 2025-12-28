extends Node
class_name HoverShaderComponent
var suspect_shader = preload("res://Shader/suspect.gdshader")
@export var shader: Shader = suspect_shader
@export var target: CanvasItem
var _original_material: Material
var _area: Area2D

func _ready():
	if not target:
		target = _find_parent_of_type("Sprite2D")
	if not target:
		push_error("HoverShaderComponent: Sprite2D not found")
		return

	_area = _find_child_of_type(target, "Area2D")
	if not _area:
		push_error("HoverShaderComponent: Area2D not found")
		return

	_original_material = target.material

	_area.mouse_entered.connect(_on_mouse_entered)
	_area.mouse_exited.connect(_on_mouse_exited)

func _on_mouse_entered():
	if not shader:
		return
	var mat := ShaderMaterial.new()
	mat.shader = shader
	target.material = mat

func _on_mouse_exited():
	target.material = _original_material

# --- Helper: find parent by class name ---
func _find_parent_of_type(type_class_name: String):
	var node = get_parent()
	while node:
		if node.is_class(type_class_name):
			return node
		node = node.get_parent()
	return null

# --- Helper: find child by class name recursively ---
func _find_child_of_type(node: Node, type_class_name: String):
	for child in node.get_children():
		if child.is_class(type_class_name):
			return child
		var result = _find_child_of_type(child, type_class_name)
		if result:
			return result
	return null
