extends KinematicBody2D

onready var animationPlayer = $AnimationPlayer
onready var attackDelay = $attackDelay

const UP = Vector2(0, -1)
const GRAVITY = 20
const ACCELERATION = 50
const MAX_SPEED = 300
const JUMP_HEIGHT = -550

var motion = Vector2()
var isAttacking = false;
var contAttack = 0;
var attackCompleted = true;

func _physics_process(delta):
	motion.y += GRAVITY
	var friction = false
	
	if Input.is_action_just_pressed("Attack") && contAttack == 0 && attackCompleted:
		isAttacking = true
		attackCompleted = false;
		animationPlayer.play("Attack1");
		contAttack = 1;
		yield(animationPlayer, "animation_finished")
		attackDelay.start()
		attackCompleted = true;
		isAttacking = false
	
	if(Input.is_action_just_pressed("Attack") && contAttack == 1 && attackCompleted):
		isAttacking = true
		attackCompleted = false;
		animationPlayer.play("Attack2")
		contAttack = 2
		yield(animationPlayer, "animation_finished")
		attackDelay.start(1)
		attackCompleted = true;
		isAttacking = false
		
	if(Input.is_action_just_pressed("Attack") && contAttack == 2 && attackCompleted):
		isAttacking = true
		attackCompleted = false;
		animationPlayer.play("Attack3")
		contAttack = 0
		yield(animationPlayer, "animation_finished")
		attackCompleted = true;
		isAttacking = false
	
	
	elif Input.is_action_pressed("moveLeft"):
		motion.x = max(motion.x - ACCELERATION, -MAX_SPEED);
		$Sprite.flip_h = true;
		if !isAttacking:
			animationPlayer.play("Run");
	elif Input.is_action_pressed("moveRight"):
		motion.x += ACCELERATION
		motion.x = min(motion.x + ACCELERATION, MAX_SPEED);
		$Sprite.flip_h = false;
		if !isAttacking:
			animationPlayer.play("Run");
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
			animationPlayer.play("Fall")
		if friction == true:
			motion.x = lerp(motion.x, 0, 0.05)
	motion = move_and_slide(motion, UP)
	

func _on_Stats_no_health():
	queue_free()


func _on_attackDelay_timeout():
	contAttack = 0;
