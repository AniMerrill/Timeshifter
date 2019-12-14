extends CanvasLayer

var time_charges = -1

onready var damage = $MarginContainer/PanelContainer/VBoxContainer/HBoxContainer/Damage
onready var shield = $MarginContainer/PanelContainer/VBoxContainer/HBoxContainer/Shield
onready var next = $MarginContainer/PanelContainer/VBoxContainer/HBoxContainer/Next

func _ready():
	damage.connect("pressed", self, "damage_upgrade")
	shield.connect("pressed", self, "shield_upgrade")
	next.connect("pressed", self, "go_to_next_level")
	
	update_store()
	
	$MarginContainer/PanelContainer/VBoxContainer/TimeCharges.grab_focus()

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
	
	$MarginContainer/PanelContainer/VBoxContainer/TimeCharges.text = str(time_charges)
