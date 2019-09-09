extends Control

var initPos = Vector2()
var endPos = Vector2()

func _ready():
	initPos = get("rect_position")
	endPos = Vector2(0, 0)

func _on_Area2D_body_entered(body):
	if body.is_in_group("AnyPlayer"):
		$Tween.interpolate_property(self, "rect_position", initPos, endPos, 0.5, Tween.TRANS_EXPO, Tween.EASE_OUT)
		$Tween.start()

func _on_Area2D_body_exited(body):
	if body.is_in_group("AnyPlayer"):
		$Tween.interpolate_property(self, "rect_position", endPos, initPos, 0.5, Tween.TRANS_EXPO, Tween.EASE_OUT)
		$Tween.start()