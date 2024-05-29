extends CharacterBody2D


const SPEED = 350.0
const JUMP_VELOCITY = -1000.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var GRAVITY = ProjectSettings.get_setting("physics/2d/default_gravity")

func animation():
	if not get_parent().game_running and not get_parent().game_over:
		$AnimatedSprite2D.play("default")
	elif not get_parent().game_running and get_parent().game_over:
		$AnimatedSprite2D.play("dead")
		if $AnimatedSprite2D.frame == 2: $AnimatedSprite2D.pause()
	else:
		if !is_on_floor():
			$AnimatedSprite2D.play("jump")
		elif (velocity.x > 0):
			$AnimatedSprite2D.play("spring")
		elif (velocity.x < 0):
			$AnimatedSprite2D.play("default")
		elif (velocity.x < 1 and velocity.x > -1):
			$AnimatedSprite2D.play("running")
		
func _on_AnimatedSprite2D_animation_finished():
	if $AnimatedSprite2D.animation == "dead":
		$AnimatedSprite2D.stop()
			
func movement(delta):
		if get_parent().game_running:
			velocity.y += GRAVITY * delta
			if Input.is_action_pressed("jump") and is_on_floor():
				velocity.y = JUMP_VELOCITY
			if Input.is_action_pressed("move_right"):
				velocity.x = SPEED
			if Input.is_action_pressed("move_left"):
				velocity.x = -SPEED
			else:
				velocity.x = move_toward(velocity.x, 0, 25)
			move_and_slide()
			
		
func _physics_process(delta):
	animation()
	movement(delta)
