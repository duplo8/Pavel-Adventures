extends Control

func _on_replay_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/_debug/movement_test.tscn") # Replace with function body.

func _on_mainmenu_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/main.tscn")
