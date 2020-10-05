extends AnimatedSprite

func _ready():
	Hurtbox.connect("attacked", self, "_play")
	_play()



func _play():
	frame = 0
	play("HitEffect")
	yield(self, "animation_finished")
	queue_free()
