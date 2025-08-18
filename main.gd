extends Node3D
@export var AnimPlayer : AnimationPlayer
@export var Ui : Control
@export var Player : VehicleBody3D
@export var videofin : VideoStreamTheora

func _on_finish_line_jeufinit() -> void:
	Ui.get_child(0).get_child(2).visible = true
	
	var VPlay = VideoStreamPlayer.new()
	VPlay.stream = videofin
	VPlay.autoplay = true
	VPlay.position = Vector2(100,0)
	Ui.get_child(0).get_child(2).add_child(VPlay)
	pass # Replace with function body.
