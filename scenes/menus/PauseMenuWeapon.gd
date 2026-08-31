extends Control

var weapon
var is_weapon_obtained = false

func set_icon():
	#prepare the icon for the weapon
	var t = AtlasTexture.new()
	t.atlas = load(weapon.icon)
	t.region = Rect2(32,0,16,16)
	$WeaponIcon.texture = t

func set_active():
	# if this x value is set to 0, the start menu will use the weapon colors
	# if it is set to 16 the pause menu will show highlighted weapons in blue.
	$WeaponIcon.texture.region.position.x = 0
	$WeaponContainer/WeaponAmmoBar.modulate = Color(1, 1 ,1)

func set_inactive():
	$WeaponIcon.texture.region.position.x = 32
	$WeaponContainer/WeaponAmmoBar.modulate = Color(188.0/255, 188.0/255 ,188.0/255)

func set_weapon():
	$WeaponContainer/WeaponName.text = weapon.menu_name
	$WeaponContainer/WeaponAmmoBar.pellet_count = weapon.ammo

func set_weapon_special(ammo: int) -> void:
	$WeaponContainer/WeaponName.text = weapon.menu_name
	$WeaponContainer/WeaponAmmoBar.pellet_count = ammo
