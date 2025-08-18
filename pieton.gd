@tool

extends Node3D

@export var PietonMESH : Mesh
@export var mesh : Node3D
@export var explo : MeshInstance3D
@export_enum("Good", "Bad", "Osef") var Karma: int


func _ready() -> void:
	mesh.mesh = PietonMESH
	if Karma == 2 :
		print("ok")
	pass


func _input(event):
	if event.is_action_pressed("reaload_meshes"):
		mesh.mesh = PietonMESH
	else :
		pass
