extends Control

export (int) var slotNumber

const health = 20

var itemCount = 1
var hasItem = false
var type

var textures = [
	load("res://textures/health.png"),
	load("res://textures/energy.png")
]

signal addEnergy

func _ready():
	if slotNumber == 1:
		type = "health"
		hasItem = true
		update_global_slot("health")
	else:
		remove_item()
	$number.text = String(itemCount)
	set_process(true)


func _process(delta):
	if Input.is_action_just_pressed(String(slotNumber)) && not type == null:
		if itemCount >= 1:
			remove_item()
			if type == "health":
				updateHealth()
			if type == "energy":
				updateEnergy()
		$number.text = String(itemCount)

func updateHealth():
	GLOBALS.health1 += health
	GLOBALS.health2 += health
	if GLOBALS.health1 > 100:
		GLOBALS.health1 = 100
	if GLOBALS.health2 > 100:
		GLOBALS.health2 = 100

func updateEnergy():
	get_tree().call_group("AnyPlayer", "addEnergy")

func item_collected():
	if hasItem:
		if GLOBALS.powerupType == type:
			if itemCount <= 0:
				$animPlayer.play("anim")
			add_item()
			$"container/textureRect/animPlayer".play("zoom")
			$number.text = String(itemCount)
	elif not hasItem:
		if slotNumber == 1:
			if GLOBALS.itemSlot2 == GLOBALS.powerupType:
				return
		if slotNumber == 2:
			if GLOBALS.itemSlot1 == "":
				return
			if GLOBALS.itemSlot1 == GLOBALS.powerupType:
				return
		type = GLOBALS.powerupType
		if itemCount <= 0:
			$animPlayer.play("anim")
		add_item()
		$"container/textureRect/animPlayer".play("zoom")
		$number.text = String(itemCount)
		if type == "health":
			updateHealth()
			$"container/item".texture = textures[0]
		elif type == "energy":
			$"container/item".texture = textures[1]
		update_global_slot(type)
	

func add_item():
	itemCount += 1
	hasItem = true


func remove_item():
	if itemCount >= 1:
		itemCount -= 1
	if itemCount <= 0:
		hasItem = false
		update_global_slot("")
		$animPlayer.play_backwards("anim")
		
func update_global_slot(var new_type):
	if slotNumber == 1:
		GLOBALS.itemSlot1 = new_type
	if slotNumber == 2:
		GLOBALS.itemSlot2 = new_type