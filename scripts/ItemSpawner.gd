extends Position2D

export (PackedScene) var itemScene
var pos = Vector2()

var types = ["health", "energy"]

func _on_timer_timeout():
	$particles.emitting = false
	spawn()
	$particlesTimer.start()

func spawn():
	var item = itemScene.instance()
	item.type = types[rand_range(0, 2)]
	item.global_position = pos
	$container.add_child(item)

func _on_particlesTimer_timeout():
	randomize()
	pos = Vector2(rand_range(100, 1820), rand_range(100, 980))
	self.global_position = pos
	$particles.emitting = true
