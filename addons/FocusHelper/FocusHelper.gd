tool
extends Node


# Fake bool used as a button to update focus order
export(bool) var set_focus_order setget update_order

func update_order(_arg=null):
	var control_children = get_control_children()
	var size = control_children.size()-1
	if control_children.size() > 1:
		for i in range(0,size+1):
			
			# Current node picked in the list
			var current = control_children[i]
			# Previous node picked in the list, last one if the current node is the first in line.
			var previous = control_children[i-1] if i != 0 else control_children[size]
			# Next node picked in the list, first one if the current node is the last in line.
			var next = control_children[i+1] if i != size else control_children[0]
			
			current.focus_previous = current.get_path_to(previous)
			current.focus_neighbour_top = current.get_path_to(previous)
			current.focus_neighbour_left = current.get_path_to(previous)
			
			current.focus_next = current.get_path_to(next)
			current.focus_neighbour_right = current.get_path_to(next)
			current.focus_neighbour_bottom = current.get_path_to(next)


func add_child(node: Node, legible_unique_name: bool = false):
	.add_child(node,legible_unique_name)
	call_deferred("update_order")

func remove_child(node: Node):
	.remove_child(node)
	call_deferred("update_order")



func get_control_children() -> Array:
	var control_children = []
	for i in get_children():
		if i is Control:
			control_children.append(i)
	return control_children
