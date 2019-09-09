extends KinematicBody2D

var collision_info
var move_direction = Vector2()

const slowSpeed = 250
const sprintSpeed = 500
var speed
var energy = 100

const hitDelay = 0.5

onready var playerNumber = get_node("playerNumber")
onready var enduranceTimer = $enduranceTimer

const speedEnduranceUp = 0.5 #Speed regenerating energy
const speedEnduranceDown = 2 #Speed using energy

var gameEnding = false

var LEFT = Input.is_action_pressed("ui_a")
var RIGHT = Input.is_action_pressed("ui_d")
var UP = Input.is_action_pressed("ui_w")
var DOWN = Input.is_action_pressed("ui_s")
var SHIFT

var moving = false

var first = true #true when first player

signal end_game

func _ready():
	if GLOBALS.players < 1:
		GLOBALS.players = GLOBALS.players + 1
		first = true
	else:
		GLOBALS.players += 1
		first = false
		position = Vector2(get_viewport_rect().size.x / 2, get_viewport_rect().size.y / 2)
		add_to_group("Player2")
		remove_from_group("Player1")
		playerNumber.text = "P2"
		playerNumber.visible = true
		
	if GLOBALS.cave:
		$torch.visible = true
	else:
		$torch.visible = false
	speed = slowSpeed


func _physics_process(delta):
	if GLOBALS.cave && not gameEnding:
		$Tween.interpolate_property($torch, "texture_scale", $torch.texture_scale, $torch.texture_scale + 0.15, 0.5, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
		$Tween.start()

	if first:
		LEFT = Input.is_action_pressed("ui_a")
		RIGHT = Input.is_action_pressed("ui_d")
		UP = Input.is_action_pressed("ui_w")
		DOWN = Input.is_action_pressed("ui_s")
		SHIFT = Input.is_action_pressed("ui_sprint")
	else:
		LEFT = Input.is_action_pressed("ui_left")
		RIGHT = Input.is_action_pressed("ui_right")
		UP = Input.is_action_pressed("ui_up")
		DOWN = Input.is_action_pressed("ui_down")
		SHIFT = Input.is_action_pressed("ui_second_sprint")


	move_direction.x = int(RIGHT) - int(LEFT)
	move_direction.y = int(DOWN) - int(UP)
	
	if LEFT || RIGHT || UP || DOWN:
		collision_info = move_and_collide(move_direction.normalized() * speed * delta)
		if not moving:
			moving = true
	else:
		if moving:
			moving = false


func _process(delta):
	if GLOBALS.players >= 2 && not playerNumber.visible && first:
		playerNumber.text = "P1"
		playerNumber.visible = true
	if SHIFT && moving && energy >= 10 && enduranceTimer.is_stopped():
		while SHIFT && energy > 0 && moving:
			if enduranceTimer.is_stopped():
				energy -= speedEnduranceDown
				enduranceTimer.start()
				speed = sprintSpeed
				$particles.emitting = true
			yield(get_tree(), "idle_frame")
	elif energy <= 0:
		speed = slowSpeed
		$particles.emitting = false
	if not SHIFT && energy <= 100 && enduranceTimer.is_stopped():
		energy += speedEnduranceUp
		enduranceTimer.start()
		speed = slowSpeed
		$particles.emitting = false

	if GLOBALS.enemysInCollision1 >= 1 && $timer.is_stopped() && first:
		dealDamage()
		$timer.start(hitDelay)
	if GLOBALS.enemysInCollision2 >= 1 && $timer.is_stopped() && not first:
		dealDamage()
		$timer.start(hitDelay)
	
	if GLOBALS.health1 <= 0 && not gameEnding:
		endGame()
	if GLOBALS.health2 <= 0 && not gameEnding:
		endGame()

	syncEnergy() #set th globals equal to the local variable

func _on_Tween_tween_completed(object, key):
	if $torch.texture_scale < 1 && first && GLOBALS.cave:
		get_tree().change_scene("res://scenes/Start.tscn")

func dealDamage():
	if first:
		GLOBALS.health1 -= 10
	else:
		GLOBALS.health2 -= 10

func endGame():
	gameEnding = true
	if first:
		emit_signal("end_game")
	if GLOBALS.cave:
		$Tween.interpolate_property($torch, "texture_scale", $torch.texture_scale, 0.01, 1, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
		$Tween.start()

func syncEnergy():
	if first:
		GLOBALS.endurance1 = energy
	else:
		GLOBALS.endurance2 = energy

func addEnergy():
	energy += 30
	if energy > 100:
		energy = 100
	if energy > 100:
		energy = 100
	syncEnergy()
