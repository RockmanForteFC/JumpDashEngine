extends VBoxContainer

const LOCKED_TEXT = "Locked"
const SEL = "MenuSelection"
const OPT = "MenuOption"
const ARROW = "Arrow"
onready var ArrowSprite = $Arrow
onready var OptionSound = $MenuOption
onready var OkSound =  $MenuSelection
onready var error_sound = $ErrorSound

var labels = []
var selected = 0
export var is_active = true
var has_begun = false

signal menu_item_selected
signal selection_changed

func _ready():
	labels.empty()
	for child in get_children():
		ArrowSprite.position.x = 0
		if child is Label:
			labels.append(child)
			child.uppercase = true
			# Add a single space before the text to have alignment with the arrow sprite
			child.text = " " + tr(child.text)
			child.align = Label.ALIGN_LEFT
		if labels.size() > 0:
			if is_active:
				ArrowSprite.show()
				ArrowSprite.play("Menu")
				selected = 0
				highlightOption(selected)
				has_begun = true
	emit_signal("selection_changed",labels[selected])

func _process(_delta):
	if is_active and not has_begun:
		ArrowSprite.show()
		ArrowSprite.play("Menu")
		selected = 0
		highlightOption(selected)
		has_begun = true

	if is_active and not labels.size() == 0:
		if Input.is_action_just_pressed("ui_down"):
			OptionSound.play()
			if selected == labels.size()-1:
				selected = 0
			else:
				selected += 1
			highlightOption(selected)
			$Arrow.frame = 0
			emit_signal("selection_changed",labels[selected])
		if Input.is_action_just_pressed("ui_up"):
			OptionSound.play()
			if selected == 0:
				selected = labels.size() -1
			else:
				selected -= 1
				$Arrow.frame = 0
			highlightOption(selected)
			emit_signal("selection_changed",labels[selected])
		if Input.is_action_just_pressed("ui_accept") or Input.is_action_just_pressed("action_jump_p1"):
			if labels[selected].hint_tooltip == LOCKED_TEXT:
				error_sound.play()
			else:
				OkSound.play()
				emit_signal("menu_item_selected", labels[selected].name)

func highlightOption(selectedItem):
	if labels.size() > 0:
		var label = labels[selectedItem]
		ArrowSprite.position.y = label.rect_position.y + 5

func enable():
	if labels.size() > 0 and is_active:
		ArrowSprite.show()
		ArrowSprite.play("Menu")
		selected = 0
		highlightOption(selected)
		has_begun = true

func disable():
	is_active = false
	has_begun = false
	ArrowSprite.hide()

