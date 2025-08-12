extends Node

const TEST_PLAYER = preload("res://scenes/test_player.tscn")
const BOT_PLAYER = preload("res://scenes/bot.tscn")


var playerCount = 0
var startingDiceCount = 5
var cups: Array
var curBid: Dictionary = {"val": 1, "num": 0}
var players: Array
var que: Array


func _ready() -> void:
	add_player()
	add_bot()
	initialize()
	print("Starting rolls are", cups)


func add_player():
	if(playerCount < 4):
		var newPlayer = TEST_PLAYER.instantiate()
		newPlayer.give_id(playerCount)
		players.append(newPlayer)
		que.append(newPlayer)
		add_child(newPlayer)
		playerCount += 1
		
func add_bot():
	if(playerCount < 4):
		var newBot = BOT_PLAYER.instantiate()
		newBot.give_id(playerCount)
		players.append(newBot)
		que.append(newBot)
		add_child(newBot)
		playerCount += 1
	
func initialize():
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
	que[0].your_turn()

#randomize players dice
func shake_dice():
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
		return true
	else:
		return false
	
func if_lost(playerId): #check ifa  player has lost all their dice if that is the case remove the player from the que
	if(cups[playerId].size() == 0):
		que[playerId].lost()
		que.pop_at(playerId)
		check_for_winner()
		return true
	else:
		return false
	
func call_bs(playerId: int):
	reveal_all_dice()
	var count = count(curBid["val"])
	print("there are ", count, "dice with value ",curBid["val"])
	for cup in cups:
		for dice in cup:
			if(dice == curBid["val"]):
				count += 1
	if(count >= curBid["num"]):
		#wrong call
		cups[playerId].pop_back()
		if(!if_lost(playerId)):
			whos_turn(playerId)
	else:
		#last guy lied
		cups[que[-1].playerId].pop_back()
		if_lost(que[-1].playerId)
	next_round()
	
func spot_on(playerId: int):
	reveal_all_dice()
	var count = count(curBid["val"])
	print("there are ", count, "dice with value ",curBid["val"])
	if(count != curBid["num"]):
		#wrong call lose a dice
		cups[playerId].pop_back()
		if(!if_lost(playerId)):
			whos_turn(playerId)
	else:
		#spot on! every body lose a dice exept playerId
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
	
	
