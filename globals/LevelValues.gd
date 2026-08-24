extends Node

#-------------------------------------------------
#      Constants
#-------------------------------------------------

#-------------------------------------------------
#      Signals
#-------------------------------------------------

#-------------------------------------------------
#      Properties
#-------------------------------------------------
var enemies_killed:Dictionary
var items_picked_up:Dictionary = {
	"extra_life" : 0,
	"small_ammo" : 0,
	"small_health": 0,
	"small_bolt":0,
	"large_ammo": 0,
	"large_health":0,
	"large_bolt":0,
	"e_tank":0,
	"w_tank":0,
	"m_tank":0,
	"small_anti_ammo": 0,
	"small_anti_health": 0,
	"small_anti_bolt": 0,
	"large_anti_health": 0,
	"large_anti_ammo": 0,
	"large_anti_bolt": 0,
}
#-------------------------------------------------
#      Processes
#-------------------------------------------------

#-------------------------------------------------
#      Public Methods
#-------------------------------------------------
func resetValues():
	enemies_killed.clear()
	items_picked_up.clear()
	items_picked_up = {
	"extra_life" : 0,
	"small_ammo" : 0,
	"small_health": 0,
	"small_bolt":0,
	"large_ammo": 0,
	"large_health":0,
	"large_bolt":0,
	"e_tank":0,
	"w_tank":0,
	"m_tank":0,
	"small_anti_ammo": 0,
	"small_anti_health": 0,
	"small_anti_bolt": 0,
	"large_anti_health": 0,
	"large_anti_ammo": 0,
	"large_anti_bolt": 0,
	"giant_bolt":0
}
#-------------------------------------------------
#      Private Methods
#-------------------------------------------------

#-------------------------------------------------
#      Connections
#-------------------------------------------------

func _on_enemy_died(enemy_id):
	if enemy_id != "miniboss":
		enemies_killed[enemy_id] = true

func _on_item_pickup(item_name):
	items_picked_up[item_name] += 1

func get_picked_up_item_count():
	var count = 0
	for item in items_picked_up:
		count += items_picked_up[item]
	return count

func was_pacifist():
	var was_pacifist = true
	if enemies_killed.size() > 0:
		was_pacifist = false

	return was_pacifist
