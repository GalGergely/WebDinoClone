extends CharacterBody2D


const SPEED = 500.0
const JUMP_VELOCITY = -600.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var GRAVITY = ProjectSettings.get_setting("physics/2d/default_gravity")


func _physics_process(delta):
	velocity.y += GRAVITY * delta
	if is_on_floor():
		if not get_parent().game_running:
			$AnimatedSprite2D.play("default")
		else:
			#$RunCol.disabled = false
			if Input.is_action_pressed("ui_accept"):
				velocity.y = JUMP_VELOCITY
			elif Input.is_action_pressed("ui_down"):
				$AnimatedSprite2D.play("duck")
				$RunCol.disabled = true
			elif Input.is_action_pressed("move_right"):
				$AnimatedSprite2D.play("spring")
				velocity.x += 1
			elif Input.is_action_pressed("move_left"):
				$AnimatedSprite2D.play("default")
				velocity.x -= 1
			else:
				$AnimatedSprite2D.play("running")
				velocity.x = 0
	else:
		$AnimatedSprite2D.play("jump")
	position += velocity * delta
	position = position.clamp(Vector2.ZERO, get_viewport_rect().size)
	move_and_slide()
