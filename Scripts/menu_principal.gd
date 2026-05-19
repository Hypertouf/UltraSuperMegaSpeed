extends Control

@export_group("Node friends")
@export var Anim : AnimationPlayer
@export var Buttons : Array[Control]


func _on_play_focus_entered() -> void:
	print("PLAY HAS FOCUS")
	pass # Replace with function body.


func _on_options_focus_entered() -> void:
	print("OPTIONS HAS FOCUS")
	pass # Replace with function body.


func _on_credits_focus_entered() -> void:
	print("CREDITS HAS FOCUS")
	pass # Replace with function body.


func _on_exit_focus_entered() -> void:
	print("EXIT HAS FOCUS")
	pass # Replace with function body.
