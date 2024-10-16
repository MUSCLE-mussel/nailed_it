extends Node2D
class_name HubScene

@export var zones: Array[HubZone]

var selected_zone: int = -1

func _ready() -> void:
	for i in zones.size():
		if zones[i] == null: continue
		zones[i].index = i
		zones[i].clicked.connect(on_zone_clicked)

func init():
	selected_zone = -1

func on_zone_clicked(zone: HubZone):
	selected_zone = zone.index
