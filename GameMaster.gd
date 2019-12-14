extends Node2D

onready var level := preload("res://test.tscn")
onready var upgrade_store := preload("res://UpgradeStore.tscn")
onready var gameover := preload("res://GameOver.tscn")

var gameplay = true

var level_number = 1

var damage_upgrades = 0
var shield_upgrades = 0
var extra_charges = 0

func _ready():
	start_new_game()

func _input(e : InputEvent) -> void:
	if e.is_action_pressed("pause") && gameplay:
		get_tree().paused = !get_tree().paused

func start_new_game():
	for child in get_children():
		child.queue_free()
	
	gameplay = true
	get_tree().paused = false
	
	level_number = 1
	damage_upgrades = 0
	shield_upgrades = 0
	extra_charges = 0
	
	var new_level = level.instance()
	add_child(new_level)

func level_complete():
	gameplay = false
	extra_charges = 0
	
	var store = upgrade_store.instance()
	
	store.time_charges = int(get_child(0).get_node("Player").health)
	
	add_child(store)
	get_tree().paused = true

func instance_next_level():
	for child in get_children():
		child.queue_free()
	
	level_number += 1
	
	var new_level = level.instance()
	
	new_level.room_count += level_number * 2
	new_level.damage_upgrades = damage_upgrades
	new_level.shield_upgrades = shield_upgrades
	new_level.extra_charges = extra_charges
	
	add_child(new_level)
	
	get_tree().paused = false
	gameplay = true

func game_over():
	gameplay = false
	get_tree().paused = true
	
	var g_o = gameover.instance()
	
	add_child(g_o)
