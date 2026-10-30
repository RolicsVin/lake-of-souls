extends Node

var _buffer: Dictionary = {}

# Время последнего нажатия Space в миллисекундах
var _last_space_press_time: int = -1000000

# Сколько времени после Space запрещено сохраняться
const SAVE_SPACE_LOCK_TIME: int = 500


func _input(event: InputEvent) -> void:
	if event is InputEventKey:
		if event.keycode == KEY_SPACE and event.pressed and not event.echo:
			_last_space_press_time = Time.get_ticks_msec()
	if Input.is_action_just_pressed("log"):
		print_all_singleton_variables()


func _is_save_locked() -> bool:
	var current_time := Time.get_ticks_msec()
	
	return current_time - _last_space_press_time < SAVE_SPACE_LOCK_TIME


func _get_obj_on_buffer(k):
	"""Вернёт объект из буфера по ключу."""
	return _buffer[k]


func _get_buffer() -> Dictionary:
	"""Вернёт буффер"""
	return _buffer


func _write_buffer(obj, k) -> void:
	"""Допишет в буфер информацию по ключу. Если ключ уже существует, то информация будет перезаписана."""
	_buffer[k] = obj


func get_project_version() -> String:
	var version: String = ''
	
	for i: String in GodoTools.read_lines("res://project.godot"):
		if 'config/version' in i:
			var start_position = i.find('"') + 1
			var end_position = i.find('"', 1) - 2
			version = i.substr(start_position, end_position)
			break
	
	return version


func save():
	# Защита от сохранения сразу после нажатия Space
	#if _is_save_locked():
		#print("Сохранение заблокировано: недавно был нажат Space.")
		#return
	
	print('Печатает центральное ядро игры')
	print('Создание сохранения...')
	
	var save_name = 'lake_of_souls_save_' + get_project_version() + '_number' + str(len(get_saves())) + '.save'
	
	var icon = GodoTools.take_screenshot()
	var screen_size = DisplayServer.screen_get_size(DisplayServer.window_get_current_screen())
	icon.resize(round(screen_size.x / 3), round(screen_size.y / 3), Image.INTERPOLATE_CUBIC)
	
	var save_data = {
		'godo_combat': GCombat.get_save(),
		'godo_tools': GodoTools.get_save(),
		'godo_visual_novel': GVN.get_save(),
		'scene': get_tree().current_scene.scene_file_path,
		'version': get_project_version(),
		'data': GodoTools.get_date(),
		'time': GodoTools.get_time(),
		'icon_data': icon.save_jpg_to_buffer()
	}
	
	print('Сохранение: ', save_data)
	print(GodoTools.save_path + save_name)
	print('Запись сохранения...')
	
	var file = FileAccess.open((GodoTools.save_path + save_name).replace('"', ''), FileAccess.WRITE)
	file.store_var(save_data)
	
	print('Сохранение записано.')
	
	print()
	print('GlobalSave-------------------------------------')
	print(save_data)
	print('-----------------------------------------------')
	print()


func get_saves():
	"""Возращает список файлов(Array[String]), если такая папка существует."""
	var dir = DirAccess.open(GodoTools.save_path)
	
	if dir == null:
		print('Печатает центральное ядро игры')
		print("Не удалось открыть папку")
		return
	
	return dir.get_files()


func get_save(save_name: String) -> Dictionary:
	print('Печатает центральное ядро игры')
	print('Чтение сохранения...')
	var file = FileAccess.open(GodoTools.save_path + save_name, FileAccess.READ)
	var data: Dictionary = file.get_var()
	 
	var icon = Image.new()
	icon.load_jpg_from_buffer(data['icon_data'])
	
	data['icon'] = icon
	data.erase('icon_data')
	
	print('Сохранение прочитано.')
	
	return data


func load_save(_save: Dictionary):
	print('Печатает центральное ядро игры')
	print('Загрузка сохранения...')
	GCombat.load_save(_save['godo_combat'])
	GodoTools.load_save(_save['godo_tools'])
	GVN.load_save(_save['godo_visual_novel'])
	GodoTools.change_scene(_save['scene'])
	print('Сохранение загружено.')
	
	print()
	print('GlobalSave_load-------------------------------------')
	print(_save)
	print('-----------------------------------------------')
	print()


func print_all_singleton_variables() -> void:
	print('Печатает центральное ядро игры')
	print('Запрошен лог всех синглтонов')
	print()
	
	var root := get_tree().root
	
	for singleton in root.get_children():
		var properties := singleton.get_property_list()
		var has_variables := false
		
		for property in properties:
			# Берём только переменные, объявленные в скрипте
			if property.usage & PROPERTY_USAGE_SCRIPT_VARIABLE:
				if not has_variables:
					print("\n========== ", singleton.name, " ==========")
					has_variables = true
				
				var variable_name: String = property.name
				var value = singleton.get(variable_name)
				
				print(variable_name, " = ", value)
	print()
