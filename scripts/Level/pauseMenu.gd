extends Control

onready var popup = get_node("../confDialog")
onready var popupTween = get_node("../confDialogTween")
onready var keyBindingAnim = get_node("../keyBinding/animPlayer")
onready var keyBindingLabel = get_node("../keyBinding/infoLabel")
onready var keyBindingTween = get_node("../keyBinding/Tween")
onready var keyBindingTimer = get_node("../keyBinding/Timer")

var quit = false
var initPos = Vector2()
var endPos = Vector2()

var initPosKeyBinding = Vector2()
var endPosKeyBinding = Vector2()

var keyBindingText

func _ready():
	set_process(true)
	keyBindingText = keyBindingLabel.text
	initPos = get_global_rect().position
	endPos.x = initPos.x + get_global_rect().size.x
	endPos.y = initPos.y
	initPosKeyBinding = keyBindingLabel.get("rect_position")
	endPosKeyBinding.x = initPosKeyBinding.x + keyBindingLabel.get("rect_size").x
	endPosKeyBinding.y = initPosKeyBinding.y

func _process(delta):
	if Input.is_action_just_pressed("ui_cancel"):
		if get_tree().paused:
			get_tree().paused = false
			Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
			$animPlayer.play_backwards("anim")
			
			if popup.visible: hidePopup()
			
			switchKeyBindingState(false)
			
			$Tween.interpolate_property(self, "rect_position", endPos, initPos, 0.5, Tween.TRANS_BACK, Tween.EASE_IN)
			$Tween.start()
			keyBindingTimer.start(5)

		else:
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
			switchKeyBindingState(true)
			
			$Tween.interpolate_property(self, "rect_position", initPos, endPos, 0.5, Tween.TRANS_BACK, Tween.EASE_OUT)
			$Tween.start()
			$animPlayer.play("anim")
			if not keyBindingLabel.visible:
				keyBindingAnim.play_backwards("blend")
			get_tree().paused = true

func switchKeyBindingState(var now_paused):
	if now_paused:
		keyBindingTween.interpolate_property(keyBindingLabel,
		"rect_position",
		endPosKeyBinding,
		initPosKeyBinding,
		1,
		Tween.TRANS_BACK,
		Tween.EASE_OUT)
		if not keyBindingLabel.visible:
			keyBindingTween.start()
			
		keyBindingLabel.text = "Esc: Continue"
	else:
		keyBindingLabel.text = keyBindingText
		keyBindingTween.interpolate_property(keyBindingLabel,
		"rect_position",
		initPosKeyBinding,
		endPosKeyBinding,
		1,
		Tween.TRANS_BACK,
		Tween.EASE_OUT)
		keyBindingTween.start()

func _on_btnContinue_pressed():
	get_tree().paused = false
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	
	$animPlayer.play_backwards("anim")
	
	if popup.visible: hidePopup()
	
	switchKeyBindingState(false)
	
	$Tween.interpolate_property(self, "rect_position", endPos, initPos, 0.5, Tween.TRANS_BACK, Tween.EASE_IN)
	$Tween.start()
	keyBindingTimer.start(5)

func _on_btnExit_pressed():
	quit = false
	popup.dialog_text = "Möchten sie wirklich zurück zum Hauptmenü?"
	showPopup()

func _on_btnQuit_pressed():
	quit = true
	popup.dialog_text = "Möchten sie das Spiel wirklich beenden?"
	showPopup()

func _on_ConfirmationDialog_confirmed():
	if quit:
		get_tree().quit()
	else:
		get_tree().paused = false
		get_tree().change_scene("res://scenes/Start.tscn")

#func _on_animPlayer_animation_finished(anim_name):
#	if not get_tree().paused: popup.visible = false

#func _on_confDialog_visibility_changed():
##	if not GLOBALS.closeConfirmation && popup.visible:
##		popup.visible = false
##		if quit:
##			get_tree().quit()
##		else:
##			get_tree().paused = false
##			get_tree().change_scene("res://scenes/Start.tscn")
#	pass

func showPopup():
	popup.show()
	popupTween.interpolate_property(popup, "rect_scale", popup.get("rect_scale"), Vector2(1, 1), 0.5, Tween.TRANS_BACK, Tween.EASE_OUT)
	popupTween.start()

func hidePopup():
	popupTween.interpolate_property(popup, "rect_scale", popup.get("rect_scale"), Vector2(0.1, 0.1), 0.5, Tween.TRANS_CUBIC, Tween.EASE_OUT)
	popupTween.start()

func _on_Tween_tween_completed(object, key):
	if not get_tree().paused: popup.visible = false
