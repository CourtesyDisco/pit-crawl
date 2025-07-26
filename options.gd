extends Node


func _on_back_button_pressed():
	get_tree().change_scene_to_file("res://mainmenu.tscn")
	MusicManager.play_sfx(load("res://audio/click.ogg"))
func _on_back_to_game_pressed():
	get_tree().change_scene_to_file("res://ClickerUI.tscn")
	MusicManager.play_sfx(load("res://audio/click.ogg"))

func _on_reset_pressed() -> void:
	$ResetConfirm.popup_centered()
	MusicManager.play_sfx(load("res://audio/click.ogg"))

func _on_reset_confirm_confirmed():
	MusicManager.play_sfx(load("res://audio/click.ogg"))
	if FileAccess.file_exists(Global.save_path):
		DirAccess.remove_absolute(Global.save_path)
	
	Global.authority = 0
	Global.authority_per_click = 1
	Global.upgrade_cost = 10
	Global.passive_income = 0
	Global.passive_upgrade_cost = 50
	Global.upgrade_1_level = 0
	Global.upgrade_2_cost = 100
	Global.upgrade_2_level = 0
	Global.upgrade_passive_level = 0
	Global.upgrade_cc_level = 1
	Global.upgrade_cc_cost = 100
	Global.upgrade_cm_level = 1
	Global.upgrade_cm_cost = 1000
	Global.lifetime_authority = 0
	Global.bloodline_strength = 0
	Global.bloodline_spent = 0
	
	Global.save_game()

	$ResetBackdrop.visible = true
	$ResetMessage.visible = true

	$ResetBackdrop.modulate = Color(0, 0, 0, 0)
	$ResetMessage.modulate = Color(1, 1, 1, 0)

	var tween = create_tween()
	tween.tween_property($ResetBackdrop, "modulate", Color(0, 0, 0, 1), 1.5)
	tween.tween_property($ResetMessage, "modulate", Color(1, 1, 1, 1), 1.5).set_delay(0.5)

	await get_tree().create_timer(7).timeout
	get_tree().change_scene_to_file("res://mainmenu.tscn")



#volume sliders
func _on_music_volume_slider_value_changed(value):
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Music"), value)

func _on_sfx_volume_slider_value_changed(value):
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("SFX"), value)
