extends Control

var entered = false

export var title = "Play"
export var description = ""
export (String, "Normal", "Cave", "Fast") var mode

export var ScenePath = "res://scenes/Level.tscn"

func _ready():
	set_process(true)
	$title.text = title
	$mode.text = "-" + description + "-"

func _process(delta):
	if get_node("../../../Main").visible: visible = true
	else: visible = false

func _on_Area2D_area_shape_entered(area_id, area, area_shape, self_shape):
	if not entered && area.name == "Mouse":
		#get_parent().layer = 2
		$animPlayer.play("anim")
		entered = true


func _on_Area2D_area_shape_exited(area_id, area, area_shape, self_shape):
	if entered && area.name == "Mouse":
		#get_parent().layer = 1
		$animPlayer.play_backwards("anim")
		entered = false


func _on_button_pressed():
	if mode == "Cave":
		GLOBALS.cave = true
		GLOBALS.fast = false
	elif mode == "Fast":
		GLOBALS.fast = true
		GLOBALS.cave = false
	else:
		GLOBALS.fast = false
		GLOBALS.cave = false
	get_tree().change_scene(ScenePath)