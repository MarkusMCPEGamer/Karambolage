extends Label

func _on_Timer_timeout():
	$"../animPlayer".play("blend")