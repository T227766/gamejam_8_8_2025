extends Node3D




func set_face(number : int, dice : Node3D):
	if number == 1:
		dice.global_rotation_degrees = Vector3(90,0,0)
	elif number == 2:
		dice.global_rotation_degrees = Vector3(0,0,90)
	elif number == 3:
		dice.global_rotation_degrees = Vector3(180,0,0)
	elif number == 4:
		pass
	elif number == 5:
		dice.global_rotation_degrees = Vector3(0,0,270)
	elif number == 6:
		dice.global_rotation_degrees = Vector3(270,0,0)
	


func set_dice(roll : Array):
	for i in range(0,roll.size()):
		var dice = get_child(i)
		if dice == null:
			pass
		else:
			set_face(roll[i], dice)
	
