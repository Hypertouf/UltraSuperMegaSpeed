extends Node3D

@export var PietonMESH : Mesh
@export var mesh : Node3D
@export var explo : MeshInstance3D
@export_enum("Good", "Bad", "Osef") var Karma: int
@export var child_quotes : AudioStreamPlayer3D


func _ready() -> void:
	mesh.mesh = PietonMESH
	$Timer.start(randf_range(0.5, 3.0))
	pass

func _process(delta: float) -> void:
	if $Timer.is_stopped() :
		child_quotes.play()
		
func _on_child_quotes_finished() -> void:
	$Timer.start(randf_range(0.7, 3.0))
