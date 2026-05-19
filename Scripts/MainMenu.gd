extends Control

@export_group("Node friends")
@export var Anim_enter : AnimationPlayer
@export var Anim_exit : AnimationPlayer
@export var Anim_credits : AnimationPlayer
@export var Anim_quit : AnimationPlayer
@export var Buttons : Array[Control]




func _on_play_mouse_entered() -> void:
	Anim_enter.play("Enter_play")
	Buttons[0].set("theme_override_colors/font_color", Color())
	pass # Replace with function body.


func _on_options_mouse_entered() -> void:
	Anim_exit.play("Main_Menu_anim/Enter_options")
	Buttons[1].set("theme_override_colors/font_color", Color())
	pass # Replace with function body.


func _on_play_mouse_exited() -> void:
	Anim_enter.play("Exit_play")
	Buttons[0].set("theme_override_colors/font_color", Color(1.0, 1.0, 1.0, 1.0))
	pass # Replace with function body.


func _on_options_mouse_exited() -> void:
	Anim_exit.play("Main_Menu_anim/Exit_options")
	Buttons[1].set("theme_override_colors/font_color", Color(1.0, 1.0, 1.0, 1.0))
	pass # Replace with function body.


func _on_credits_mouse_entered() -> void:
	Anim_credits.play("Main_Menu_anim/Enter_credits")
	Buttons[2].set("theme_override_colors/font_color", Color())
	pass # Replace with function body.


func _on_credits_mouse_exited() -> void:
	Anim_credits.play("Main_Menu_anim/Exit_credits")
	Buttons[2].set("theme_override_colors/font_color", Color(1.0, 1.0, 1.0, 1.0))
	pass # Replace with function body.


func _on_quit_mouse_entered() -> void:
	Anim_quit.play("Main_Menu_anim/Enter_Quit")
	Buttons[3].set("theme_override_colors/font_color", Color())
	pass # Replace with function body.


func _on_quit_mouse_exited() -> void:
	Anim_quit.play("Main_Menu_anim/Exit_Quit")
	Buttons[3].set("theme_override_colors/font_color", Color(1.0, 1.0, 1.0, 1.0))
	pass # Replace with function body.
