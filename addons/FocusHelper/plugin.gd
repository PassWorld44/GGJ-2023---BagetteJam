tool
extends EditorPlugin


func _enter_tree():
	add_custom_type("FocusCursor","Sprite",load("res://addons/FocusHelper/FocusCursor.gd"),load("res://addons/FocusHelper/Icons/hand.svg"))


func _exit_tree():
	remove_custom_type("FocusCursor")
