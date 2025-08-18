extends Node3D

signal jeufinit

func _on_area_3d_body_entered(body: Node3D) -> void:
	print("enter finish line detecté")
	if body is DeoraII :
		print("c'est bien la voiture")
		jeufinit.emit()
		
		pass
	pass # Replace with function body.
