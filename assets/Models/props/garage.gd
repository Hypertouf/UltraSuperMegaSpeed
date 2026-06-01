extends StaticBody3D

@export var anim : AnimationPlayer

@export var lights : Array[MeshInstance3D]

@export var in_menu : bool


func _ready() -> void:
	if in_menu == true :
		pass
	elif in_menu == false :
		for n in lights :
			n.queue_free()
			n.visible = false
		pass
	pass
