extends Node3D

signal weapon_changed
signal update_ammo
signal update_weapon_stack

@onready var animation_player = get_node("%AnimationPlayer")

var current_weapon : WeaponResource = null
var weapon_stack : Array[String] = [] # array of weapons player has rn
var weapon_indicator = 0
var next_weapon: String
var weapon_list = {}

var debug_bullet = preload("res://scenes/bullet_debug.tscn")

@export var _weapon_resources: Array[WeaponResource]
@export var start_weapons: Array[String]

enum {NULL, HITSCAN, PROJECTILE}

func _ready():
	initialize(start_weapons)
	
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
		reload()

func initialize(_start_weapons: Array[String]):
	for weapon in _weapon_resources:
		weapon_list[weapon.weapon_name] = weapon
	
	for i in _start_weapons:
		weapon_stack.push_back(i)
	current_weapon = weapon_list[weapon_stack[0]]
	emit_signal("update_weapon_stack", weapon_stack)
	enter()
	
func enter():
	animation_player.queue(current_weapon.anim_activate)
	emit_signal("weapon_changed", current_weapon.weapon_name)
	emit_signal("update_ammo", [current_weapon.current_ammo, current_weapon.reserve_ammo])

func exit(_next_weapon: String):
	if _next_weapon != current_weapon.weapon_name:
		if animation_player.get_current_animation() != current_weapon.anim_deactivate:
			animation_player.play(current_weapon.anim_deactivate)
			next_weapon = _next_weapon

func change_weapon(weapon_name: String):
	current_weapon = weapon_list[weapon_name]
	next_weapon = ""
	enter()

func _on_animation_player_animation_finished(anim_name):
	if current_weapon.anim_deactivate == anim_name:
		change_weapon(next_weapon)
	
	if anim_name == current_weapon.anim_shoot && current_weapon.auto_fire:
		if Input.is_action_pressed("shoot"):
			shoot()

func shoot():
	if current_weapon.current_ammo != 0:
		if !animation_player.is_playing():
			animation_player.play(current_weapon.anim_shoot)
			current_weapon.current_ammo -= 1
			emit_signal("update_ammo", [current_weapon.current_ammo, current_weapon.reserve_ammo])
			
			var camera_collision = get_camera_collision()
			
			match current_weapon.Type:
				NULL:
					print("Weapon type not chosen")
				HITSCAN:
					hit_scan_collision(camera_collision)
				PROJECTILE:
					pass

func reload():
	if current_weapon.current_ammo == current_weapon.magazine:
		return
	elif !animation_player.is_playing():
		if current_weapon.reserve_ammo != 0:
			# anim reload
			var reload_amount = min(current_weapon.magazine - current_weapon.current_ammo, current_weapon.magazine, current_weapon.reserve_ammo)
			
			current_weapon.current_ammo += reload_amount 
			current_weapon.reserve_ammo -= reload_amount
			
			emit_signal("update_ammo", [current_weapon.current_ammo, current_weapon.reserve_ammo])
		else:
			pass
			#animation_player.play(current_weapon) out of ammo

func get_ray():
	var camera = get_viewport().get_camera_3d()
	var viewport = get_viewport().get_size()
	
	var ray_origin = camera.project_ray_origin(viewport/2)
	var ray_end = ray_origin + camera.project_ray_normal(viewport/2)*current_weapon.weapon_range
	return [ray_origin, ray_end]

func get_camera_collision() -> Vector3:
	var ray = get_ray()
	var ray_origin = ray[0]
	var ray_end = ray[1]
	
	var new_intersection = PhysicsRayQueryParameters3D.create(ray_origin, ray_end)
	var intersection = get_world_3d().direct_space_state.intersect_ray(new_intersection)
	
	if not intersection.is_empty():
		var col_point = intersection.position
		return col_point
	else:
		return ray_end

func hit_scan_collision(collision_point):
	var ray = get_ray()
	var ray_origin = ray[0]
	
	var bullet_direction = (collision_point - ray_origin).normalized()
	var new_intersection = PhysicsRayQueryParameters3D.create(ray_origin, collision_point+bullet_direction*2)
	
	var bullet_collision = get_world_3d().direct_space_state.intersect_ray(new_intersection)
	
	if bullet_collision:
		var hit_indicator = debug_bullet.instantiate()
		var world = get_tree().get_root().get_child(0)
		world.add_child(hit_indicator)
		hit_indicator.global_translate(bullet_collision.position)
		
		hit_scan_damage(bullet_collision.collider)
	
func hit_scan_damage(collider):
	if collider.is_in_group("Target") and collider.has_method("hit_successful"):
		collider.hit_successful(current_weapon.damage)

