extends Node

signal score_changed(new_score, delta)

#-------------------------------------------------
#      Negative Constants
#-------------------------------------------------
const DAMAGE_BOOST_INSTANT_DEATH:int = -115
const PROJECTILE_DAMAGE:int = -35
const CONTACT_DAMAGE:int = -50
#This is a general base for all deaths
const DEATH:int = -1000
#the method of death will add an additional penalty
const DEATH_BY_LASER:int = -200
const DEATH_BY_CRUSH:int = -500
const DEATH_BY_SPIKE:int = -200
const DEATH_BY_PIT:int = -200
const DEATH_BY_LAVA:int = -500
const TANK_USED:int = -100
const GAME_OVER:int = -2000
#-------------------------------------------------
#      Positive Constants
#-------------------------------------------------
const HEALTH_AMMO_PICKUP_SCORE:int = 12
const HEALTH_AMMO_FULL_MODIFIER:int = 3
const EXTRA_LIFE_GET:int = 200
const TANK_PICKUP_GET:int = 40
const BLUE_SCORE_BALL:int = 100
const RED_SCORE_BALL:int = 200
const GOLD_SCORE_BALL:int = 500
const BOSS_COMPLETE:int = 1000
const FULL_HEALTH_LEVEL_COMPLETE:int = 500
#-------------------------------------------------
#      Public Methods
#-------------------------------------------------
func change(score:int)->void:
	var previous_score := PlayerValues.score
	PlayerValues.score = clamp(PlayerValues.score + score,0,9223372036854775807)
	emit_signal("score_changed", PlayerValues.score, PlayerValues.score - previous_score)
