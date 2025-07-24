# ClickerUI.gd
extends Control

#idle game numbers
var authority: int = 0
var authority_per_click: int = 1
var upgrade_cost: int = 10
var passive_income: int = 0
var passive_upgrade_cost: int = 50
var upgrade_1_level: int = 1
var upgrade_passive_level: int = 1
var upgrade_2_level = 1
var upgrade_2_cost = 100
var upgrade_cc_level = 1
var upgrade_cc_cost = 100
var upgrade_cm_level = 1
var upgrade_cm_cost = 100

#prestige stuff
var lifetime_authority: int = 0
var bloodline_points := 0
var bloodline_spent := 0

#crit stuff
var crit_chance := 0.05
var crit_multiplier := 3
var upgrade_crit_chance_level := 1
var upgrade_crit_multiplier_level := 1

#rumour.txt scroller on bottom of screen
var rumours = []
var current_rumour = 0
var typewriter_text = ""
var typewriter_index = 0

@onready var rumour_label = $RumourLabel
@onready var authority_label = $AuthorityLabel
@onready var get_authority = $GetAuthorityButton
@onready var upgrade_1 = $Upgrades/Upgrade1
@onready var upgrade_passive = $Upgrades/UpgradePassive
@onready var upgrade_2 = $Upgrades/Upgrade2
@onready var passive_timer = $PassiveTimer
@onready var passive_label = $PassiveLabel
@onready var upgrade_cc = $Upgrades/UpgradeCC
@onready var upgrade_cm = $Upgrades/UpgradeCM
@onready var prestige_button = $PrestigeButton
@onready var bloodline_label = $BloodlineLabel


#floating text for click popup
@onready var floating_text_scene = preload("res://FloatingText.tscn")

# allows passive income to work
func _on_passive_timer_timeout():
	if passive_income > 0:
		authority += passive_income
		lifetime_authority += passive_income
		update_ui()
		update_global_state()
	
	#loads save game
func _ready():
	MusicManager.play_music(preload("res://Audio/gamebgm.wav"))
	Global.load_game()
	authority = Global.authority
	authority_per_click = Global.authority_per_click
	upgrade_cost = Global.upgrade_cost
	passive_income = Global.passive_income
	passive_upgrade_cost = Global.passive_upgrade_cost
	upgrade_1_level = Global.upgrade_1_level
	upgrade_passive_level = Global.upgrade_passive_level
	upgrade_2_level = Global.upgrade_2_level
	upgrade_2_cost = Global.upgrade_2_cost
	lifetime_authority = Global.lifetime_authority
	bloodline_points = Global.bloodline_points
	bloodline_spent = Global.bloodline_spent
	load_rumours()
	cycle_rumour()
	$RumourTimer.start()
	update_ui()

#runs rumours at bottom of screen
func load_rumours():
	if not FileAccess.file_exists("res://rumours.txt"):
		push_warning("rumours.txt not found!")
		return
	var file = FileAccess.open("res://rumours.txt", FileAccess.READ)
	while file.get_position() < file.get_length():
		var line = file.get_line()
		if line.strip_edges() != "":
			rumours.append(line.strip_edges())
	file.close()
func cycle_rumour():
	if rumours.size() > 0:
		current_rumour = (current_rumour + 1) % rumours.size()
		typewriter_text = rumours[current_rumour]
		typewriter_index = 0
		rumour_label.text = ""
		$TypewriterTimer.start()
#makes rumours appear gradually
func _on_typewriter_timer_timeout():
	if typewriter_index < typewriter_text.length():
		rumour_label.text += typewriter_text[typewriter_index]
		typewriter_index += 1
	else:
		$TypewriterTimer.stop()
	
#increments based on click dps
func _on_get_authority_pressed():
	MusicManager.play_sfx(load("res://audio/authorityclick.wav"))
	var gain = authority_per_click
	var crit = false

	if randf() < crit_chance:
		gain *= crit_multiplier
		crit = true

	authority += gain
	lifetime_authority += gain
	show_floating_text("+%d" % gain, crit)
	update_ui()
	update_global_state()
	
	#upgrade 1
func _on_upgrade1_pressed():
	MusicManager.play_sfx(load("res://audio/click.ogg"))
	if authority >= upgrade_cost:
		authority -= upgrade_cost
		authority_per_click += 1
		upgrade_cost *= 1.5
		upgrade_1_level += 1
		update_ui()
		update_global_state()

#passive upgrade
func _on_upgrade_passive_pressed():
	MusicManager.play_sfx(load("res://audio/click.ogg"))
	if authority >= passive_upgrade_cost:
		authority -= passive_upgrade_cost
		passive_income += 3
		passive_upgrade_cost *= 1.5
		upgrade_passive_level += 1
		update_ui()
		update_global_state()
		
#floating text script
func show_floating_text(amount_text: String, is_crit: bool):
	var text = floating_text_scene.instantiate()
	text.text = amount_text 
	text.position = get_viewport().get_mouse_position()

	if is_crit:
		text.modulate = Color(1, 0.4, 0.2) 
		text.scale = Vector2(1.3, 1.3)

	add_child(text)


#makes sure everything updates when it needs to. Call in every function that updates something that needs done.
func update_ui():
	authority_label.text = "Absolute Authority: %d" % authority
	upgrade_1.text = "Tighten Grip (Improve Clicks) – Lv. %d (Cost: %d)" % [upgrade_1_level, upgrade_cost]
	upgrade_passive.text = "Hire Enforcers (Improve Idle Income) – Lv. %d (Cost: %d)" % [upgrade_passive_level, passive_upgrade_cost]
	passive_label.text = "Passive Authority: +%d/sec" % passive_income
	passive_label.visible = passive_income > 0
	passive_bar.visible = passive_income > 0
	if upgrade_1_level >= 10:
		upgrade_2.visible = true
		upgrade_2.text = "Imperial Effigy (Improve both Clicks and Idle Income) – Lv. %d (Cost: %d)" % [upgrade_2_level, upgrade_2_cost]
	else:
		upgrade_2.visible = false
	if upgrade_2_level >= 5:
		upgrade_cc.visible = true
		upgrade_cc.text = "Keen Eyes (Improve Crit Chance) - Lv. %d (Cost: %d)" % [upgrade_cc_level, upgrade_cc_cost]
	else:
		upgrade_cc.visible = false
	if upgrade_cc_level >= 2:
		upgrade_cm.visible = true
		upgrade_cm.text = "Brutality (Improve Crit Multiplier) - Lv. %d (Cost: %d)" % [upgrade_cm_level, upgrade_cm_cost]
	else:
		upgrade_cm.visible = false
	$PrestigeButton.visible = Global.lifetime_authority >= 10000
	bloodline_label.text = "bloodline Points: %d" % bloodline_points
	$BloodlineLabel.visible = Global.bloodline_points >= 1

#idle timer thing
@onready var passive_bar = $PassiveBar
func _process(_delta):
	if passive_income > 0:
		var elapsed = passive_timer.time_left
		passive_bar.value = passive_bar.max_value - elapsed
	else:
		passive_bar.value = 0
		
		
		
#goes back to menu
func _on_back_button_pressed():
	MusicManager.play_sfx(load("res://audio/click.ogg"))
	get_tree().change_scene_to_file("res://mainmenu.tscn")
	
	
#makes sure when you leave screen it saves. Also just saves regularly.
func update_global_state():
	Global.authority = authority
	Global.authority_per_click = authority_per_click
	Global.upgrade_cost = upgrade_cost
	Global.passive_income = passive_income
	Global.passive_upgrade_cost = passive_upgrade_cost
	Global.upgrade_1_level = upgrade_1_level
	Global.upgrade_passive_level = upgrade_passive_level
	Global.upgrade_2_level = upgrade_2_level
	Global.upgrade_2_cost = upgrade_2_cost
	Global.upgrade_cc_cost = upgrade_cc_cost
	Global.upgrade_cc_level = upgrade_cc_level
	Global.upgrade_cm_cost = upgrade_cm_cost
	Global.upgrade_cm_level = upgrade_cm_level
	Global.lifetime_authority = lifetime_authority
	Global.bloodline_points = bloodline_points
	Global.bloodline_spent = bloodline_spent
	Global.save_game()

#upgrades both active and passive
func _on_upgrade_2_pressed() -> void:
	MusicManager.play_sfx(load("res://audio/click.ogg"))
	if authority >= upgrade_2_cost:
		authority -= upgrade_2_cost
		upgrade_2_level += 1
		authority_per_click += 5
		passive_income += 5
		upgrade_2_cost = int(upgrade_2_cost * 1.8)
		update_ui()
		update_global_state()
		
		

#crit chance upgrade
func _on_upgrade_cc_pressed() -> void:
	MusicManager.play_sfx(load("res://audio/click.ogg"))
	if authority >= upgrade_cc_cost:
		authority -= upgrade_cc_cost
		crit_chance += 0.03 #+3% per
		upgrade_cc_level += 1
		upgrade_cc_cost = int(upgrade_cc_cost * 10)
		update_ui()
		update_global_state()


#crit multiplier upgrade
func _on_upgrade_cm_pressed() -> void:
	MusicManager.play_sfx(load("res://audio/click.ogg"))
	if authority >= upgrade_cm_cost:
		authority -= upgrade_cm_cost
		crit_multiplier += 1
		upgrade_cm_level += 1
		upgrade_cm_cost = int(upgrade_cm_cost * 10)
		update_ui()
		update_global_state()
		
		
#Prestige logic
func can_prestige() -> bool:
	return lifetime_authority >= 10000 # requires this much lifetime authority to prestige.

func calculate_bloodline_points() -> int:
	return int(lifetime_authority / 10000)  # 1 bloodline per 10k lifetime
	
	
func _on_prestige_button_pressed():
	MusicManager.play_sfx(load("res://audio/click.ogg"))
	if not can_prestige():
		print("Not enough lifetime authority to prestige.")
		return
	$PrestigeConfirm.popup_centered()
func _on_prestige_confirm_confirmed():
	MusicManager.play_sfx(load("res://audio/click.ogg"))
	var gained = calculate_bloodline_points()
	Global.bloodline_points += gained
	bloodline_points = Global.bloodline_points
	Global.lifetime_authority = 0
	Global.bloodline_spent = 0

	# Reset everything that's not prestige stuff
	Global.authority = 0
	Global.authority_per_click = 1
	Global.passive_income = 0
	Global.passive_upgrade_cost = 50
	Global.upgrade_1_level = 1
	Global.upgrade_cost = 10
	Global.upgrade_passive_level = 1
	Global.upgrade_2_level = 1
	Global.upgrade_2_cost = 100
	Global.upgrade_cc_level = 1
	Global.upgrade_cc_cost = 100
	Global.upgrade_cm_level = 1
	Global.upgrade_cm_cost = 1000
		# Reset local values too
	authority = 0
	authority_per_click = 1
	passive_income = 0
	passive_upgrade_cost = 50
	upgrade_1_level = 1
	upgrade_cost = 10
	upgrade_passive_level = 1
	upgrade_2_level = 1
	upgrade_2_cost = 100
	upgrade_cc_level = 1
	upgrade_cc_cost = 100
	upgrade_cm_level = 1
	upgrade_cm_cost = 1000
	Global.save_game()
	get_tree().reload_current_scene()
