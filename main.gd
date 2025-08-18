extends Node3D
@export var AnimPlayer : AnimationPlayer
@export var Ui : Control
@export var Player : VehicleBody3D
@export var videofin : VideoStreamTheora
@export_enum("Good", "Bad", "Osef") var character_class: int
var Dlg_Sct = load("uid://bbbh1af5b4qeb") #La ou est rangé le dialogue qui est lu dans le ballon
var balloon_path : String = ProjectSettings.get_setting("dialogue_manager/runtime/balloon_path")
var resource := load("uid://bbbh1af5b4qeb")

func _ready() -> void:
	
	pass
	
func _radio_start(chap):
	
	AnimPlayer.play("Radio_Talk")
	var balloon : Node = load(balloon_path).instantiate()
	self.add_child(balloon)
	balloon.start(resource, chap)
	balloon.EndDiag.connect(StopRadio)
	pass

func StopRadio():
	AnimPlayer.play("RadioIdle")
	print("j'ai reçut le signal j'arrête la radio")

func _on_finish_line_jeufinit() -> void:
	Ui.get_child(0).get_child(2).visible = true
	
	var VPlay = VideoStreamPlayer.new()
	VPlay.stream = videofin
	VPlay.autoplay = true
	VPlay.position = Vector2(100,0)
	Ui.get_child(0).get_child(2).add_child(VPlay)
	VPlay.finished.connect(_onVPlayFInished)
	pass # Replace with function body.

func _onVPlayFInished ():
	get_tree().quit()
	pass

func _HitBad():
	_radio_start("start")
