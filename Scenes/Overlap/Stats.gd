extends Node

signal no_health
signal health_changed(value)
signal max_health_changed(value)

onready var hurtbox = $"/root/Hurtbox"

export(int) var max_health = 1 setget set_max_health
onready var health = max_health;


func change_health(value):
	health -= value;
	emit_signal("health_changed", value)
	print("changed health " + str(health))
	if health <= 0:
		emit_signal("no_health")


func _on_Hurtbox_attacked(damage):
	if get_parent().is_in_group("Player"):
		get_parent().get_node("AnimationPlayer").play("Hit")
	change_health(damage)

func set_max_health(value):
	emit_signal("max_health_changed", value)
	max_health = value

