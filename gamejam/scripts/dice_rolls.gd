extends Node
class_name DiceRoll

var dice_rolls = [0,0,0,0,0]
var player_id : int

func _innit():
	var rng = RandomNumberGenerator.new()
	for dice in dice_rolls:
		dice_rolls[dice] = rng.randi_range(1,6)
		
