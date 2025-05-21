extends Node2D

@onready var animation_player: AnimationPlayer = $ParallaxBackground/ParallaxLayer/AnimationPlayer
@onready var sprite_2d: Sprite2D = $ParallaxBackground/ParallaxLayer/Sprite2D
var lava = false
var behead = false
var imprison = false
var player_input = true

func _ready():
	pass

func _input(event):
	if event is InputEventMouseMotion:
		var mouse_pos = get_global_mouse_position()
	if event is InputEventMouseButton and event.is_action_pressed("select") and player_input:
		player_input = false
		if lava:
			animation_player.play("Incinerate")
		if behead:
			animation_player.play("Struggle")
			await animation_player.animation_finished
			animation_player.play("Behead")
		if imprison:
			animation_player.play("1")

func _on_behead_mouse_entered():
	if player_input:
		lava = false
		behead = true
		imprison = false
		animation_player.play("Decollate")

func _on_behead_mouse_exited():
	if player_input:
		lava = false
		behead = false
		imprison = false

func _on_imprison_mouse_entered():
	if player_input:
		lava = false
		behead = false
		imprison = true
		animation_player.play("ImprisonHover")

func _on_imprison_mouse_exited():
	if player_input:
		lava = false
		behead = false
		imprison = true

func _on_lava_mouse_entered():
	if player_input:
		lava = true
		behead = false
		imprison = false
		animation_player.play("IncinerateHover")

func _on_lava_mouse_exited():
	if player_input:
		lava = false
		behead = false
		imprison = false
