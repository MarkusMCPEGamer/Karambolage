extends Node

var enemy = preload("res://enemy/Enemy.tscn")

func _ready():
	yield(get_tree(), "idle_frame")
	spawn()
	yield(get_tree(), "idle_frame")
	spawn()
	yield(get_tree(), "idle_frame")
	spawn()
	yield(get_tree(), "idle_frame")
	spawn()


func _on_timer_timeout():
	spawn()

func spawn():
	get_node("container").add_child(enemy.instance())
	GLOBALS.enemys = GLOBALS.enemys + 1