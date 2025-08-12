extends Node
class_name Player

var dice: Array
var curBid: Dictionary
var myTurn: bool

@export var player_id : int
@onready var dice_roll: Node3D = $Visuals/Dice


func update_dice(newDice: Array):
	dice.assign(newDice)
	
func update_curBid(newBid: Dictionary):
	curBid.assign(newBid)

func check_dice():
	print(dice)

func check_bid(bidVal ,bidNum):
	if((bidVal > curBid["val"] && bidNum >= curBid["num"])||(bidVal >= curBid["val"] && bidNum > curBid["num"])):
		return true
	else:
		return false

func spot_on():
	pass
	
func call_lie():
	pass
	
func this_player_turn():
	pass


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	dice_roll.visible = true
	dice_roll.set_dice([1,4,5,2,6])
