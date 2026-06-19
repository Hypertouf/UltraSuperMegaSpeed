extends StaticBody3D
@export var anim : AnimationPlayer

func _ready() -> void:
	anim.play("idle")
	pass
