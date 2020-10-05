extends Control

onready var playerStats = get_parent().get_node("Stats")
onready var updateTween = $UpdateTween
onready var health_bar = $HealthOver
onready var health_bar_under = $HealthUnder

onready var max_health = playerStats.max_health
onready var health = max_health;

func _ready():
	print("UI Max health = " + str(max_health))
	health_bar.min_value = 0
	health_bar.max_value = self.max_health
	health_bar.value = self.health
	Stats.connect("health_changed", self, "set_health_bar")
	Stats.connect("max_health_changed", self, "set_max_health_bar")


func set_health_bar():
	health_bar.value = playerStats.health
	updateTween.interpolate_property(health_bar_under, "value", health_bar_under.value, health, 0.4, Tween.TRANS_SINE, Tween.EASE_IN_OUT)
	updateTween.start()

func set_max_health_bar(value):
	health_bar.max_value = value


func _on_Stats_max_health_changed(value):
	max_health = Stats.max_health
	print(max_health)


func _on_Stats_health_changed(damage):
	set_health_bar()
