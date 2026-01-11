extends Node

# Day tracking
var current_day = 1
var decisions_made = []

# Statistics
var total_approved = 0
var total_denied = 0
var total_correct = 0
var total_incorrect = 0

# Expected decisions (you'll set these based on your game logic)
var expected_decisions = {}  # Format: {"suspect_id": DecisionPaper.StampType.APPROVED}

func reset_day_stats():
	decisions_made.clear()
	total_approved = 0
	total_denied = 0
	total_correct = 0
	total_incorrect = 0

func record_decision(suspect_id: String, decision, was_correct: bool):
	decisions_made.append({
		"suspect_id": suspect_id,
		"decision": decision,
		"correct": was_correct
	})
	
	if decision == 0:  # APPROVED
		total_approved += 1
	elif decision == 1:  # DENIED
		total_denied += 1
	
	if was_correct:
		total_correct += 1
	else:
		total_incorrect += 1
	
	push_warning("Decision recorded: ", suspect_id, " - Correct: ", was_correct)

func end_day():
	push_warning("Day ", current_day, " ended!")
	push_warning("Approved: ", total_approved, " | Denied: ", total_denied)
	push_warning("Correct: ", total_correct, " | Incorrect: ", total_incorrect)
	
	# Load end of day scene
	get_tree().change_scene_to_file("res://Scenes/end_of_day.tscn")

func start_next_day():
	current_day += 1
	reset_day_stats()
	# Load office scene
	get_tree().change_scene_to_file("res://Scenes/office.tscn")
