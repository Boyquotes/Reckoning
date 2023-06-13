extends Node

var file_path = "user://health.save"

func save_health(health):
	var f = FileAccess.open(file_path, FileAccess.WRITE)
	f.store_float(health)
	f.close()
	
func load_health():
	if not FileAccess.file_exists(file_path):
		save_health(100)
		
	var f = FileAccess.open(file_path, FileAccess.READ)
	var health = f.get_float()
	f.close()
	return health
