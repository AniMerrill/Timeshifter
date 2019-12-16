extends Node2D

onready var level := preload("res://test.tscn")

onready var upgrade_store := preload("res://Screens/UpgradeStore.tscn")
onready var gameover := preload("res://Screens/GameOver.tscn")
onready var pause_scr := preload("res://Screens/Pause.tscn")
onready var level_ready = preload("res://Screens/LevelReady.tscn")

#onready var level_ready = preload("res://SFX/level_ready.wav")
onready var level_complete = preload("res://SFX/level_complete.wav")
onready var g_o_voice = preload("res://SFX/game_over.wav")

var gameplay = true

var cur_level = null

var level_number = 1

var damage_upgrades = 0
var shield_upgrades = 0
var extra_charges = 0

var score = 0

func _ready():
	start_new_game()

func _input(e : InputEvent) -> void:
	if e.is_action_pressed("pause") && gameplay:
		var scr = pause_scr.instance()
		
		if !has_node("Pause"):
			get_tree().paused = true
			add_child(scr)
		else:
			scr.queue_free()
	
	if e.is_action_pressed("fullscreen"):
		OS.window_fullscreen = !OS.window_fullscreen

func start_new_game():
	for child in get_children():
		if child.name != "BGM" && child.name != "SFX":
			child.queue_free()
	
	gameplay = false
	get_tree().paused = true
	
	$BGM.play()
	
	level_number = 1
	damage_upgrades = 0
	shield_upgrades = 0
	extra_charges = 0
	
	cur_level = level.instance()
	add_child(cur_level)
	
	var inst = level_ready.instance()
	inst.level_number = level_number
	add_child(inst)

func level_complete():
	gameplay = false
	
	var store = upgrade_store.instance()
	
	store.time_charges = int(cur_level.get_node("Player").health)
	
	add_child(store)
	get_tree().paused = true

func instance_next_level():
	for child in get_children():
		if child.name != "BGM" && child.name != "SFX":
			child.queue_free()
	
	level_number += 1
	
	cur_level = level.instance()
	
	cur_level.room_count += level_number * 2
	cur_level.damage_upgrades = damage_upgrades
	cur_level.shield_upgrades = shield_upgrades
	cur_level.extra_charges = extra_charges
	
	add_child(cur_level)
	
	var inst = level_ready.instance()
	inst.level_number = level_number
	add_child(inst)

func game_over():
	gameplay = false
	get_tree().paused = true
	$BGM.stop()
	
	var g_o = gameover.instance()
	
	add_child(g_o)
