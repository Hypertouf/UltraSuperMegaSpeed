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
@export var garage : StaticBody3D
@export var menu_option : Control
@export var menu_credits : Control
var lvl1 = preload("uid://754vjwcs50eq")
var lvl1_node = lvl1.instantiate()

var exit : bool = false

func _on_play_mouse_entered() -> void:
	Anim_enter.play("Enter_play")
	Buttons_display[0].set("theme_override_colors/font_color", Color())
	var tween = get_tree().create_tween()
	tween.tween_property(cam, "position", Vector3(-0.48,1.5,2.935), 0.2)
	tween.parallel().tween_property(cam, "rotation_degrees", Vector3(-30,0.0,0.0), 0.2)
	tween.parallel().tween_property(cam, "fov", 97.2, 0.2)
	menu_option.visible = false
	menu_credits.visible = false
	pass # Replace with function body.


func _on_options_mouse_entered() -> void:
	Anim_exit.play("Main_Menu_anim/Enter_options")
	Buttons_display[1].set("theme_override_colors/font_color", Color())
	var tween = get_tree().create_tween()
	tween.tween_property(cam, "position", Vector3(-1.316,0.764,0.353), 0.2)
	tween.parallel().tween_property(cam, "rotation_degrees", Vector3(-32.1,-156.4,-0.3), 0.2)
	tween.parallel().tween_property(cam, "fov", 75.0, 0.2)
	menu_credits.visible = false
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
	var tween = get_tree().create_tween()
	tween.tween_property(cam, "position", Vector3(-1.891,1.48,-1.986), 0.2)
	tween.parallel().tween_property(cam, "rotation_degrees", Vector3(-17.7,-90,0.0), 0.2)
	tween.parallel().tween_property(cam, "fov", 75.0, 0.2)
	menu_option.visible = false
	pass # Replace with function body.


func _on_credits_mouse_exited() -> void:
	Anim_credits.play("Main_Menu_anim/Exit_credits")
	Buttons_display[2].set("theme_override_colors/font_color", Color(1.0, 1.0, 1.0, 1.0))
	pass # Replace with function body.


func _on_quit_mouse_entered() -> void:
	Anim_quit.play("Main_Menu_anim/Enter_Quit")
	Buttons_display[3].set("theme_override_colors/font_color", Color())
	var tween = get_tree().create_tween()
	tween.tween_property(cam, "position", Vector3(-0.666,1.868,-0.039), 0.2)
	tween.parallel().tween_property(cam, "rotation_degrees", Vector3(-13.5,90.8,-0.2), 0.2)
	tween.parallel().tween_property(cam, "fov", 99.7, 0.2)
	menu_option.visible = false
	menu_credits.visible = false
	pass # Replace with function body.


func _on_quit_mouse_exited() -> void:
	Anim_quit.play("Main_Menu_anim/Exit_Quit")
	Buttons_display[3].set("theme_override_colors/font_color", Color(1.0, 1.0, 1.0, 1.0))
	pass # Replace with function body.


func _on_button_pressed() -> void:
	garage.anim.play("Ouvre")
	Anim_cam.play("tuturevroum")
	pass # Replace with function body.


func _on_button_4_pressed() -> void:
	Anim_cam.play("fadetoblack")
	exit = true
	pass # Replace with function body.


func _on_animation_player_camera_animation_finished(anim_name: StringName) -> void:
	if anim_name == "fadetoblack" and exit == true:
			get_tree().quit()
	if anim_name == "tuturevroum":
		add_sibling(lvl1_node)
		queue_free()
		pass
	pass # Replace with function body.


func _on_button_2_pressed() -> void:
	menu_option.visible = true
	pass # Replace with function body.


func _on_button_3_pressed() -> void:
	menu_credits.visible = true
	pass # Replace with function body.
