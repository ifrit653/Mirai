extends AudioStreamPlayer2D
@onready var audio_stream_player_2d: AudioStreamPlayer2D = $"."

func _ready() -> void:
	audio_stream_player_2d.finished.connect(_on_audio_finished)
	audio_stream_player_2d.play()

func _on_audio_finished() -> void:
	audio_stream_player_2d.play()
