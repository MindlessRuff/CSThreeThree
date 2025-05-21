extends "base_state.gd"

var spike_sound = preload("res://assets/sounds/423130__killersmurf96__spike_trap.wav")
var capture_scene: PackedScene = preload("res://scenes/choose_your_fate.tscn")

func _enter_state(_old_state: StringName, _params: Dictionary) -> void:
	var trap = [1, 2].pick_random()
	if trap == 1:
		spike()
	elif trap == 2:
		trap_door()
	#trap_door()
	

func _physics_process(_delta: float) -> void:
	pass

func spike():
	var animation_name = "Spike"
	animation_player.play(animation_name)
	%AudioStreamPlayer2D.stream = spike_sound
	%AudioStreamPlayer2D.play()
	await animation_player.animation_finished
	var level = get_common_node().get_parent().get_node("Level")
	level.player_win()

func trap_door():
	var animation_name = "Falling"
	animation_player.play(animation_name)
	%AudioStreamPlayer2D.stream = spike_sound
	%AudioStreamPlayer2D.play()
	await animation_player.animation_finished
	animation_name = "Ajar"
	animation_player.play(animation_name)
	await animation_player.animation_finished
	get_tree().change_scene_to_packed(capture_scene)
