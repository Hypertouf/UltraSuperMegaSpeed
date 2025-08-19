extends Node3D
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
	
func _radio_start(chap):
	
	AnimPlayer.play("Radio_Talk")
	if LayBa.get_child_count() > 0:
		LayBa.get_child(0).queue_free()
	var balloon : Node = load(balloon_path).instantiate()
	LayBa.add_child(balloon)
	balloon.start(resource, chap)
	balloon.EndDiag.connect(StopRadio)
	pass

func StopRadio():
	AnimPlayer.play("RadioIdle")
	print("j'ai reçut le signal j'arrête la radio")

func _on_finish_line_jeufinit() -> void:
	Ui.get_child(0).get_child(3).visible = true
	VStraemPlay.paused = false
	
	#var VPlay = VideoStreamPlayer.new()
	#VPlay.stream = videofin
	#VPlay.autoplay = true
	#VPlay.position = Vector2(-4000,-1500)
	#VPlay.scale = Vector2(2,2)
	#VPlay.z_index = 52
	#Ui.get_child(0).get_child(2).add_child(VPlay)
	
	VStraemPlay.finished.connect(_onVPlayFInished)
	
	pass # Replace with function body.

func _onVPlayFInished ():
	get_tree().quit()
	pass

func _HitBad():
	_radio_start("start")
