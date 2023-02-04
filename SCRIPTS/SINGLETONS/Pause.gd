extends CanvasLayer

signal paused()
signal unpaused()

onready var cover = $Cover

func _ready():
	connect("unpaused",get_tree(),"set",["paused",false])
	connect("paused",get_tree(),"set",["paused",true])

func _input(event):
	if event.is_action_pressed("ui_pause"):
		toggle_pause()

func pause():
	emit_signal("paused")
	print("has been paused")

func unpause():
	emit_signal("unpaused")
	print("HAS BEEN UNPAUSED")

func toggle_pause():
	unpause() if get_tree().paused else pause()
