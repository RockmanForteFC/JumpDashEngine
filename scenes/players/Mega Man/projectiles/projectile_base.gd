extends KinematicBody2D

#-------------------------------------------------
#      Constants
#-------------------------------------------------

#-------------------------------------------------
#      Signals
#-------------------------------------------------

#-------------------------------------------------
#      Properties
#-------------------------------------------------
export(int) var damage := 1
export(bool) var is_piercing :=false
#if a weapon is piercing it can hit through shields. But breaks on enemy is an additional option to prevent the weapon from hitting multiple enemys with shields
export(bool) var breaks_on_enemy := false
export (Physics.Element)var element:int = Physics.Element.neutral
export (Physics.Damage)var damage_type:int = Physics.Damage.projectile
export(String) var key_name

var direction: Vector2
var consumed := false
var did_hit_enemy:bool = false
var is_upgraded:bool = false
#-------------------------------------------------
#      Processes`
#-------------------------------------------------

func _ready():
	if !is_in_group("PlayerWeapons"):
		add_to_group("PlayerWeapons")
	is_upgraded = PlayerValues.equipped_upgrade == key_name

func reflect():
	pass
#-------------------------------------------------
#      Public Methods
#-------------------------------------------------

#-------------------------------------------------
#      Private Methods
#-------------------------------------------------

#-------------------------------------------------
#      Connections
#-------------------------------------------------
