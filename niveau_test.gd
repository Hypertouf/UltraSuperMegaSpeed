extends Node3D
#process(delta) #checker à chaque frame
#on_input_press #si c'est appuyé : oui
func _physic_process(delta) :
		var streering = Input.get_axis("droite", "gauche") * 0.4 #so we don't steer too much
		var moteur = Input.get_axis("Accelerer","Freinerreculer") * 100
	
