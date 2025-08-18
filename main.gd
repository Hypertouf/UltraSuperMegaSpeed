extends Node3D
@export var AnimPlayer : AnimationPlayer
@export var Ui : Control
@export var Alayer : VehicleBody3D


func _on_finish_line_jeufinit() -> void:
	print("ok j'essaies de l'ancer l'anim")	
	AnimPlayer.play("Ending")
	
	pass # Replace with function body.
