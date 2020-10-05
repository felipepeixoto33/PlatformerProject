extends KinematicBody2D

signal attack(damage)
signal killed

onready var sprite1 = $Sprite
onready var sprite2 = $Sprite2
onready var sprite3 = $Sprite3
onready var sprite4 = $Sprite4
onready var animationPlayer = $AnimationPlayer
onready var hitCollision = $Hitbox/CollisionShape2D

const UP = Vector2(0, -1)
const GRAVITY = 10
const ACCELERATION = 50
const MAX_SPEED = 200

var motion = Vector2()
var attacking = false
var flipped = false
var died = false;

func _ready():
	pass

func _physics_process(delta):
	var player = $PlayerDetectionZone.player
	motion.y += GRAVITY/10;
	change_direction()
	if(!died):
		if player != null:
			var distanceFromPlayer = player.position.x - position.x
			if distanceFromPlayer < 0:
				motion.x = max(motion.x - ACCELERATION, -MAX_SPEED)
				if(distanceFromPlayer > -90 && !attacking):
					move_and_slide(Vector2.ZERO, UP)
					attack()
			elif distanceFromPlayer > 0:
				motion.x = min(motion.x + ACCELERATION, MAX_SPEED)
				if(distanceFromPlayer < 75 && !attacking):
					move_and_slide(Vector2.ZERO, UP)
					attack()
			if(motion.x > 0 or motion.x < 0 && !attacking): 
				walk()
			
		move_and_slide(motion, UP)

func _on_Stats_no_health():
	dying()
	$Songs/Die.play()
	died = true
	emit_signal("killed")
	print("Emitted")
	queue_free()

func flip_sprites():
	if motion.x < 0:
		sprite1.flip_h = true
		sprite2.flip_h = true
		sprite3.flip_h = true
		sprite4.flip_h = true
		hitCollision.scale *= -1;
		
	else:
		sprite1.flip_h = false
		sprite2.flip_h = false
		sprite3.flip_h = false
		sprite4.flip_h = false
		hitCollision.scale *= -1;

func attack():
	sprite2.visible = true;
	sprite1.visible = false;
	sprite3.visible = false;
	animationPlayer.play("Attack")
	attacking = true;
	yield(animationPlayer, "animation_finished")
	attacking = false;
	emit_signal("attack", 5)

func walk():
	if(!attacking):
		sprite1.visible = false;
		sprite2.visible = false;
		sprite3.visible = true;
		sprite4.visible = false;
		animationPlayer.play("Walk")
		

func change_direction():
	if(motion.x < 0 && !flipped):
		self.scale.x *= -1;
		flipped = true;
	if(motion.x > 0 && flipped):
		self.scale.x *= -1;
		flipped = false;

func dying():
	$Hurtbox/CollisionShape2D.disabled = true
	hitCollision.disabled = true
	motion = (Vector2.ZERO)
	animationPlayer.play("Idle")
