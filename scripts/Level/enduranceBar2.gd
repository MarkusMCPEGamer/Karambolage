extends ProgressBar

onready var timer = $regenerationTimer
var moved = false

var tmpEnergy
var shrinking = false

func _ready():
	tmpEnergy = GLOBALS.endurance2
	set_process(true)

func _process(delta):
	if GLOBALS.endurance2 != tmpEnergy:
		if GLOBALS.endurance2 < tmpEnergy:
			shrinking = true
		else: shrinking = false
		#value = tmpEnergy
		$Tween.interpolate_property(self, "value", value, GLOBALS.endurance2, 0.2, Tween.TRANS_LINEAR, Tween.EASE_OUT)
		$Tween.start()
	if GLOBALS.endurance2 < 100 && timer.is_stopped() && not shrinking:
		GLOBALS.endurance2 = GLOBALS.endurance2 + 1
		timer.start()
	if GLOBALS.players >= 2 && not moved:
		visible = true
		move()
		moved = true

func move():
	var moveTween = $moveTween
	moveTween.interpolate_property(self, "rect_position", get("rect_position"), Vector2(990, get("rect_position").y), 0.5, Tween.TRANS_CIRC, Tween.EASE_OUT)
	moveTween.start()