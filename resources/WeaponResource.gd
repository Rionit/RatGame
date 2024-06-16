extends Resource
class_name WeaponResource

@export var weapon_name : String
@export var anim_activate : String
@export var anim_deactivate : String
@export var anim_shoot : String
#@export var anim_reload : String

@export var current_ammo : int
@export var reserve_ammo : int
@export var magazine : int
@export var max_ammo : int

@export var droppable : bool = true
@export var auto_fire : bool
@export_flags("HitScan", "Projectile") var Type
@export var weapon_range : int
@export var damage : int
@export var projectile_to_load: PackedScene
@export var projectile_velocity: int
