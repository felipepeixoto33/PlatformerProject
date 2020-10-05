extends Area2D

signal stunned

export(int) var damage = 1 setget set_damage
var parent = get_parent()
var stun = false;

func _ready():
	if get_parent().is_in_group("Enemy"):
		get_parent().connect("attacked", self, "set_damage", [damage]);

func set_damage(value):
	damage = value;


func _on_Giant_White_Kurnas_attack(damage):
	set_damage(damage);


func _on_Giant_White_Kurnas_stun():
	emit_signal("stunned")
	stun = true
