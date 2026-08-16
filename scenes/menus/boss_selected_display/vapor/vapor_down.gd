extends Node2D

#-------------------------------------------------
#      Constants
#-------------------------------------------------
const MOVEMENT_SPEED:float = 30.0
const START_POS = 9
const END_POS = 71
#-------------------------------------------------
#      Signals
#-------------------------------------------------

#-------------------------------------------------
#      Properties
#-------------------------------------------------
export(Color)var background_color = Color("000000")
export(Color)var line_color =Color("f878f8")
#-------------------------------------------------
#      Processes
#-------------------------------------------------

func _ready():
	set_colors()
	
func _process(delta):
	$line1.position.y  += MOVEMENT_SPEED * delta
	if $line1.position.y > END_POS:
		$line1.position.y = 9
		
	$line2.position.y += MOVEMENT_SPEED * delta
	if $line2.position.y > END_POS:
		$line2.position.y = START_POS
	
	$line3.position.y += MOVEMENT_SPEED * delta
	if $line3.position.y > END_POS:
		$line3.position.y = START_POS
		
	$line4.position.y += MOVEMENT_SPEED * delta
	if $line4.position.y > END_POS:
		$line4.position.y = START_POS
#-------------------------------------------------
#      Public Methods
#-------------------------------------------------
func set_colors():
	$TextureRect.material.set_shader_param("replace_0", background_color)
	$TextureRect.material.set_shader_param("replace_1", line_color)
	$line1.material.set_shader_param("replace_1", line_color)
	$line2.material.set_shader_param("replace_1", line_color)
	$line3.material.set_shader_param("replace_1", line_color)
	$line4.material.set_shader_param("replace_1", line_color)
	
#-------------------------------------------------
#      Private Methods
#-------------------------------------------------

#-------------------------------------------------
#      Connections
#-------------------------------------------------
