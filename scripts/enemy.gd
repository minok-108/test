extends Alien

# onreadies

@onready var n_ray_cast_v: RayCast2D = $RayCastV
@onready var n_ray_cast_h_1: RayCast2D = $RayCastH1
@onready var n_ray_cast_h_2: RayCast2D = $RayCastH2
@onready var n_animation: AnimationPlayer = $Animation
@onready var n_attack_timer: Timer = $AttackTimer
@onready var n_label_animation: AnimationPlayer = $Label/Animation

# consts

const JUMP_FORCE: float = -600
# the distance at which the enemy will stop in front of the player to attack
const DISTANCE_TO_PLAYER = 120

# vars

var hp: int = 3
var speed: float = 200
var angry_speed: float = 300 # speed when enemy saw player
var direction: int = 1 # 1 - right, -1 - left

var is_angry: bool = false # did the enemy see the player
var died: bool = false # did the enemy die
var detected_player: Node2D = null # player node


# walks from edge to edge
func normal_behavior() -> void: # when player not detected
	if is_on_floor():
		if !n_ray_cast_v.is_colliding(): # if he sees a cliff
			direction *= -1
			n_ray_cast_v.position.x *= -1
			n_animated_sprite.flip_h = !n_animated_sprite.flip_h


# stalks the player
func angry_behavior() -> void: # when player detected
	var is_jump: bool = (
			!n_ray_cast_v.is_colliding()
			or n_ray_cast_h_1.is_colliding()
			or n_ray_cast_h_2.is_colliding()
		) and is_on_floor()
	
	# if the player is on the right
	if detected_player.position.x > position.x + DISTANCE_TO_PLAYER: 
		n_attack_timer.stop()
		direction = 1
		n_animated_sprite.flip_h = true
		if is_jump:
			velocity.y = JUMP_FORCE
	# if the player is on the left
	elif detected_player.position.x < position.x - DISTANCE_TO_PLAYER:
		n_attack_timer.stop()
		direction = -1
		n_animated_sprite.flip_h = false
		if is_jump:
			velocity.y = JUMP_FORCE
	# if the player is in range
	else:
		direction = 0
		if n_attack_timer.is_stopped():
			n_attack_timer.start() # time between beats


func _process(delta: float) -> void:
	if died:
		return
	
	velocity.x = speed * direction
	
	if !is_on_floor():
		velocity.y += GRAVITY * delta
	
	# if you fell into the abyss
	if position.y > DEAD_HEIGHT:
		queue_free()
	
	if is_angry:
		angry_behavior()
	else:
		normal_behavior()
	
	animation()
	move_and_slide()


func saw_player(body: Node2D) -> void:
	is_angry = true
	detected_player = body
	n_ray_cast_v.position.x = 0 # detect the break a little later
	speed = angry_speed
	n_label_animation.play("show_label")


func die() -> void:
	died = true
	
	n_animation.play("death")
	await n_animation.animation_finished
	
	queue_free()


#########
# signals
#########


# take damage from the player
func take_damage() -> void:
	if died: return
	
	hp -= 1
	n_animation.play("take_damage")
	
	if hp == 0: die()


# saw the player
func _on_area_detection_body_entered(body: Node2D) -> void:
	if is_angry == false and body.name == "Player":
		saw_player(body)


# if hit the player
func _on_sword_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		body.take_damage()


func _on_attack_timer_timeout() -> void:
	attack()
	n_attack_timer.stop()
