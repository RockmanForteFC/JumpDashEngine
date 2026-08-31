extends Node

#-------------------------------------------------
#      Constants
#-------------------------------------------------
const NO_LIMIT:float = -1.0
const MAX_HEALTH:float = 28.0
#-------------------------------------------------
#      Signals
#-------------------------------------------------

#-------------------------------------------------
#      Properties
#-------------------------------------------------
# full_name: to be used in Weapon Get Cut Scenes
# menu_name: to be used in the start menu
# key_name: to be used in the weapon state machine
# description: body text describing the weapon in the weapon get cut scene
# ammo: the number of ammo left
# ammo_max: the number of max ammo
# is_equiped: a flag determining if this weapon is in use or not.
# icon: image file for the overhead icon and menu icon
# shader: the color pallate for shading this weapon
# node: the node that will be referenced for this weapon's script.

##-------------------BUSTER--------------------
var buster = { #1
	"full_name":"Mega Buster",
	"menu_name":"M.Buster",
	"key_name":"mega_buster",
	"description":"WEAPON_DESCRIPTION_MEGA_BUSTER",
	"ammo":NO_LIMIT,
	"max_ammo":NO_LIMIT,
	"is_equipped": true,
	"icon": "res://assets/images/weapon icons/buster.png"
}

var rush_coil = {#11
	"full_name":"Rush Coil",
	"menu_name":"R.Coil",
	"key_name":"rush_coil",
	"description":"WEAPON_DESCRIPTION_RUSH_COIL",
	"ammo":MAX_HEALTH,
	"max_ammo":MAX_HEALTH,
	"is_equipped": false,
	"icon":"res://assets/images/weapon icons/rush_coil.png"
}
var rush_jet = {#12
	"full_name":"Rush Jet",
	"menu_name":"R.Jet",
	"key_name":"rush_jet",
	"description":"WEAPON_DESCRIPTION_RUSH_JET",
	"ammo":MAX_HEALTH,
	"max_ammo":MAX_HEALTH,
	"is_equipped": false,
	"icon":"res://assets/images/weapon icons/rush_jet.png"
}
var carry = {#15
	"full_name":"Carry",
	"menu_name":"Carry",
	"key_name":"carry",
	"description":"WEAPON_DESCRIPTION_CARRY",
	"ammo":MAX_HEALTH,
	"max_ammo":MAX_HEALTH,
	"is_equipped": false,
	"icon": "res://assets/images/weapon icons/carry.png"
}
var super_arrow = {#19
	"full_name":"Super Arrow",
	"menu_name":"S.Arrow",
	"key_name":"super_arrow",
	"description":"WEAPON_DESCRIPTION_SUPER_ARROW",
	"ammo":MAX_HEALTH,
	"max_ammo":MAX_HEALTH,
	"is_equipped": false,
	"icon":"res://assets/images/weapon icons/super_arrow.png"
}

##-------------------CLASSIC WEAPONS--------------------

var laser_trident = {#21
	"full_name":"Laser Trident",
	"menu_name":"L.Trident",
	"key_name":"laser_trident",
	"description":"WEAPON_DESCRIPTION_LASER_TRIDENT",
	"ammo":MAX_HEALTH,
	"max_ammo":MAX_HEALTH,
	"is_equipped": false,
	"icon": "res://assets/images/weapon icons/lasertridenticons.png"
}
var bubble_lead = {#22
	"full_name":"Bubble Lead",
	"menu_name":"B.Lead",
	"key_name":"bubble_lead",
	"description":"WEAPON_DESCRIPTION_BUBBLE_LEAD",
	"ammo":MAX_HEALTH,
	"max_ammo":MAX_HEALTH,
	"is_equipped": false,
	"icon": "res://assets/images/weapon icons/bubble_lead.png"
}
var water_balloon = {#23
	"full_name":"Water Balloon",
	"menu_name":"W.Balloon",
	"key_name":"water_balloon",
	"description":"WEAPON_DESCRIPTION_WATER_BALLOON",
	"ammo":MAX_HEALTH,
	"max_ammo":MAX_HEALTH,
	"is_equipped": false,
	"icon": "res://assets/images/weapon icons/water_balloon.png"
}
var blazing_torch = {#24
	"full_name":"Blazing Torch",
	"menu_name":"B.Torch",
	"key_name":"blazing_torch",
	"description":"WEAPON_DESCRIPTION_BLAZING_TORCH",
	"ammo":MAX_HEALTH,
	"max_ammo":MAX_HEALTH,
	"is_equipped": false,
	"icon": "res://assets/images/weapon icons/blazing_torch.png"
}
var thunder_bolt = {#25
	"full_name":"Thunder Bolt",
	"menu_name":"T.Bolt",
	"key_name":"thunder_bolt",
	"description":"WEAPON_DESCRIPTION_THUNDER_BOLT",
	"ammo":MAX_HEALTH,
	"max_ammo":MAX_HEALTH,
	"is_equipped": false,
	"icon": "res://assets/images/weapon icons/thunder_bolt.png"
}
var gemini_laser = {#26
	"full_name":"Gemini Laser",
	"menu_name":"G.Laser",
	"key_name":"gemini_laser",
	"description":"WEAPON_DESCRIPTION_GEMINI_LASER",
	"ammo":MAX_HEALTH,
	"max_ammo":MAX_HEALTH,
	"is_equipped": false,
	"icon": "res://assets/images/weapon icons/gemini_laser.png"
}
var drill_bomb = {#27
	"full_name":"Drill Bomb",
	"menu_name":"D.Bomb",
	"key_name":"drill_bomb",
	"description":"WEAPON_DESCRIPTION_DRILL_BOMB",
	"ammo":MAX_HEALTH,
	"max_ammo":MAX_HEALTH,
	"is_equipped": false,
	"icon": "res://assets/images/weapon icons/drill_bomb.png"
}
var hyper_bomb = {#28
	"full_name":"Hyper Bomb",
	"menu_name":"H.Bomb",
	"key_name":"hyper_bomb",
	"description":"WEAPON_DESCRIPTION_HYPER_BOMB",
	"ammo":MAX_HEALTH,
	"max_ammo":MAX_HEALTH,
	"is_equipped": false,
	"icon": "res://assets/images/weapon icons/hyperbombicons.png"
}

var flame_blast = {#29
	"full_name":"Flame Blast",
	"menu_name":"F.Blast",
	"key_name":"flame_blast",
	"description":"WEAPON_DESCRIPTION_FLAME_BLAST",
	"ammo":MAX_HEALTH,
	"max_ammo":MAX_HEALTH,
	"is_equipped": false,
	"icon": "res://assets/images/weapon icons/flame_blast.png"
 }

var skull_barrier = {#30
	"full_name":"Skull Barrier",
	"menu_name":"S.Barrier",
	"key_name":"skull_barrier",
	"description":"WEAPON_DESCRIPTION_SKULL_BARRIER",
	"ammo":MAX_HEALTH,
	"max_ammo":MAX_HEALTH,
	"is_equipped": false,
	"icon": "res://assets/images/weapon icons/skull_barrier.png"
}

var star_crash = {#31
	"full_name":"Star Crash",
	"menu_name":"S.Crash",
	"key_name":"star_crash",
	"description":"WEAPON_DESCRIPTION_STAR_CRASH",
	"ammo":MAX_HEALTH,
	"max_ammo":MAX_HEALTH,
	"is_equipped": false,
	"icon": "res://assets/images/weapon icons/star_crash.png"
}
var centaur_flash = {#32
	"full_name":"Centaur Flash",
	"menu_name":"C.Flash",
	"key_name":"centaur_flash",
	"description":"WEAPON_DESCRIPTION_CENTAUR_FLASH",
	"ammo":MAX_HEALTH,
	"max_ammo":MAX_HEALTH,
	"is_equipped": false,
	"icon": "res://assets/images/weapon icons/centaur_flash.png"
}
var leaf_shield = {#33
	"full_name":"Leaf Shield",
	"menu_name":"L.Shield",
	"key_name":"leaf_shield",
	"description":"WEAPON_DESCRIPTION_LEAF_SHIELD",
	"ammo":MAX_HEALTH,
	"max_ammo":MAX_HEALTH,
	"is_equipped": false,
	"icon": "res://assets/images/weapon icons/leaf_shield.png"
}
var plant_barrier = {#34
	"full_name":"Plant Barrier",
	"menu_name":"Plant B.",
	"key_name":"plant_barrier",
	"description":"WEAPON_DESCRIPTION_PLANT_BARRIER",
	"ammo":MAX_HEALTH,
	"max_ammo":MAX_HEALTH,
	"is_equipped": false,
	"icon": "res://assets/images/weapon icons/plant_barrier.png"
}
var gyro_attack = {#35
	"full_name":"Gyro Attack",
	"menu_name":"Gyro A.",
	"key_name":"gyro_attack",
	"description":"WEAPON_DESCRIPTION_GYRO_ATTACK",
	"ammo":MAX_HEALTH,
	"max_ammo":MAX_HEALTH,
	"is_equipped": false,
	"icon": "res://assets/images/weapon icons/gyro_attack.png"
}
var shadow_blade = {#36
	"full_name":"Shadow Blade",
	"menu_name":"Shadow B.",
	"key_name":"shadow_blade",
	"description":"WEAPON_DESCRIPTION_SHADOW_BLADE",
	"ammo":MAX_HEALTH,
	"max_ammo":MAX_HEALTH,
	"is_equipped": false,
	"icon": "res://assets/images/weapon icons/shadow_blade.png"
}
var metal_blade = {#37
	"full_name":"Metal Blade",
	"menu_name":"Metal B.",
	"key_name":"metal_blade",
	"description":"WEAPON_DESCRIPTION_METAL_BLADE",
	"ammo":MAX_HEALTH,
	"max_ammo":MAX_HEALTH,
	"is_equipped": false,
	"icon": "res://assets/images/weapon icons/metalblade.png"
}

var yamato_spear = {#38
	"full_name":"Yamato Spear",
	"menu_name":"Y.Spear",
	"key_name":"yamato_spear",
	"description":"WEAPON_DESCRIPTION_YAMATO_SPEAR",
	"ammo":MAX_HEALTH,
	"max_ammo":MAX_HEALTH,
	"is_equipped": false,
	"icon":"res://assets/images/weapon icons/yamato_spear.png"
}

var rebound_striker = {#39
	"full_name":"Rebound Striker",
	"menu_name":"R.Striker",
	"key_name":"rebound_striker",
	"description":"WEAPON_DESCRIPTION_REBOUND_STRIKER",
	"ammo":MAX_HEALTH,
	"max_ammo":MAX_HEALTH,
	"is_equipped": false,
	"icon":"res://assets/images/weapon icons/ReboundStriker.png"
}
var block_dropper = {#40
	"full_name":"Block Dropper",
	"menu_name":"B.Dropper",
	"key_name":"block_dropper",
	"description":"WEAPON_DESCRIPTION_BLOCK_DROPPER",
	"ammo":MAX_HEALTH,
	"max_ammo":MAX_HEALTH,
	"is_equipped": false,
	"icon":"res://assets/images/weapon icons/block_dropper.png"
}
var solar_blaze = {#41
	"full_name":"Solar Blaze",
	"menu_name":"S.Blaze",
	"key_name":"solar_blaze",
	"description":"WEAPON_DESCRIPTION_SOLAR_BLAZE",
	"ammo":MAX_HEALTH,
	"max_ammo":MAX_HEALTH,
	"is_equipped": false,
	"icon":"res://assets/images/weapon icons/solar_blaze.png"
}
var crystal_eye = {#42
	"full_name":"Crystal Eye",
	"menu_name":"C.Eye",
	"key_name":"crystal_eye",
	"description":"WEAPON_DESCRIPTION_CRYSTAL_EYE",
	"ammo":MAX_HEALTH,
	"max_ammo":MAX_HEALTH,
	"is_equipped": false,
	"icon":"res://assets/images/weapon icons/crystal_eye.png"
}
var slash_claw = {#43
	"full_name":"Slash Claw",
	"menu_name":"S.Claw",
	"key_name":"slash_claw",
	"description":"WEAPON_DESCRIPTION_SLASH_CLAW",
	"ammo":MAX_HEALTH,
	"max_ammo":MAX_HEALTH,
	"is_equipped": false,
	"icon":"res://assets/images/weapon icons/slash_claw.png"
}
var shark_boomerang = {#44
	"full_name":"Shark Boomerang",
	"menu_name":"S.Boomerang",
	"key_name":"shark_boomerang",
	"description":"WEAPON_DESCRIPTION_SHARK_BOOMERANG",
	"ammo":MAX_HEALTH,
	"max_ammo":MAX_HEALTH,
	"is_equipped": false,
	"icon":"res://assets/images/weapon icons/shark_boomerang.png"
}
var power_stone = {#45
	"full_name":"Power Stone",
	"menu_name":"P.Stone",
	"key_name":"power_stone",
	"description":"WEAPON_DESCRIPTION_POWER_STONE",
	"ammo":MAX_HEALTH,
	"max_ammo":MAX_HEALTH,
	"is_equipped": false,
	"icon":"res://assets/images/weapon icons/power_stone.png"
}
var hard_knuckle = {#46
	"full_name":"Hard Knuckle",
	"menu_name":"H.Knuckle",
	"key_name":"hard_knuckle",
	"description":"WEAPON_DESCRIPTION_HARD_KNUCKLE",
	"ammo":MAX_HEALTH,
	"max_ammo":MAX_HEALTH,
	"is_equipped": false,
	"icon": "res://assets/images/weapon icons/hard_knuckle.png"
}
var silver_tomahawk = {#47
	"full_name":"Silver Tomahawk",
	"menu_name":"S.Tomahawk",
	"key_name":"silver_tomahawk",
	"description":"WEAPON_DESCRIPTION_SILVER_TOMAHAWK",
	"ammo":MAX_HEALTH,
	"max_ammo":MAX_HEALTH,
	"is_equipped": false,
	"icon": "res://assets/images/weapon icons/silver_tomahawk.png"
}
var air_shooter = {#48
	"full_name":"Air Shooter",
	"menu_name":"A.Shooter",
	"key_name":"air_shooter",
	"description":"WEAPON_DESCRIPTION_AIR_SHOOTER",
	"ammo":MAX_HEALTH,
	"max_ammo":MAX_HEALTH,
	"is_equipped": false,
	"icon": "res://assets/images/weapon icons/air_shooter.png"
}
var wind_storm = {#49
	"full_name":"Wind Storm",
	"menu_name":"W.Storm",
	"key_name":"wind_storm",
	"description":"WEAPON_DESCRIPTION_WIND_STORM",
	"ammo":MAX_HEALTH,
	"max_ammo":MAX_HEALTH,
	"is_equipped": false,
	"icon": "res://assets/images/weapon icons/wind_storm.png"
}
var napalm_bomb = {#50
	"full_name":"Napalm Bomb",
	"menu_name":"N.Bomb",
	"key_name":"napalm_bomb",
	"description":"WEAPON_DESCRIPTION_NAPALM_BOMB",
	"ammo":MAX_HEALTH,
	"max_ammo":MAX_HEALTH,
	"is_equipped": false,
	"icon": "res://assets/images/weapon icons/napalm_bomb.png"
}

##-------------------MISCELLANIOUS MEGA MAN WEAPONS--------------------
var super_arm_pf = {#51
	"full_name":"Super Arm PF",
	"menu_name":"S.Arm",
	"key_name":"super_arm_pf",
	"description":"WEAPON_DESCRIPTION_SUPER_ARM_PF",
	"ammo":MAX_HEALTH,
	"max_ammo":MAX_HEALTH,
	"is_equipped": false,
	"icon":"res://assets/images/weapon icons/super_arm_pf.png"
}
var tail_wind = {#52
	"full_name":"Tail Wind",
	"menu_name":"T.Wind",
	"key_name":"tail_wind",
	"description":"WEAPON_DESCRIPTION_TAIL_WNID",
	"ammo":MAX_HEALTH,
	"max_ammo":MAX_HEALTH,
	"is_equipped": false,
	"icon":"res://assets/images/weapon icons/tails_wind_icon.png"
}
var chroma_camo = {#53
	"full_name":"Chroma Camo",
	"menu_name":"C.Camo",
	"key_name":"chroma_camo",
	"description":"WEAPON_DESCRIPTION_CHROMA_CAMO",
	"ammo":MAX_HEALTH,
	"max_ammo":MAX_HEALTH,
	"is_equipped": false,
	"icon":"res://assets/images/weapon icons/chroma_camo.png"
}
var c_wing_shield = {#54
	"full_name":"Chicken Wing Shield",
	"menu_name":"C-Wing S.",
	"key_name":"c_wing_shield",
	"description":"WEAPON_DESCRIPTION_C_WING_SHIELD",
	"ammo":MAX_HEALTH,
	"max_ammo":MAX_HEALTH,
	"is_equipped": false,
	"icon":"res://assets/images/weapon icons/c_wing_shield.png"
}
var black_wave = {#55
	"full_name":"Black Wave",
	"menu_name":"B.Wave",
	"key_name":"black_wave",
	"description":"WEAPON_DESCRIPTION_BLACK_WAVE",
	"ammo":MAX_HEALTH,
	"max_ammo":MAX_HEALTH,
	"is_equipped": false,
	"icon":"res://assets/images/weapon icons/black_wave.png"
}
var shiny_knuckle = {#56
	"full_name":"Shiny Knuckle",
	"menu_name":"Shiny K.",
	"key_name":"shiny_knuckle",
	"description":"WEAPON_DESCRIPTION_SHINY_KNUCKLE",
	"ammo":MAX_HEALTH,
	"max_ammo":MAX_HEALTH,
	"is_equipped": false,
	"icon":"res://assets/images/weapon icons/shiny_knuckle_icon.png"
}
##-------------------CAPCOM RELATED WEAPONS--------------------
var arthurs_lance = {#57
	"full_name":"Arthurs Lance",
	"menu_name":"Arthur L.",
	"key_name":"arthurs_lance",
	"description":"WEAPON_DESCRIPTION_ARTHURS_LANCE",
	"ammo":MAX_HEALTH,
	"max_ammo":MAX_HEALTH,
	"is_equipped": false,
	"icon":"res://assets/images/weapon icons/arthur_lance.png"
}
var pheonix_pursuit = {#58
	"full_name":"Pheonix Pursuit",
	"menu_name":"P.Pursuit",
	"key_name":"pheonix_pursuit",
	"description":"WEAPON_DESCRIPTION_PHEONIX_PURSUIT",
	"ammo":MAX_HEALTH,
	"max_ammo":MAX_HEALTH,
	"is_equipped": false,
	"icon":"res://assets/images/weapon icons/pheonix_pursuit.png"
}
var son_son_shooter = {#59
	"full_name":"Son Son Shooter",
	"menu_name":"Sonson S.",
	"key_name":"son_son_shooter",
	"description":"WEAPON_DESCRIPTION_SON_SON_SHOOTER",
	"ammo":MAX_HEALTH,
	"max_ammo":MAX_HEALTH,
	"is_equipped": false,
	"icon":"res://assets/images/weapon icons/son_son_shooter.png"
}
var forgotten_friend = {#60
	"full_name":"Forgotten Friend",
	"menu_name":"F.Friend",
	"key_name":"forgotten_friend",
	"description":"WEAPON_DESCRIPTION_FORGOTTEN_FRIEND",
	"ammo":MAX_HEALTH,
	"max_ammo":MAX_HEALTH,
	"is_equipped": false,
	"icon":"res://assets/images/weapon icons/forgotten_friend.png"
}
var cd_crate = {#61
	"full_name":"Chipmunk Crate",
	"menu_name":"C.Crate",
	"key_name":"cd_crate",
	"description":"WEAPON_DESCRIPTION_CD_CRATE",
	"ammo":MAX_HEALTH,
	"max_ammo":MAX_HEALTH,
	"is_equipped": false,
	"icon":"res://assets/images/weapon icons/cd_crate.png"
}
var samurai_edge = {#62
	"full_name":"Samurai Edge",
	"menu_name":"S.Edge",
	"key_name":"samurai_edge",
	"description":"WEAPON_DESCRIPTION_SAMURAI_EDGE",
	"ammo":MAX_HEALTH,
	"max_ammo":MAX_HEALTH,
	"is_equipped": false,
	"icon":"res://assets/images/weapon icons/samurai_edge.png"
}
var arcade_vision = {#63
	"full_name":"Arcade Vision",
	"menu_name":"Arcade.V",
	"key_name":"arcade_vision",
	"description":"WEAPON_DESCRIPTION_ARCADE_VISION",
	"ammo":MAX_HEALTH,
	"max_ammo":MAX_HEALTH,
	"is_equipped": false,
	"icon":"res://assets/images/weapon icons/arcade_vision.png"
}
var serve_bot = {#64
	"full_name":"Serve Bot",
	"menu_name":"Servebot",
	"key_name":"serve_bot",
	"description":"WEAPON_DESCRIPTION_SERVE_BOT",
	"ammo":MAX_HEALTH,
	"max_ammo":MAX_HEALTH,
	"is_equipped": false,
	"icon":"res://assets/images/weapon icons/serve_bot.png"
}

var redbull_wings = {#65
	"full_name":"RB Wings",
	"menu_name":"RB.Wings",
	"key_name":"redbull_wings",
	"description":"WEAPON_DESCRIPTION_REDBULL_WINGS",
	"ammo":MAX_HEALTH,
	"max_ammo":MAX_HEALTH,
	"is_equipped": false,
	"icon":"res://assets/images/weapon icons/red_bull.png"
}
##-------------------MEGA MARINO WEAPONS--------------------
#var adorable_sausage = {
#	"full_name":"Adorable Sausage",
#	"menu_name":"A.Sausage",
#	"key_name":"adorable_sausage",
#	"description":"You'll be the king of the backyard BBQ",
#	"ammo":MAX_HEALTH,
#	"max_ammo":MAX_HEALTH,
#	"is_equipped": false,
#	"icon":"res://assets/images/weapon icons/adorable_sausage.png"
#}
#var chombeys_chimney = {
#	"full_name":"Chombeys Chimney",
#	"menu_name":"C.Chimney",
#	"key_name":"chombeys_chimney",
#	"description":"Drop a Chimney on their dome piece",
#	"ammo":MAX_HEALTH,
#	"max_ammo":MAX_HEALTH,
#	"is_equipped": false,
#	"icon":"res://assets/images/weapon icons/chombeys_chimney.png"
#}
#var marino_pieces = {
#	"full_name":"Marino Pieces",
#	"menu_name":"M.Pieces",
#	"key_name":"marino_pieces",
#	"description":"Shoot your very own pieces piece",
#	"ammo":MAX_HEALTH,
#	"max_ammo":MAX_HEALTH,
#	"is_equipped": false,
#	"icon":"res://assets/images/weapon icons/marino_pieces.png"
#}
#var wax_lime = {
#	"full_name":"Wax Lime",
#	"menu_name":"W.Lime",
#	"key_name":"wax_lime",
#	"description":"shoot a bouncy limes",
#	"ammo":MAX_HEALTH,
#	"max_ammo":MAX_HEALTH,
#	"is_equipped": false,
#	"icon":"res://assets/images/weapon icons/wax_lime.png"
#}
##-------------------NOTHING--------------------
var no_weapon = {#66
	"full_name":"Nothing",
	"menu_name":"M.Buster",
	"key_name":"no_weapon",
	"description":"WEAPON_DESCRIPTION_NO_WEAPON",
	"ammo":MAX_HEALTH,
	"max_ammo":MAX_HEALTH,
	"is_equipped": false,
	"icon": "res://assets/images/weapon icons/no_buster.png"
}

##-------------------CURSES--------------------
var metribution = {#67
	"full_name":"Metribution",
	"menu_name":"Met.",
	"key_name":"metribution",
	"description":"WEAPON_DESCRIPTION_METRIBUTION",
	"ammo":MAX_HEALTH,
	"max_ammo":MAX_HEALTH,
	"is_equipped": false,
	"icon":"res://assets/images/weapon icons/metribution.png"
}
var zenny_rain = {#68
	"full_name":"Zenny Rain",
	"menu_name":"Z.Rain",
	"key_name":"zenny_rain",
	"description":"WEAPON_DESCRIPTION_ZENNY_RAIN",
	"ammo":MAX_HEALTH,
	"max_ammo":MAX_HEALTH,
	"is_equipped": false,
	"icon":"res://assets/images/weapon icons/zenny_rain.png"
}
var proto_whistle = {#69
	"full_name":"Proto Whistle",
	"menu_name":"P.Whistle",
	"key_name":"proto_whistle",
	"description":"WEAPON_DESCRIPTION_PROTO_WHISTLE",
	"ammo":MAX_HEALTH,
	"max_ammo":MAX_HEALTH,
	"is_equipped": false,
	"icon":"res://assets/images/weapon icons/proto_whistle.png"
}
var floppy_fish = {#70
	"full_name":"Floppy Fish",
	"menu_name":"Floppy.F",
	"key_name":"floppy_fish",
	"description":"WEAPON_DESCRIPTION_FLOPPY_FISH",
	"ammo":MAX_HEALTH,
	"max_ammo":MAX_HEALTH,
	"is_equipped": false,
	"icon":"res://assets/images/weapon icons/floppy_fish.png"
}

var deep_digger = {#71
	"full_name":"Deep Digger",
	"menu_name":"D.Digger",
	"key_name":"deep_digger",
	"description":"WEAPON_DESCRIPTION_DEEP_DIGGER",
	"ammo":MAX_HEALTH,
	"max_ammo":MAX_HEALTH,
	"is_equipped": false,
	"icon":"res://assets/images/weapon icons/deep_digger.png"
}

#-------------------------------------------------
#      Processes
#-------------------------------------------------

func _ready():
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
