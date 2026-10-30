extends Control


func _ready() -> void:
	$Control4/LinearVisible.linear_show()


func _on_h_slider_value_changed(value: float) -> void:
	GodoTools._get_buffer()['brightness'] = value / 100
	$ColorRect._ready()


func _on_h_slider_noise_value_changed(value: float) -> void:
	GodoTools._get_buffer()['noise_intensity'] = value / 100
	$ColorRect._ready()


func _on_nasy_value_changed(value: float) -> void:
	GodoTools._get_buffer()['saturation'] = value / 100
	$ColorRect._ready()


func _on_contrast_value_changed(value: float) -> void:
	GodoTools._get_buffer()['contrast'] = value / 100
	$ColorRect._ready()


func _on_ru_pressed() -> void:
	$Control4/LinearVisible.linear_hide()
	$Control4/En.hide()
	$Control4/Ru.hide()
	GVN.set_language(GvnEnums.languages.Ru)
	await get_tree().create_timer(1).timeout
	$Control5/LinearVisible.linear_show()


func _on_en_pressed() -> void:
	$Control4/LinearVisible.linear_hide()
	$Control4/En.hide()
	$Control4/Ru.hide()
	GVN.set_language(GvnEnums.languages.En)
	await get_tree().create_timer(1).timeout
	$Control5/LinearVisible.linear_show()


func _on_brigtness_pressed() -> void:
	$Control/LinearVisible.linear_hide()
	await get_tree().create_timer(1).timeout
	$Control2/LinearVisible.linear_show()


func _on_gt_button_pressed() -> void:
	$Control2/LinearVisible.linear_hide()
	await get_tree().create_timer(1).timeout
	$Control3/LinearVisible.linear_show()


func _on_settings_pressed() -> void:
	$Control3/LinearVisible.linear_hide()
	await get_tree().create_timer(1).timeout
	GodoTools.change_scene_with_loading_screen("res://scenes/chapter1_prologue/chapter1_prologue.tscn")


func _on_next_pressed() -> void:
	GvnData.name_protection[GvnEnums.characters.ГлавныйГерой] = $Control5/Label3.text
	$Control5/LinearVisible.linear_hide()
	await get_tree().create_timer(1).timeout
	$Control/LinearVisible.linear_show()


func _process(_delta: float) -> void:
	if GodoTools.is_mobile():
		if $Control5.visible:
			if not $Control5/LineEdit.has_focus():
				$Control5/LineEdit.grab_focus()
