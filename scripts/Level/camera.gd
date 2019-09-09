extends Camera2D

var tmpHealth1 = 100
var tmpHealth2 = 100

export var magnitude = 5.0
export var lifeTime = 0.2
var timeLeft = 1.0

var isShaking = false

func _ready():
	tmpHealth1 = GLOBALS.health1
	tmpHealth2 = GLOBALS.health2

func _physics_process(delta):
	if tmpHealth1 > GLOBALS.health1:
		if GLOBALS.health1 >= 0:
			shake(delta)
		tmpHealth1 = GLOBALS.health1
	else:
		tmpHealth1 = GLOBALS.health1

	if tmpHealth2 > GLOBALS.health2:
		if GLOBALS.health2 >= 0:
			shake(delta)
		tmpHealth2 = GLOBALS.health2
	else:
		tmpHealth2 = GLOBALS.health2

func shake(delta):
	timeLeft = lifeTime

	if isShaking: return
	isShaking = true

	while timeLeft > 0:
		position = Vector2(rand_range(-magnitude, magnitude), rand_range(-magnitude, magnitude))

		timeLeft -= delta
		yield(get_tree(), "idle_frame")
	
	timeLeft = lifeTime
	isShaking = false
	position = Vector2(0, 0)