extends Node2D
var paper_stack = []
var paper_scene = preload("res://Scenes/paper.tscn")
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for i in range(0, 2):
		var paper = paper_scene.instantiate()
		add_paper(paper)
	
func add_paper(paper):
	paper_stack.append(paper)
	var count = 0
	for p in paper_stack:
		p.z_index = count
		count += 1
func push_paper_to_top(paper):
	paper_stack.erase(paper)
	add_paper(paper)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
