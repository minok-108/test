extends Alien

# onreadies

@onready var n_camera_target: Node2D = $CameraTarget
@onready var n_animation: AnimationPlayer = $Animation
@onready var n_right_sword: Area2D = $RightSword
@onready var n_left_sword: Area2D = $LeftSword

# consts

const SPEED: float = 400
const JUMP_FORCE: float = -550
# slight shift of the camera towards the movement
const CAMERA_TARGET_SHIFT: float = 12

# vars

var hp: int = 7


func _process(delta: float) -> void:
	velocity.x = 0
	
	if !is_on_floor():
		velocity.y += GRAVITY * delta
	
	# if you fell into the abyss
	if position.y > DEAD_HEIGHT:
		G.emit_signal("player_died")
	
	# control
	if Input.is_action_pressed("right"):
		velocity.x = SPEED
		n_animated_sprite.flip_h = true
		n_camera_target.position = Vector2(CAMERA_TARGET_SHIFT, 0)
 	
	if Input.is_action_pressed("left"):
		velocity.x = -SPEED
		n_animated_sprite.flip_h = false
		n_camera_target.position = Vector2(-CAMERA_TARGET_SHIFT, 0)
		 
	if Input.is_action_pressed("jump") and is_on_floor():
		velocity.y = JUMP_FORCE
	
	if Input.is_action_just_pressed("attack"):
		attack()
	
	animation()
	move_and_slide()


#########
# siganls
#########


# take damage from the enemy
func take_damage() -> void:
	hp -= 1
	G.emit_signal("player_hp_changed", hp)
	n_animation.play("take_damage")
	
	if hp == 0:
		G.emit_signal("player_died")


# if hit the enemy
func _on_sword_body_entered(body: Node2D) -> void:
	if body.name.begins_with("Enemy"):
		body.take_damage()
