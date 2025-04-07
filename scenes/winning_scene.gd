extends CanvasLayer

@onready var play_time_text = %PlayTimeText
@onready var money_made_text = %MoneyMadeText

func _ready() -> void:
	play_time_text.text = str(int(GameState.total_play_time_in_seconds)) + "s"
	money_made_text.text = "$" + str(GameState.total_money_collected + GameState.current_cargo_value)

func _on_play_again_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/main.tscn")
	SignalBus.new_game.emit()
