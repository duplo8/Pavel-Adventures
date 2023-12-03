extends Node

#1- gets called to check if a magic is off cooldown
#2- gets called to cast magic
#3- passes to casting state all needed variables, including the state from which it casted

@onready var player = $"../../.."
@onready var father = player.get_parent()
@onready var level = player.level	#needs fixing for magic to work without player dad


@export var magic_orb: Resource  = preload("res://scenes/game/characters/player/magic/magic_orb/magic_orb.tscn")
@export var magic_orb_cast_duration: float = 0.3	 #seconds
var magic_orb_is_on_cooldown: bool = false

@export var dark_sphere: Resource = preload("res://scenes/game/characters/player/magic/dark_sphere/dark_sphere.tscn")
@export var dark_sphere_cast_duration: float = 0.7 #seconds
var dark_sphere_is_on_cooldown: bool = false

var cast_duration: float = 0.0

func cast(magic: String, state: State) -> void:
	match magic:
		"magic_orb":
			cast_magic_orb()
		"dark_sphere":
			cast_dark_sphere()

func cast_magic_orb() -> void:
	cast_duration = magic_orb_cast_duration
	father.add_child(magic_orb.instantiate())
	var casted_orb = father.get_node("magic_orb")
	casted_orb.position = player.position
	casted_orb.is_facing_right = player.is_facing_right
	if player.is_facing_right:
		casted_orb.position = player.position 	+ Vector2(30, 0)	#offset
	else:
		casted_orb.position = player.position 	+ Vector2(-30, 0) #offset
	casted_orb.set_process(true)	#activate the magic script
	
	$magic_orb_cooldown.start()
	magic_orb_is_on_cooldown = true

func cast_dark_sphere() -> void:
	cast_duration = dark_sphere_cast_duration
	
	father.add_child(dark_sphere.instantiate())	
	var casted_sphere = father.get_node("dark_sphere")
	#set magic position & facing
	casted_sphere.is_facing_right = player.is_facing_right
	if player.is_facing_right:
		casted_sphere.position = player.position 	+ Vector2(30, -10)	#offset
	else:
		casted_sphere.position = player.position 	+ Vector2(-30, -10) #offset
	casted_sphere.set_process(true)	#activate the magic scrip
	
	$dark_sphere_cooldown.start()
	dark_sphere_is_on_cooldown = true

func _on_dark_sphere_cooldown_timeout() -> void:
	print("dark sphere off cooldown")
	dark_sphere_is_on_cooldown = false

func _on_magic_orb_cooldown_timeout() -> void:
	print("magic orb off cooldown")
	magic_orb_is_on_cooldown = false
