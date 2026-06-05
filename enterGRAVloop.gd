extends Area3D

class_name enterGRAVloop

func _on_badtothebone_finished() -> void:
	$badtothebone.play()


func _on_badtothebone_2_finished() -> void:
	$badtothebone2.play()


func _on_badtothebone_3_finished() -> void:
	$badtothebone3.play()


func _on_badtothebone_4_finished() -> void:
	$badtothebone4.play()
