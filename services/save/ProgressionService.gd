extends Node


var dir_path = "user://saves/"
var filename = "progression.json"

var data: Progression


func init():
	DirAccess.make_dir_recursive_absolute(dir_path)
	data = _load()


func save(progression: Progression):
	data = progression
	
	var content = _serialize(progression)
	var file = FileAccess.open(dir_path + filename, FileAccess.WRITE)
	file.store_string(content)
	file.close()


func clear():
	DirAccess.remove_absolute(dir_path + filename)


func _load():
	if FileAccess.file_exists(dir_path + filename):
		var file = FileAccess.open(dir_path + filename, FileAccess.READ)
		var data = _parse(file.get_as_text())
		file.close()
		return data
	else:
		return Progression.new(0)


func _serialize(progression: Progression) -> String:
	return JSON.stringify({
		"coins": progression.coins
	})


func _parse(json: String) -> Progression:
	var dict = JSON.parse_string(json)
	return Progression.new(
		dict["coins"]
	)
