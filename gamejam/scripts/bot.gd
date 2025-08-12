extends Node

var dice: Array
var curBid: Dictionary = {"val": 0, "num": 0}
var myTurn: bool
var cupIsUp: bool
var idle: bool = true
var playerId: int
var bidNumber: int = 0
var bidValue: int = 0
var botBias
var isPlayer = false

@onready var dice_roll: Node3D = $Visuals/Dice

func _ready() -> void:
	botBias = randf_range(-0.30,0.10)
	#print("Im bot player ", playerId ," and my dice are ", dice)
	self.rotation = Vector3(0,(get_parent().playerCount*deg_to_rad(90)),0)


func give_id(newPlayerId: int):
	playerId = newPlayerId

func update_dice(newDice: Array):
	dice.assign(newDice)
	
func lost():
	self.visible = false
	
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
	return  float((1/(x+1)) + botBias)
	
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
		if(bidValue == curBid["val"]):
			bidNumber = curBid["num"]+1
		elif(curBid["num"]+1 <= grnt(bidValue)):
			bidNumber = randi_range(curBid["num"]+1, grnt(bidValue))
		else:
			bidNumber = curBid["num"]+1
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

func animate(anim: String):
	idle = false
	if(anim == "shake_cup"):
		$AnimationPlayer.play("hide_dice")
		await $AnimationPlayer.animation_finished
		hide_dice()
		$AnimationPlayer.play(anim)
		play_sfx("res://assets/sfx/diceshake.mp3")
	else:
		$AnimationPlayer.play(anim)


func hide_dice():
	dice_roll.visible = false
	
func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if(anim_name == "shake_cup"):
		dice_roll.set_dice(dice)
		dice_roll.visible = true
		animate("check_dice")
		cupIsUp = true
	idle = true
	
	
func randomly_check_dice():
	if(cupIsUp and  idle):
		animate("hide_dice")
		cupIsUp = false
	elif(idle):
		animate("check_dice")
		cupIsUp = true
	$Timer.wait_time = randf_range(1.0,10.0)

func _on_timer_timeout() -> void:
	randomly_check_dice()

func play_sfx(path: String):
	var sfx = load(path)
	$AudioStreamPlayer.stream = sfx
	$AudioStreamPlayer.play()
