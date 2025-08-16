@tool
extends Node3D

@export var PietonMESH : Mesh
@export var mesh : Node3D


func _ready() -> void:
	mesh.mesh = PietonMESH
	pass


func _input(event):
	if event.is_action_pressed("reaload_meshes"):
		mesh.mesh = PietonMESH
	else :
		pass
