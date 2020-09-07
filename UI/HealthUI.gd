extends Control

const HEART_SIZE = 15

var hearts = 14 setget set_hearts
export(int) var max_hearts = 4 setget set_max_hearts

onready var heartUI = $HeartUI
onready var emptyHeartUI = $HeartUIEmpty

func set_hearts(value):
	if heartUI:
		heartUI.rect_size.x = HEART_SIZE * value
	
func set_max_hearts(value):
	if emptyHeartUI:
			emptyHeartUI.rect_size.x = HEART_SIZE * value
	
func _ready():
	self.max_hearts = PlayerStats.max_health
	self.hearts = PlayerStats.health
	var _err = PlayerStats.connect("health_changed", self, "set_hearts")
	_err = PlayerStats.connect("max_health_changed", self, "set_max_hearts")
