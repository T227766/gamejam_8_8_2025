extends Node3D

@onready var background_vp: SubViewport = $MainCamera/BackgroundVC/BackgroundVP
@onready var foreground_vp: SubViewport = $MainCamera/ForegroundVC/ForegroundVP

@onready var background_cam: Camera3D = $MainCamera/BackgroundVC/BackgroundVP/BackgroundCam
@onready var foreground_cam: Camera3D = $MainCamera/ForegroundVC/ForegroundVP/ForegroundCam
@onready var main_camera: Camera3D = $MainCamera


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func resize():
	background_vp.size = DisplayServer.window_get_size()
	foreground_vp.size = DisplayServer.window_get_size()
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	main_camera.global_transform = background_cam.global_transform
	
