extends Control

onready var tween = get_node("tween")
onready var camera = get_node("../camera")

const initColorScale = Vector2(0, 1080)
const endColorScale = Vector2(0, 0)


func _ready():
	$ColorRect/labelScore.text = "Score: " + String(GLOBALS.score)
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	$animPlayer.play("fade_in")


func _on_btnRestart_pressed():
	restart()
	
func _on_btnETMenu_pressed():
	tween.interpolate_property(camera, "position", initColorScale, endColorScale, 0.5, Tween.TRANS_EXPO, Tween.EASE_OUT)
	tween.start()
	switch()

func _on_tween_tween_all_completed():
	get_node("../Main/CanvasLayer/sideBoard/btnSettings").visible = true

# warning-ignore:return_value_discarded
func restart(): get_tree().change_scene("res://scenes/Level.tscn")

# warning-ignore:return_value_discarded
func exit(): get_tree().change_scene("res://scenes/Start.tscn")

func switch():
	get_node("../Main").visible = true
	get_node("../Main/title").visible = true
	get_node("../Main/ModeContainer/btnPlay").visible = true
	get_node("../Main/ModeContainer/btnPlayFast").visible = true
	get_node("../Main/ModeContainer/btnCave").visible = true
	get_node("../Splash").visible = false