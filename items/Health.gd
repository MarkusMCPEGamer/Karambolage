extends Node2D

#Currently not in use! Use Item.gd instead.

func _on_Area2D_body_entered(body):
	if body.is_in_group("AnyPlayer"):
		queue_free()

func _ready():
	position = GLOBALS.powerupPos