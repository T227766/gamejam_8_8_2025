extends Node

var playerCount = 2
var startingDiceCount = 5
var cups : Array
var curBid = {"val": 0, "num": 0}
const PLAYER = preload("res://scenes/player.tscn")


func _ready() -> void:
	
	add_player()
	print_tree_pretty()	
	print("we have ", playerCount, " players")
	
	initialize()
	print("Starting rolls are", cups)
	
	shake_dice()
	print("re roll           ", cups)

	

func add_player():
	playerCount += 1
	
func initialize():
	#make a 2D array
	for cup in range(playerCount):
		cups.append(Array())
	#give each player random dice
	for cup in cups:
		for dice in startingDiceCount:
			cup.append(randi_range(1,6))

#randomize players dice
func shake_dice():
	for cup in cups:
		for n in range(0, cup.size() ):
			cup[n] = randi_range(1,6)

	
func reveal_all_dice():
	#show all dica on table
	pass
	
func check_for_winner():
	#check if only one player remains
	pass
