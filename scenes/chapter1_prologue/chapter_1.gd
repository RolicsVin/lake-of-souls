extends Control

var time: bool = true
var pressed: bool = false


func _ready() -> void:
	await get_tree().create_timer(10.0).timeout
	time = false


func _process(_delta: float) -> void:
	if time:
		return
	if pressed:
		return
	
	if Input.is_action_just_pressed("left_mouse"):
		pressed = true
		
		$AnimationPlayer.play("next")
		await $AnimationPlayer.animation_finished
		
		GodoTools.change_scene("res://scenes/main_menu.tscn")
