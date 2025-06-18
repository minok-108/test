extends CharacterBody2D
class_name Alien

# onreadies

@onready var n_animated_sprite: AnimatedSprite2D = $AnimatedSprite
@onready var n_food_dust: CPUParticles2D = $FoodDust
@onready var n_right_sword_animation: AnimationPlayer = $RightSword/Animation
@onready var n_left_sword_animation: AnimationPlayer = $LeftSword/Animation

# consts

const GRAVITY: float = 980
# the height at which the player and enemies die
const DEAD_HEIGHT: float = 3000.0


# animation of right or left attack
func attack() -> void:
	if n_animated_sprite.flip_h:
		n_right_sword_animation.play("hit")
	else:
		n_left_sword_animation.play("hit")


# animation of running, staying and jumping
func animation() -> void:
	if is_on_floor():
		if abs(velocity.x) > 0:
			n_food_dust.emitting = true
			n_animated_sprite.play("running")
		else:
			n_food_dust.emitting = false
			n_animated_sprite.play("staying")
	else:
		n_food_dust.emitting = false
		n_animated_sprite.play("jumping")
