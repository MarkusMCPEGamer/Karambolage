extends ProgressBar

var currHealth = 100
var moved = false
var colorChanged = false

func _ready():
	set_process(true)
 
func _process(delta):
	if GLOBALS.health2 != currHealth:
		$Tween.interpolate_property(self, "value", currHealth, GLOBALS.health2, 0.5, Tween.TRANS_CIRC, Tween.EASE_OUT)
		$Tween.start()
		currHealth = GLOBALS.health2
	if GLOBALS.health2 <= 20 && not colorChanged:
		$AnimationPlayer.play("changeColor")
		colorChanged = true
	if GLOBALS.health2 > 20 && colorChanged:
		$AnimationPlayer.play_backwards("changeColor")
		colorChanged = false
	if GLOBALS.players >= 2 && not moved:
		visible = true
		move()
		moved = true

func move():
	var moveTween = $moveTween
	moveTween.interpolate_property(self, "rect_position", get("rect_position"), Vector2(990, get("rect_position").y), 0.5, Tween.TRANS_CIRC, Tween.EASE_OUT)
	moveTween.start()