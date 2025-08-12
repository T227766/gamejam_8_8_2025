extends Node


const MAIN_PLAYER = preload("res://scenes/player_character.tscn")
const BOT_PLAYER = preload("res://scenes/bot_character.tscn")

var playerCount = 0
var startingDiceCount = 5
var cups: Array
var curBid: Dictionary = {"val": 1, "num": 0}
var players: Array
var que: Array



func _ready() -> void:
	
	add_player()
	await get_tree().create_timer(3.0).timeout

	add_bot()
	add_bot()
	add_bot()

	initialize()
	#print("Starting rolls are", cups)


func add_player():
	if(playerCount < 4):
		var newPlayer = MAIN_PLAYER.instantiate()
		newPlayer.give_id(playerCount)
		players.append(newPlayer)
		add_child(newPlayer)
		playerCount += 1
		announce(str("New Player Joined the game as player ", newPlayer.playerId), false)
		
func add_bot():
	if(playerCount < 4):
		var newBot = BOT_PLAYER.instantiate()
		newBot.give_id(playerCount)
		players.append(newBot)
		add_child(newBot)
		playerCount += 1
		announce(str("New Bot Joined the game as player ", newBot.playerId), true)
		
	
func initialize():
	# add players to que
	for p in players:
		que.append(p)
	#make a 2D array
	for cup in range(playerCount):
		cups.append(Array())
	#give each player random dice
	for cup in cups:
		for dice in startingDiceCount:
			cup.append(randi_range(1,6))
	for p in players:
		p.update_dice(cups[p.playerId])
		p.update_curBid(curBid)
	b_anim("shake_cup")
	que[0].your_turn()

func reset():
	cups.clear()
	que.clear()
	announce(str("Restarting Game"), true)
	initialize()

func b_anim(anim):
	for p in players:
		p.animate(anim)

#randomize players dice
func shake_dice():
	for p in players:
		p.hide_dice()
	b_anim("shake_cup")
	for cup in cups:
		for n in range(cup.size()):
			cup[n] = randi_range(1,6)
	for p in players:
		p.update_dice(cups[p.playerId])
		
func next_round():
	curBid = {"val": 1, "num": 0}
	for p in players:
		p.not_your_turn()
		p.update_curBid(curBid)
	shake_dice()
	que[0].your_turn()

func next_turn():
	que.append(que[0])
	que.pop_front()
	que[0].your_turn()
	
func whos_turn(playerId):
	while(que[0].playerId != playerId):
		que.append(que[0])
		que.pop_front()
		que[0].your_turn()
	
func reveal_all_dice():
	#show all dica on table
	pass
	
func check_for_winner():
	if(que.size() == 1): # we have a winner
		announce(str("player ", que[0].playerId, "has won!\nRestart to play again!"), false)
		return true
	else:
		return false
	
	
func if_lost(playerId): #check ifa  player has lost all their dice if that is the case remove the player from the que
	if(cups[playerId].size() == 0):
		for n in range(que.size()-1, -1, -1):
			if (que[n].playerId == playerId):
				que[n].lost()
				que.pop_at(n)
				announce(str("PLayer ", playerId, "is removed from this game"), true)
		check_for_winner()
		return true
	else:
		return false
	
func call_bs(playerId: int):
	reveal_all_dice()
	var count = count(curBid["val"])
	announce(str("Player ", playerId, "Calls Lie!"), true)
	for cup in cups:
		for dice in cup:
			if(dice == curBid["val"]):
				count += 1
	announce(str("there are ", count, "dice with value ",curBid["val"]), true)
	if(count >= curBid["num"]):
		#wrong call
		announce(str("It was NOT a LIE! \nPLayer ", playerId, "looses a dice\n they have ",cups[playerId].size(), "Dice left"), true)
		cups[playerId].pop_back()
		if(!if_lost(playerId)):
			whos_turn(playerId)
	else:
		#last guy lied
		cups[que[-1].playerId].pop_back()
		announce(str("It WAS a LIE! \nPLayer ", playerId, "looses a dice\n they have ",cups[playerId].size(), "Dice left"), true)
		if_lost(que[-1].playerId)
	next_round()
	
func spot_on(playerId: int):
	reveal_all_dice()
	announce(str("Player ", playerId, "Calls Spot On!"), true)
	var count = count(curBid["val"])
	announce(str("there are ", count, "dice with value ",curBid["val"]), true)
	if(count != curBid["num"]):
		#wrong call lose a dice
		cups[playerId].pop_back()
		announce(str("It was NOT spot ON! \nPLayer ", playerId, "looses a dice\n they have ",cups[playerId].size(), "Dice left"), true)
		if(!if_lost(playerId)):
			whos_turn(playerId)
	else:
		#spot on! every body lose a dice exept playerId
		announce(str("It was SPOT ON! \nall other PLayer will lose 1 Dice\n ", get_total_dice(), " Total Dice remain on the table"), true)
		for p in que:
			if(p.playerId != playerId):
				cups[p.playerId].pop_back()
				if_lost(p.playerId)
	next_round()
	
func raise(playerId: int, bidNumber:int, bidValue:int):
	if(((bidValue > curBid["val"] && bidNumber >= curBid["num"])||(bidValue >= curBid["val"] && bidNumber > curBid["num"])) and playerId == que[0].playerId):
		curBid["val"] = bidValue
		curBid["num"] = bidNumber
		for p in players:
			p.update_curBid(curBid)
			announce(str(playerId, "Raised the bid!"), true)
	next_turn()

	
func get_total_dice():
	var totalDice = 0
	for cup in cups:
		for dice in cup:
			totalDice += 1
	return totalDice
	
func count(val: int):
	var c = 0
	for cup in cups:
		for dice in cup:
			if(dice == val):
				c += 1
	return c
	
func announce(str: String, wait:bool):
	for p in players:
		if(p.isPlayer == true):
			p.notify(str, wait)
	if(wait):
		await get_tree().create_timer(3.0).timeout
	return
