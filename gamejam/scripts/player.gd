extends Node

var dice: Array
var curBid: Dictionary
var myTurn: bool

func update_dice(newDice: Array):
	dice.assign(newDice)
	
func update_curBid(newBid: Dictionary):
	curBid.assign(newBid)

func check_dice():
	print(dice)

func bid(bidVal ,bidNum):
	if((bidVal > curBid["val"] && bidNum >= curBid["num"])||(bidVal >= curBid["val"] && bidNum > curBid["num"])):
		pass
	
func spot_on():
	pass
	
func call_lie():
	pass
	
func this_player_turn():
	pass
