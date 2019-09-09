extends Control

var pressed = false

func _on_Button_button_down():
	GLOBALS.cave = false
	get_tree().change_scene("res://scenes/Level.tscn")

func _ready():
	Engine.time_scale = 1
	GLOBALS.closeConfirmation = SETTINGS.get_setting("settings", "closeConf")
	set_process(true)
	$Splash/info/animPlayer.play("blend")
	if GLOBALS.splashDone:
		if not GLOBALS.health1 <= 0 && not GLOBALS.health2 <= 0:
			switch()
	if GLOBALS.health1 <= 0 || GLOBALS.health2 <= 0:
		$camera.position = Vector2(0, 1080)
		get_node("Main/CanvasLayer/sideBoard/btnSettings").visible = false
	else:
		$camera.position = Vector2(0, 0)
	resetGlobals()


func _unhandled_key_input(event):
	if event is InputEventKey:
		if event.pressed and event.scancode == KEY_ENTER:
			$animPlayer.play("switch")
			GLOBALS.splashDone = true
	if event.pressed && event.scancode == 32:
		GLOBALS.cave = false
		get_tree().change_scene("res://scenes/Level.tscn")
	if event.pressed and event.scancode == 81:
		if $btnQuit/Timer.is_stopped(): $btnQuit/Timer.start()
		$btnQuit/TextureProgress.visible = true
		pressed = true
	if not event.pressed and event.scancode == 81:
		$btnQuit/Timer.stop()
		$btnQuit/TextureProgress.visible = false
		pressed = false

func _process(delta):
	while pressed:
		$btnQuit/TextureProgress.value = (1 - $btnQuit/Timer.time_left / 0.5) * 100
		yield(get_tree(), "idle_frame")

func _on_btnCave_button_down():
	GLOBALS.cave = true
	get_tree().change_scene("res://scenes/Level.tscn")

func _on_btnQuit_pressed():
	get_tree().quit()

func _on_Timer_timeout():
	get_tree().change_scene("res://scenes/ReleaseToQuit.tscn")
	
func switch():
	$Main.visible = true
	$Main/title.visible = true
	$Main/ModeContainer/btnPlay.visible = true
	$Main/ModeContainer/btnPlayFast.visible = true
	$Main/ModeContainer/btnCave.visible = true
	$Splash.visible = false

func resetGlobals():
	GLOBALS.enemys = 0
	GLOBALS.health1 = 100
	GLOBALS.health2 = 100
	GLOBALS.endurance1 = 100
	GLOBALS.endurance2 = 100
	GLOBALS.players = 0