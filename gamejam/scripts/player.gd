extends Node
class_name Player

var dice: Array
var curBid: Dictionary = {"val": 1, "num": 0}
var myTurn: bool
var playerId: int
var bidNumber: int = 0
var bidValue: int = 1
var isPlayer = true


func _ready() -> void:
	self.rotation = Vector3(0,(get_parent().playerCount*deg_to_rad(90)),0)

func give_id(newPlayerId: int):
	playerId = newPlayerId

@export var player_id : int
@onready var dice_roll: Node3D = $Visuals/Dice


func update_dice(newDice: Array):
	dice.assign(newDice)
	#print(dice)
	
func check_dice():
	#print(dice)
	pass
	
func lost():
	notify("You have LOST this game restart to play again.", false)
	
func update_curBid(newBid: Dictionary):
	curBid.assign(newBid)
	bidNumber = curBid["num"]
	bidValue = curBid["val"]
	$UI/Margin/Info_Panel/Latest_Bid/Current_Number.text = str(curBid["num"])
	$UI/Margin/Info_Panel/Latest_Bid/Container/Current_Value_Texture.frame = curBid["val"]-1
	update_selected_display()


func not_your_turn():
	myTurn = false
	$UI/Margin/Controls_Box/Display.visible = myTurn
	$UI/Margin/Controls_Box/Control_Buttons/Your_Turn.visible = myTurn
	
func your_turn():
	notify("It's your turn", false)
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
		notify(str("Can\'t go lower than Current bid # number"), false)
	update_selected_display()

func _on_increase_value_pressed() -> void:
	if (bidValue < 6):
		bidValue += 1
	else:
		notify(str("Can't go higher than 6 for 🎲 value"), false)
	update_selected_display()

func _on_decrease_value_pressed() -> void:
	if(bidValue > curBid["val"]):
		bidValue -= 1
	else:
		#make a error anim?
		notify(str("Can\'t go lower than Current bid 🎲 value"), false)
	update_selected_display()

func update_selected_display():
	$UI/Margin/Controls_Box/Display/Selection_Display/Selected_Number.text = str(bidNumber)
	$UI/Margin/Controls_Box/Display/Selection_Display/Container/Selected_Value_Texture.frame = bidValue-1


func _on_lock_bid_pressed() -> void:
	if((bidValue > curBid["val"] && bidNumber >= curBid["num"])||(bidValue >= curBid["val"] && bidNumber > curBid["num"])):
		notify(str("You raised the bid to #", bidNumber,"   🎲", bidValue), true)
		get_parent().raise(playerId, bidNumber, bidValue)


func _on_call_pressed() -> void:
	get_parent().call_bs(playerId)


func _on_spot_on_pressed() -> void:
	get_parent().spot_on(playerId)
	

func notify(str: String, wait:bool):
	$UI/Margin/Notifications.text = str
	if(wait):
		await get_tree().create_timer(3.0).timeout
	

func _on_restart_pressed() -> void:
	get_parent().reset()



func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if(anim_name == "shake_cup"):
		dice_roll.set_dice(dice)
		dice_roll.visible = true
		animate("check_dice")


func animate(anim: String):
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
	
func play_sfx(path: String):
	var sfx = load(path)
	$AudioStreamPlayer.stream = sfx
	$AudioStreamPlayer.play()
	
	
