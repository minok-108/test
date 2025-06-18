extends CanvasLayer

# onreadies

@onready var n_animation: AnimationPlayer = $Animation
@onready var n_hps: Control = $HPs


func _ready() -> void:
	G.player_hp_changed.connect(player_hp_changed)
	G.player_died.connect(game_over)
	
	n_animation.play("show_screen")


func player_hp_changed(hp: int) -> void:
	var c = n_hps.get_children()
	for i in len(c):
		if i + 1 > hp:
			c[i].play("not_have_hp")


func game_over() -> void:
	get_tree().paused = true
	n_animation.play("show_game_over")


func _on_button_again_pressed() -> void:
	get_tree().paused = false
	get_tree().reload_current_scene()
