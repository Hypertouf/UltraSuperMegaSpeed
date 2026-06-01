extends Control

@export_group("Node friends")
@export var Anim_enter : AnimationPlayer
@export var Anim_exit : AnimationPlayer
@export var Anim_credits : AnimationPlayer
@export var Anim_quit : AnimationPlayer
@export var Anim_cam : AnimationPlayer
@export var cam : Camera3D
@export var Buttons_detect : Array[Control]
@export var Buttons_display : Array[Control]




func _on_play_mouse_entered() -> void:
	Anim_enter.play("Enter_play")
	Buttons_display[0].set("theme_override_colors/font_color", Color())
	var tween = get_tree().create_tween()
	tween.tween_property(cam, "position", Vector3(0,1.709,2.935), 0.2)
	tween.parallel().tween_property(cam, "rotation_degrees", Vector3(-30,0.0,0.0), 0.2)
	tween.parallel().tween_property(cam, "fov", 97.2, 0.2)
	pass # Replace with function body.


func _on_options_mouse_entered() -> void:
	Anim_exit.play("Main_Menu_anim/Enter_options")
	Buttons_display[1].set("theme_override_colors/font_color", Color())
	pass # Replace with function body.


func _on_play_mouse_exited() -> void:
	Anim_enter.play("Exit_play")
	Buttons_display[0].set("theme_override_colors/font_color", Color(1.0, 1.0, 1.0, 1.0))
	pass # Replace with function body.


func _on_options_mouse_exited() -> void:
	Anim_exit.play("Main_Menu_anim/Exit_options")
	Buttons_display[1].set("theme_override_colors/font_color", Color(1.0, 1.0, 1.0, 1.0))
	pass # Replace with function body.


func _on_credits_mouse_entered() -> void:
	Anim_credits.play("Main_Menu_anim/Enter_credits")
	Buttons_display[2].set("theme_override_colors/font_color", Color())
	pass # Replace with function body.


func _on_credits_mouse_exited() -> void:
	Anim_credits.play("Main_Menu_anim/Exit_credits")
	Buttons_display[2].set("theme_override_colors/font_color", Color(1.0, 1.0, 1.0, 1.0))
	pass # Replace with function body.


func _on_quit_mouse_entered() -> void:
	Anim_quit.play("Main_Menu_anim/Enter_Quit")
	Buttons_display[3].set("theme_override_colors/font_color", Color())
	var tween = get_tree().create_tween()
	tween.tween_property(cam, "position", Vector3(-0.888,1.868,-0.806), 0.2)
	tween.parallel().tween_property(cam, "rotation_degrees", Vector3(-13.5,90.8,-0.2), 0.2)
	tween.parallel().tween_property(cam, "fov", 99.7, 0.2)
	pass # Replace with function body.


func _on_quit_mouse_exited() -> void:
	Anim_quit.play("Main_Menu_anim/Exit_Quit")
	Buttons_display[3].set("theme_override_colors/font_color", Color(1.0, 1.0, 1.0, 1.0))
	pass # Replace with function body.
