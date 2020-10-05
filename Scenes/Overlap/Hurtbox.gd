extends Area2D

signal attacked(damage);
signal stun

onready var HitEffect = preload("res://Scenes/Effects/HitEffect.tscn")
#onready var minotaur = preload ("res://Scenes/Enemies/Minotaur.tscn")
var stun = false;

func _ready():
	pass



func _on_Hurtbox_area_entered(area):
	emit_signal("attacked", area.damage);
	if(get_parent() == get_node("res://Scenes/Enemies/Minotaur.tscn")):
		get_parent().get_node("Songs/Hit")
	if(area.damage > 0):
		_create_hit_effect()


func _on_Hitbox_stunned():
	emit_signal("stun")

func _create_hit_effect():
	var effect = HitEffect.instance()
	var main = get_tree().current_scene
	main.add_child(effect)
	effect.global_position = global_position


func _on_AxeHitbox_area_entered(area):
	get_parent().random_hit_song()
