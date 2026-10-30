extends Control


func _ready() -> void:
	if not Core.get_saves():
		GodoTools.change_scene("res://settings_game.tscn")
		return
	
	await get_tree().create_timer(5).timeout
	#fire()
	gold()
	await get_tree().create_timer(10).timeout
	$AnimationPlayer.play("logo")
	$Logo.show()
	$Continio.show()


func gold():
	$GoldBG/Paticles.emitting = true
	$GoldBG/AnimationPlayer.play("gold_bg")
	$GoldBG/GTSound3D/AnimationPlayer.play("greatest_changes")
	$GoldBG.show()
	await get_tree().create_timer(7).timeout
	$GoldBG/AnimationPlayer.play("gold")


func fire():
	$FireBG/GTSound3D/AnimationPlayer.play("the_last_agni_kai")
	$FireBG/Particles.emitting = true
	$FireBG/BG/Anim.play("fire_start")
	$FireBG.show()
	await get_tree().create_timer(7).timeout
	$FireBG/BG/Anim.play("fire_2", 0.5)


func _on_continio_pressed() -> void:
	$Continio/GTSound.playing = true
	GodoTools.change_scene("res://scenes/main_menu.tscn")
	
