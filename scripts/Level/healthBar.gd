extends ProgressBar

var currHealth = 100
var moved = false
var colorChanged = false

func _ready():
	set_process(true)
 
func _process(delta):
	if GLOBALS.health1 != currHealth:
		$Tween.interpolate_property(self, "value", currHealth, GLOBALS.health1, 0.5, Tween.TRANS_CIRC, Tween.EASE_OUT)
		$Tween.start()
		currHealth = GLOBALS.health1
	if GLOBALS.health1 <= 20 && not colorChanged:
		$AnimationPlayer.play("changeColor")
		colorChanged = true
	if GLOBALS.health1 > 20 && colorChanged:
		$AnimationPlayer.play_backwards("changeColor")
		colorChanged = false
	if GLOBALS.players >= 2 && not moved:
		move()
		moved = true

func move():
	var moveTween = $moveTween
	moveTween.interpolate_property(self, "rect_position", get("rect_position"), Vector2(130, get("rect_position").y), 0.5, Tween.TRANS_CIRC, Tween.EASE_OUT)
	moveTween.start()