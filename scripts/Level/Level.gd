extends Control

var contCancel = false

var spacePressed = false

var initPos = Vector2()
var endPosY

func _ready():
	initPos.x = $infoLayer/infoPanel.get_global_rect().position.x
	initPos.y = $infoLayer/infoPanel.get_global_rect().position.y
	endPosY = initPos.y + $infoLayer/infoPanel.get_global_rect().size.y
	
	if GLOBALS.cave:
		get_node("Light2D").visible = true
		get_node("Player/Light2D").visible = true
	else:
		get_node("Player/Light2D").visible = false
		get_node("Light2D").visible = false

func _unhandled_input(event):
	if event is InputEventMouseButton:
		if event.pressed and event.button_index == BUTTON_LEFT:
			var pos = Vector2()
			pos = (get_global_mouse_position() - get_node("Player").position)
			get_node("Player").move_and_collide(pos)
		elif event.pressed and event.button_index == BUTTON_RIGHT:
			get_tree().quit()

func _process(delta):
	if Input.is_action_just_pressed("ui_select") && not spacePressed:
		
		spacePressed = true
		
		$infoLayer/infoPanel/Tween.interpolate_property($infoLayer/infoPanel,
		"rect_position",
		Vector2(initPos.x, initPos.y),
		Vector2(initPos.x, endPosY),
		0.5, Tween.TRANS_BACK, Tween.EASE_OUT)
		
		$infoLayer/infoPanel/Tween.start()
	if Input.is_action_just_released("ui_select") && spacePressed:
		
		spacePressed = false
		
		$infoLayer/infoPanel/Tween.interpolate_property($infoLayer/infoPanel,
		"rect_position",
		Vector2(initPos.x, endPosY),
		Vector2(initPos.x, initPos.y),
		0.5, Tween.TRANS_BACK, Tween.EASE_IN)
		$infoLayer/infoPanel/Tween.start()
	if Input.is_action_pressed("ui_r") || Input.is_action_pressed("quit") || Input.is_action_pressed("ui_m"):
		contCancel = true
		if get_node("letter_countdown/timer").is_stopped(): get_node("letter_countdown/timer").start()
		if Input.is_action_pressed("quit"):
			get_node("letter_countdown/letterLabel").text = "Q"
		if Input.is_action_pressed("ui_r"):
			get_node("letter_countdown/letterLabel").text = "R"
		if Input.is_action_pressed("ui_m"):
			get_node("letter_countdown/letterLabel").text = "M"
		get_node("letter_countdown").visible = true
		while not get_node("letter_countdown/timer").is_stopped() && contCancel:
			get_node("letter_countdown/progressBar").value = (get_node("letter_countdown/timer").time_left / 1 * 100)
			yield(get_tree(), "idle_frame")
	
	if Input.is_action_just_released("ui_r") || Input.is_action_just_released("quit") || Input.is_action_just_released("ui_m"):
		contCancel = false
		get_node("letter_countdown/timer").stop()
		get_node("letter_countdown").visible = false

func _on_timer_timeout():
	if Input.is_action_pressed("ui_r"):
		get_tree().change_scene("res://scenes/Restart.tscn")
	if Input.is_action_pressed("quit"):
		get_tree().change_scene("res://scenes/ReleaseToQuit.tscn")
	if Input.is_action_pressed("ui_m"):
		get_node("closeAnim/animPlayer").play("close")
