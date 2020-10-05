extends KinematicBody2D

onready var animationPlayer = $AnimationPlayer
onready var attackDelay = $attackDelay
onready var healthUI = $HealthUI
onready var axeHitbox = $AxeHitbox

const UP = Vector2(0, -1)
const GRAVITY = 20
const ACCELERATION = 50
const MAX_SPEED = 200
const MAX_SPEED_RUNNING = 300
const JUMP_HEIGHT = -450

var motion = Vector2()
var isAttacking = false;
var contAttack = 0;
var attackCompleted = true;
var stunned = false;
var flipped = false;
var walkingLeft = false;
var walkingRight = false;
var running = false;
var beingHitted = false;

func _physics_process(delta):
	
#	if !is_on_floor():
#		motion.y += GRAVITY
	
	motion.y += GRAVITY
	
	var friction = false
	
	change_direction()
	
	if !stunned:
		if Input.is_action_just_pressed("Attack") && contAttack == 0 && attackCompleted:
			attack()
		
		if(Input.is_action_just_pressed("Attack") && contAttack == 1 && attackCompleted):
			attack2()
		
		elif Input.is_action_pressed("moveLeft"):
			walkingLeft = true;
			motion.x = max(motion.x - ACCELERATION, -MAX_SPEED);
			if !isAttacking:
				if Input.is_action_pressed("Run") && walkingLeft:
					animationPlayer.play("Run")
					running = true
					motion.x = max(motion.x - ACCELERATION, -MAX_SPEED_RUNNING);
				if !running:
					animationPlayer.play("Walk");
		elif Input.is_action_pressed("moveRight"):
			walkingRight = true;
			motion.x = min(motion.x + ACCELERATION, MAX_SPEED);
			if !isAttacking:
				if Input.is_action_pressed("Run") && walkingRight:
					animationPlayer.play("Run")
					running = true
					motion.x = min(motion.x + ACCELERATION, MAX_SPEED_RUNNING);
				if !running:
					animationPlayer.play("Walk");
		else:
			if(!isAttacking):
				animationPlayer.play("Idle", 0, 0.5);
			friction = true
			motion.x = lerp(motion.x, 0, 0.2);
		if is_on_floor():
			if Input.is_action_just_pressed("jump"):
				motion.y = JUMP_HEIGHT
			if friction:
				motion.x = lerp(motion.x, 0, 0.2);
		elif(!is_on_floor() && !isAttacking):
			if motion.y < 0:
				animationPlayer.play("Jump");
			else:
				animationPlayer.play("Fall", 0, 0.5)
			if friction == true:
				motion.x = lerp(motion.x, 0, 0.05)
		motion = move_and_slide(motion, UP)
		
		if Input.is_action_just_released("Run"):
			running = false
	else:
		motion = move_and_slide(Vector2.ZERO, UP)

func _on_Stats_no_health():
	stunned = true
	animationPlayer.play("Die")
	yield(animationPlayer, "animation_finished")
	queue_free()


func _on_attackDelay_timeout():
	contAttack = 0;


func attack():
	isAttacking = true
	attackCompleted = false;
	animationPlayer.play("Attack1");
	contAttack = 1;
	yield(animationPlayer, "animation_finished")
	attackDelay.start()
	attackCompleted = true;
	isAttacking = false


func attack2():
	isAttacking = true
	attackCompleted = false;
	animationPlayer.play("Attack2")
	contAttack = 0
	yield(animationPlayer, "animation_finished")
	attackDelay.start(1)
	attackCompleted = true;
	isAttacking = false


func stun(): 
	if !stunned:
		stunned = true
		animationPlayer.play("Stunned");
		yield(animationPlayer, "animation_finished")
		animationPlayer.play("Stand Up")
		stunned = false


#func _on_Stats_health_changed():
#	if(!isAttacking):
#		beingHitted = true
##		animationPlayer.play("Hit")
#		beingHitted = false


func _on_Hurtbox_stun():
	stun()
	print("Stunned")

func change_direction():
	if(motion.x < 0 && !flipped):
		self.scale.x *= -1
		flipped = true;
	if(motion.x > 0 && flipped):
		self.scale.x *= -1
		flipped = false;

func random_hit_song():
	randomize()
	var random = randi()%4+1
	if(random == 1):
		$Songs/AxeHit1.play()
	elif(random == 2):
		$Songs/AxeHit2.play()
	elif(random == 3):
		$Songs/AxeHit3.play()
	elif(random == 4):
		$Songs/AxeHit4.play()


#Inicializar classe:

#class Something:
#	var a = 10
#
#
## Constructor
#
#func _init():
#	print("Constructed!")
#	var lv = Something.new()
#	print(lv.a)

#Declare isso em algum método para chamar a classe:

#	var a = Something.new()
#	a.init_ref()
