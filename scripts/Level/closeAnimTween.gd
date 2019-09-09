extends Tween

onready var rect = get_node("../rectUp")

func _on_Player_end_game():
	var initPos = Vector2(rect.get_global_rect().position.x, rect.get_global_rect().position.y)
	var endPos = Vector2(rect.get_global_rect().position.x, 0)
	if not GLOBALS.cave:
		interpolate_property(rect,
		"rect_position",
		initPos,
		endPos,
		1.5,
		Tween.TRANS_BOUNCE,
		Tween.EASE_OUT)
		start()

func _on_Tween_tween_completed(object, key):
	$"../waitBeforeQuit".start()

func _on_waitBeforeQuit_timeout():
	get_tree().change_scene("res://scenes/Start.tscn")