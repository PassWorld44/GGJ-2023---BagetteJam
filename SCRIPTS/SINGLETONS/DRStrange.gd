extends Node

signal loaded()
signal saved()



#Sauvegarde & Variables à garder dedans

var highscore = 0 setget set_highscore, get_highscore
var last_level : int

const default_save = "user://sauvegarde.data"
var password = "osef1234"

func _ready():
	load_values()
	

#Sauvegarde et chargement d'anciennes données
func load_values():
	var file = File.new()
	if file.file_exists(default_save):
		var err = file.open_encrypted_with_pass(default_save,File.READ,password)
		if err != OK:
			return
		else:
			var player_data = file.get_var()
			for i in player_data.keys():
				if get(i) != null:
					set(i,player_data[i])
	file.close()
	yield(get_tree(),"idle_frame")
	emit_signal("loaded")

func save_variables():
	var file = File.new()
	var error = file.open_encrypted_with_pass(default_save,File.WRITE,password)
	if error == OK:
		file.store_var(get_data())
		file.close()
	emit_signal("saved")


func get_data():
	return {
		"highscore":highscore,
	}

# MEILLEUR SCORE ------------------------------|
func set_highscore(value):
	highscore = value
	save_variables()

func get_highscore():
	return highscore


# SAUVEGARDER ET QUITTER ----------------------|
func _notification(event):
	if (event == MainLoop.NOTIFICATION_WM_QUIT_REQUEST) or (event == MainLoop.NOTIFICATION_WM_GO_BACK_REQUEST):
		save_variables()
		get_tree().quit()
