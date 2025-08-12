extends Node
class_name Player

var dice: Array
var curBid: Dictionary = {"val": 0, "num": 0}
var myTurn: bool
var playerId: int
var bidNumber: int = 0
var bidValue: int = 1

func _ready() -> void:
	update_selected_display()
	print("Im player ", playerId ," and my dice are ", dice)

func give_id(newPlayerId: int):
	playerId = newPlayerId

func update_dice(newDice: Array):
	dice.assign(newDice)
	print("Im player ", playerId ," and my dice are ", dice)
	
	
func check_dice():
	print(dice)
	
func lost():
	pass
	
func update_curBid(newBid: Dictionary):
	curBid.assign(newBid)
	$UI/Margin/Info_Panel/Latest_Bid/Current_Number.text = str(curBid["num"])
	$UI/Margin/Info_Panel/Latest_Bid/Current_Value_Texture.tooltip_text = str(curBid["val"])


func not_your_turn():
	myTurn = false
	
func your_turn():
	myTurn = true
	$UI/Margin/Controls_Box/Display.visible = myTurn
	$UI/Margin/Controls_Box/Control_Buttons/Your_Turn.visible = myTurn
	

func _on_increase_number_pressed() -> void:
	bidNumber += 1
	update_selected_display()

func _on_decrease_number_pressed() -> void:
	if(bidNumber > curBid["num"]):
		bidNumber -= 1
	else:
		#make a error anim?
		print("cant go lower than curBid number")
	update_selected_display()

func _on_increase_value_pressed() -> void:
	bidValue += 1
	update_selected_display()

func _on_decrease_value_pressed() -> void:
	if(bidValue > curBid["val"]):
		bidValue -= 1
	else:
		#make a error anim?
		print("cant go lower than curBid val")
	update_selected_display()

func update_selected_display():
	$UI/Margin/Controls_Box/Display/Selection_Display/Selected_Number.text = str(bidNumber)
	$UI/Margin/Controls_Box/Display/Selection_Display/Selected_Value_Texture.tooltip_text = str(bidValue)


func _on_lock_bid_pressed() -> void:
	if((bidValue > curBid["val"] && bidNumber >= curBid["num"])||(bidValue >= curBid["val"] && bidNumber > curBid["num"])):
		print("you raise")
		get_parent().raise(playerId, bidNumber, bidValue)


func _on_call_pressed() -> void:
	get_parent().call_bs(playerId)


func _on_spot_on_pressed() -> void:
	get_parent().spot_on(playerId)
