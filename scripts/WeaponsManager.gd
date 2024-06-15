extends Node3D

signal weapon_changed
signal update_ammo
signal update_weapon_stack

@onready var animation_player = get_node("%AnimationPlayer")

var current_weapon = null
var weapon_stack = [] # array of weapons player has rn
var weapon_indicator = 0
var next_weapon: String
var weapon_list = {}

@export var _weapon_resources: Array[WeaponResource]
@export var start_weapons: Array[String]

func _ready():
	Initialize(start_weapons)
	
func _input(event):
	if event.is_action_pressed("weapon_up"):
		weapon_indicator = min(weapon_indicator+1, weapon_stack.size()-1)
		exit(weapon_stack[weapon_indicator])
	
	if event.is_action_pressed("weapon_down"):
		weapon_indicator = max(weapon_indicator-1, 0)
		exit(weapon_stack[weapon_indicator])
	
	if event.is_action_pressed("shoot"):
		shoot()
		
	if event.is_action_pressed("reload"):
		shoot()

func Initialize(_start_weapons: Array[String]):
	for weapon in _weapon_resources:
		weapon_list[weapon.weapon_name] = weapon
	
	for i in _start_weapons:
		weapon_stack.push_back(i)
	current_weapon = weapon_list[weapon_stack[0]]
	enter()
	
func enter():
	animation_player.queue(current_weapon.anim_activate)

func exit(_next_weapon: String):
	if _next_weapon != current_weapon.weapon_name:
		if animation_player.get_current_animation() != current_weapon.anim_deactivate:
			animation_player.play(current_weapon.anim_deactivate)
			next_weapon = _next_weapon

func Change_Weapon(weapon_name: String):
	current_weapon = weapon_list[weapon_name]
	next_weapon = ""
	enter()

func _on_animation_player_animation_finished(anim_name):
	if current_weapon.anim_deactivate == anim_name:
		Change_Weapon(next_weapon)

func shoot():
	animation_player.play(current_weapon.anim_shoot)
	
func reload():
	pass
