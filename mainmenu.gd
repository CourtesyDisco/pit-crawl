extends Control

func _ready():
	MusicManager.play_music(preload("res://audio/mainmenu.mp3"))

func _on_start_game_pressed():
	MusicManager.play_sfx(load("res://audio/click.ogg"))
	get_tree().change_scene_to_file("res://ClickerUI.tscn")
	

func _on_options_pressed():
	MusicManager.play_sfx(load("res://audio/click.ogg"))
	get_tree().change_scene_to_file("res://options.tscn")

func _on_quit_pressed():
	MusicManager.play_sfx(load("res://audio/click.ogg"))
	get_tree().quit()
