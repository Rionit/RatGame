extends RigidBody3D

var weapon_name : String
var current_ammo : int
var reserve_ammo : int

@export var _weapon : WeaponResource

func _ready():
	weapon_name = _weapon.weapon_name
	current_ammo = _weapon.current_ammo
	reserve_ammo = _weapon.reserve_ammo
