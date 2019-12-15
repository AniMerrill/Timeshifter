extends CanvasLayer

var time_charges = -1

onready var damage = $MarginContainer/VBoxContainer/HBoxContainer/Damage
onready var shield = $MarginContainer/VBoxContainer/HBoxContainer/Shield
onready var next = $MarginContainer/VBoxContainer/HBoxContainer/Next

func _ready():
	$VOX.connect("finished", self, "vox_finished")
	
	damage.connect("pressed", self, "damage_upgrade")
	shield.connect("pressed", self, "shield_upgrade")
	next.connect("pressed", self, "go_to_next_level")
	
	update_store()
	
	damage.disabled = true
	shield.disabled = true
	next.disabled = true
	
	$VOX.play()

func vox_finished():
	update_store()
	
	next.disabled = false
	
	next.grab_focus()

func damage_upgrade():
	time_charges -= 25
	get_parent().damage_upgrades += 1
	update_store()

func shield_upgrade():
	time_charges -= 25
	get_parent().shield_upgrades += 1
	update_store()

func go_to_next_level():
	get_parent().extra_charges = time_charges
	get_parent().instance_next_level()

func update_store():
	if time_charges < 25:
		damage.disabled = true
		shield.disabled = true
	else:
		damage.disabled = false
		shield.disabled = false
	
	$MarginContainer/VBoxContainer/TimeCharges.text = str(time_charges)
