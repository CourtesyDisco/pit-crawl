
extends Node

#income vars
var authority = 0
var authority_per_click = 1
var passive_income = 0

#upgrade vars
var passive_upgrade_cost = 50
var upgrade_1_level = 1
var upgrade_cost = 10
var upgrade_passive_level = 1
var upgrade_2_level = 1
var upgrade_2_cost = 100
var upgrade_cc_level = 1
var upgrade_cc_cost = 100
var upgrade_cm_level = 1
var upgrade_cm_cost = 100

#prestige vars
var lifetime_authority: int = 0
var bloodline_points := 0
var bloodline_spent := 0




var save_path := "user://save_game.dat"

func save_game():
	var save_data = {
		"authority": authority,
		"authority_per_click": authority_per_click,
		"upgrade_cost": upgrade_cost,
		"passive_income": passive_income,
		"passive_upgrade_cost": passive_upgrade_cost,
		"upgrade_1_level": upgrade_1_level,
		"upgrade_passive_level": upgrade_passive_level,
		"upgrade_2_level": upgrade_2_level,
		"upgrade_2_cost": upgrade_2_cost,
		"upgrade_cc_level": upgrade_cc_level,
		"upgrade_cc_cost": upgrade_cc_cost,
		"upgrade_cm_level": upgrade_cm_level,
		"upgrade_cm_cost": upgrade_cm_cost,
		"lifetime_authority": lifetime_authority,
		"bloodline_points": bloodline_points,
		"bloodline_spent": bloodline_spent,
	}

	var file = FileAccess.open(save_path, FileAccess.WRITE)
	file.store_var(save_data)
	file.close()
	print("Game saved!")

func load_game():
	if FileAccess.file_exists(save_path):
		var file = FileAccess.open(save_path, FileAccess.READ)
		var save_data = file.get_var()
		file.close()

		authority = save_data.get("authority", 0)
		authority_per_click = save_data.get("authority_per_click", 1)
		upgrade_cost = save_data.get("upgrade_cost", 10)
		passive_income = save_data.get("passive_income", 0)
		passive_upgrade_cost = save_data.get("passive_upgrade_cost", 50)
		upgrade_1_level = save_data.get("upgrade_1_level", 1)
		upgrade_passive_level = save_data.get("upgrade_passive_level", 1)
		upgrade_2_level = save_data.get("upgrade_2_level", 1)
		upgrade_2_cost = save_data.get("upgrade_2_cost", 100)
		upgrade_cc_level = save_data.get("upgrade_cc_level", 1)
		upgrade_cc_cost = save_data.get("upgrade_cc_cost", 1000)
		upgrade_cm_level = save_data.get("upgrade_cm_level", 1)
		upgrade_cm_cost = save_data.get("upgrade_cm_cost", 1000)
		lifetime_authority = save_data.get("lifetime_authority", 0)
		bloodline_points = save_data.get("bloodline_points", 0)
		bloodline_spent = save_data.get("bloodline_spent", 0)

		print("Game loaded!")
	else:
		print("No save file found.")
