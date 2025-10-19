extends CanvasLayer
## A basic dialogue balloon for use with Dialogue Manager.

## The action to use for advancing the dialogue
@export var next_action: StringName = &"ui_accept"

## The action to use to skip typing the dialogue
@export var skip_action: StringName = &"ui_cancel"

## The dialogue resource
var resource: DialogueResource

## Temporary game states
var temporary_game_states: Array = []

## See if we are waiting for the player
var is_waiting_for_input: bool = false

## See if we are running a long mutation and should hide the balloon
var will_hide_balloon: bool = false

## A dictionary to store any ephemeral variables
var locals: Dictionary = {}

var _locale: String = TranslationServer.get_locale()

## The current line
var dialogue_line: DialogueLine:
	set(value):
		if value:
			dialogue_line = value
			apply_dialogue_line()
	get:
		return dialogue_line

## A cooldown timer for delaying the balloon hide when encountering a mutation.
var mutation_cooldown: Timer = Timer.new()

## The base balloon anchor
@onready var balloon: Control = %Balloon

## The label showing the name of the currently speaking character
@onready var character_label: RichTextLabel = %CharacterLabel

## The label showing the currently spoken dialogue
@onready var dialogue_label: DialogueLabel = %DialogueLabel


func _ready() -> void:
	print("Dialogue balloon ready")
	print("Balloon: ", balloon)
	print("Character label: ", character_label)
	print("Dialogue label: ", dialogue_label)
	
	balloon.hide()
	
	# Safely connect to DialogueManager if it exists
	if Engine.has_singleton("DialogueManager"):
		var dialogue_manager = Engine.get_singleton("DialogueManager")
		if dialogue_manager.has_signal("mutated"):
			dialogue_manager.mutated.connect(_on_mutated)
	else:
		push_warning("DialogueManager singleton not found. Make sure the Dialogue Manager plugin is enabled.")

	mutation_cooldown.timeout.connect(_on_mutation_cooldown_timeout)
	add_child(mutation_cooldown)

func _unhandled_input(_event: InputEvent) -> void:
	# Only handle input if the balloon is visible and waiting for input
	if balloon.visible and is_waiting_for_input:
		get_viewport().set_input_as_handled()

func _notification(what: int) -> void:
	## Detect a change of locale and update the current dialogue line to show the new language
	if what == NOTIFICATION_TRANSLATION_CHANGED and _locale != TranslationServer.get_locale() and is_instance_valid(dialogue_label):
		_locale = TranslationServer.get_locale()
		var visible_ratio = dialogue_label.visible_ratio
		self.dialogue_line = await resource.get_next_dialogue_line(dialogue_line.id)
		if visible_ratio < 1:
			dialogue_label.skip_typing()


## Start some dialogue
func start(dialogue_resource: DialogueResource, title: String, extra_game_states: Array = []) -> void:
	print("Starting dialogue with title: ", title)
	temporary_game_states = [self] + extra_game_states
	is_waiting_for_input = false
	resource = dialogue_resource
	print("Getting dialogue line...")
	self.dialogue_line = await resource.get_next_dialogue_line(title, temporary_game_states)
	print("Got dialogue line: ", self.dialogue_line)


## Apply any changes to the balloon given a new [DialogueLine].
func apply_dialogue_line() -> void:
	print("Applying dialogue line: ", dialogue_line)
	print("Dialogue text: ", dialogue_line.text if dialogue_line else "null")
	
	mutation_cooldown.stop()

	is_waiting_for_input = false
	balloon.focus_mode = Control.FOCUS_ALL
	balloon.grab_focus()

	character_label.visible = not dialogue_line.character.is_empty()
	character_label.text = tr(dialogue_line.character, "dialogue")

	dialogue_label.hide()
	dialogue_label.dialogue_line = dialogue_line

	# Show our balloon with fade in
	balloon.modulate.a = 0.0
	balloon.show()
	print("Balloon shown")
	will_hide_balloon = false
	
	var tween = create_tween()
	tween.tween_property(balloon, "modulate:a", 1.0, 0.5)

	dialogue_label.show()
	if not dialogue_line.text.is_empty():
		dialogue_label.type_out()
		await dialogue_label.finished_typing
	
	# Wait for input
	if dialogue_line.responses.size() > 0:
		# Handle responses if you add a responses menu back
		pass
	elif dialogue_line.time != "":
		var time = dialogue_line.text.length() * 0.02 if dialogue_line.time == "auto" else dialogue_line.time.to_float()
		await get_tree().create_timer(time).timeout
		next(dialogue_line.next_id)
	else:
		is_waiting_for_input = true
		balloon.focus_mode = Control.FOCUS_ALL
		balloon.grab_focus()
		
		# Auto-hide balloon after 5 seconds with fade out
		await get_tree().create_timer(5.0).timeout
		var fade_tween = create_tween()
		fade_tween.tween_property(balloon, "modulate:a", 0.0, 0.5)
		await fade_tween.finished
		balloon.hide()
		balloon.modulate.a = 1.0
		is_waiting_for_input = false


## Go to the next line
func next(next_id: String) -> void:
	self.dialogue_line = await resource.get_next_dialogue_line(next_id, temporary_game_states)


#region Signals


func _on_mutation_cooldown_timeout() -> void:
	if will_hide_balloon:
		will_hide_balloon = false
		balloon.hide()


func _on_mutated(_mutation: Dictionary) -> void:
	is_waiting_for_input = false
	will_hide_balloon = true
	mutation_cooldown.start(0.1)


func _on_balloon_gui_input(event: InputEvent) -> void:
	# See if we need to skip typing of the dialogue
	if dialogue_label.is_typing:
		var mouse_was_clicked: bool = event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.is_pressed()
		var skip_button_was_pressed: bool = event.is_action_pressed(skip_action)
		if mouse_was_clicked or skip_button_was_pressed:
			get_viewport().set_input_as_handled()
			dialogue_label.skip_typing()
			return

	if not is_waiting_for_input: return

	# When there are no response options the balloon itself is the clickable thing
	get_viewport().set_input_as_handled()

	if event is InputEventMouseButton and event.is_pressed() and event.button_index == MOUSE_BUTTON_LEFT:
		next(dialogue_line.next_id)
	elif event.is_action_pressed(next_action) and get_viewport().gui_get_focus_owner() == balloon:
		next(dialogue_line.next_id)


#endregion
