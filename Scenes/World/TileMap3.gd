extends TileMap
var minosKilled = 0;

onready var minotaur = preload("res://Scenes/Enemies/Minotaur.gd");

func _ready():
	minotaur.connect("killed", self, "_mino_killed")


func _mino_killed():
	print("Connected")
	minosKilled+= 1
	if(minosKilled == 3):
		self.set_collision_layer_bit(0, false)

func _on_Minotaur_killed():
	minosKilled+=1;
	if(minosKilled == 3):
		self.set_collision_layer_bit(0, false)
