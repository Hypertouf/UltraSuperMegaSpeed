extends Node3D

class_name ground

@export var AnimPlayer : AnimationPlayer
@export var Ui : Control
@export var Player : VehicleBody3D
@export var videofin : VideoStreamTheora
@export var VStraemPlay : VideoStreamPlayer
@export_enum("Good", "Bad", "Osef") var character_class: int
var Dlg_Sct = load("uid://bbbh1af5b4qeb") #La ou est rangé le dialogue qui est lu dans le ballon
var balloon_path : String = ProjectSettings.get_setting("dialogue_manager/runtime/balloon_path")
var resource := load("uid://bbbh1af5b4qeb")
@export var LayBa : CanvasLayer


#region story counter

@export var Bad_Child : int = 0
@export var Good_Child : int = 0
@export var Bad_Business : int = 0
@export var Good_Business : int = 0
@export var Total_kills : int = 0

#endregion

#region story counter func

func AddOne(num : int):
	if num == 0 :
		Bad_Child += 1
		print_rich("another one bites the dust")
		print_rich(Bad_Child)
	pass	
	
#endregion



func _ready() -> void:
	
	pass
	
