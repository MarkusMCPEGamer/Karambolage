extends Label

var timeSurvived = 0

func _on_Timer_timeout():
	timeSurvived = timeSurvived + 1
	text = String(timeSurvived)
	GLOBALS.score = timeSurvived
	
		#get_node("../Player/Light2D").texture_scale += 0.1
