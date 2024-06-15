extends CanvasLayer

@onready var current_weapon = $VBoxContainer/HBoxContainer/CurrentWeapon
@onready var current_ammo = $VBoxContainer/HBoxContainer2/CurrentAmmo
@onready var current_weapon_stack = $VBoxContainer/HBoxContainer3/WeaponStack


func _on_weapons_manager_update_ammo(ammo):
	current_ammo.set_text(str(ammo[0]) + " / " + str(ammo[1]))

func _on_weapons_manager_update_weapon_stack(weapon_stack):
	current_weapon_stack.set_text("")
	for i in weapon_stack:
		current_weapon_stack.text += "\n"+i

func _on_weapons_manager_weapon_changed(weapon_name):
	current_weapon.set_text(weapon_name)
