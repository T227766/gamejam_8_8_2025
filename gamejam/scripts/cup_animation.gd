extends AnimationPlayer

var timer : Timer
# Called when the node enters the scene tree for the first time.
func play_shake_cup():
	play("shake cup")
	timer = Timer.new()
	timer.wait_time = get_animation("shake cup").duration
	timer.one_shot = true
	



	
func is_animation_finished()
