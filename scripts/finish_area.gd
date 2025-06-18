extends Area2D


@onready var n_animation: AnimationPlayer = $Animation


# if the player has reached the finish line
func _on_body_entered(_body: Node2D) -> void:
	n_animation.play("show_win_label")
