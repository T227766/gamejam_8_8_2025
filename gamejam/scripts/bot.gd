extends Node

var dice: Array
var curBid: Dictionary = {"val": 0, "num": 0}
var myTurn: bool
var playerId: int
var bidNumber: int = 0
var bidValue: int = 0

func _ready() -> void:
	print("Im bot player ", playerId ," and my dice are ", dice)

func give_id(newPlayerId: int):
	playerId = newPlayerId

func update_dice(newDice: Array):
	dice.assign(newDice)
	
func lost():
	pass
	
func update_curBid(newBid: Dictionary):
	curBid.assign(newBid)
	bidNumber = curBid["num"]
	bidValue = curBid["val"]

func not_your_turn():
	#myTurn = false
	pass
	
func your_turn():
	var totalDice = get_parent().get_total_dice()
	var myDice = 0
	for d in dice:
		myDice += 1
	var eDice = totalDice - myDice
	var g = grnt(curBid["val"])
	if(g >= curBid["num"]):
		# DO NOT CALL. RAISE
		raise_bid()
	elif((eDice + g) < curBid["num"]):
		# IMPOSIBLE SO CALL_BS
		print("bot: BS!")
		get_parent().call_bs(playerId)
	else:
		# could be a lie or not
		# calculate and raise or call base on it
		var rng = randf_range(0 , 1)
		if(rng >= p_value(eDice,g)):
			#raise
			raise_bid()
		else:
			#call_bs
			print("bot: BS!")
			get_parent().call_bs(playerId)


func p_value(eDice, g) -> float:
	var x = ((eDice/6)+g)/curBid["num"]
	return  float(1/(x+1))
	
func grnt(val):
	var count = 0
	for d in dice:
		if(d == val):
			count += 1
	return count
	
func raise_bid():
	print("bot: raise")
	
	# garanteed raise
	var grntVals: Array
	var g = grnt(curBid["val"])
	if(g > curBid["num"]):
		grntVals.append(curBid["val"])
	for n in range(1, (6 - curBid["val"])):
		g = grnt(curBid["val"] + n)
		if(g >= curBid["num"]):
			grntVals.append(curBid["val"] + n)
	if(grntVals.size() > 0):
		bidValue = grntVals[randi_range(0, grntVals.size()-1)]
		bidNumber = randi_range(curBid["num"]+1, grnt(bidValue))
		print("bot player", playerId, "is doing a granti raise to", bidNumber,bidValue, "\n this number was chosen randomly between #", curBid["num"]+1 , " ", grnt(bidValue))
		get_parent().raise(playerId, bidNumber, bidValue)
	else:
		# risky raise
		var totalDice = get_parent().get_total_dice()
		var myDice = 0
		for d in dice:
			myDice += 1
		var eDice = totalDice - myDice
		var minP = 2
		for n in range(0, (6 - curBid["val"])):
			g = grnt(curBid["val"] + n)
			if(p_value(eDice, g) < minP):
				minP = p_value(eDice, g)
				bidValue = curBid["val"] + n
		bidNumber = curBid["num"] + 1
		print("bot player", playerId, "is doing a riski raise to", bidNumber,bidValue)
		get_parent().raise(playerId, bidNumber, bidValue)

				
			
	
'''
	if(bidNumber > curBid["num"]):
		bidNumber -= 1
	else:
		#make a error anim?
		print("cant go lower than curBid")

	if(bidNumber > curBid["val"]):
		bidValue -= 1
	else:
		#make a error anim?
		print("cant go lower than curBid")
	update_selected_display()

	if((bidValue > curBid["val"] && bidNumber >= curBid["num"])||(bidValue >= curBid["val"] && bidNumber > curBid["num"])):
		get_parent().raise(playerId, bidNumber, bidValue)

	get_parent().call_bs(playerId)

	get_parent().spot_on(playerId)
	
'''
