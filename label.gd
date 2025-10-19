extends Label

@export var fade_duration: float = 0.2  # Duration for each line to fade in
@export var delay_between_lines: float = 0.5  # Delay between each line starting

@onready var audio_stream_player_2d: AudioStreamPlayer2D = $AudioStreamPlayer2D

var full_text: String = ""
var lines: PackedStringArray = []
var visible_lines: int = 0
var current_tween: Tween
var current_delay_timer: Timer
var line_index: int = 0

func _ready() -> void:
	full_text = text
	lines = full_text.split("\n")
	text = ""
	modulate.a = 1.0
	
	# Start the fade-in sequence
	fade_in_lines()

func fade_in_lines() -> void:
	while visible_lines < lines.size():
		await get_tree().create_timer(delay_between_lines).timeout
		if visible_lines < lines.size():
			fade_in_line(visible_lines)
	
	# Wait 2 seconds after the last line appears, then auto-switch
	print("ready to skip")
	await get_tree().create_timer(2.0).timeout
	_on_start_pressed()

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("escape"):
		_on_start_pressed()
	elif event is InputEventMouseButton and event.pressed and visible_lines < lines.size():
		# Skip current animation and show next line immediately
		if current_tween:
			current_tween.kill()
		modulate.a = 1.0
		
		# Show next line immediately without delay
		if visible_lines < lines.size():
			fade_in_line(visible_lines)

func _on_start_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/office.tscn")

func fade_in_line(line_index: int) -> void:
	# Play sound effect for new line
	audio_stream_player_2d.play()
	
	# Simply append the new line to the display text
	if visible_lines == 0:
		text = lines[line_index]
	else:
		text += "\n" + lines[line_index]
	
	visible_lines += 1
	
	# Kill the previous tween if it exists
	if current_tween:
		current_tween.kill()
	
	# Fade in just the label's alpha smoothly
	current_tween = create_tween()
	current_tween.tween_property(self, "modulate:a", 1.0, fade_duration)
