extends TextureButton

const CURSOR_DEFAULT = preload("res://assets/sprites/cursor_default.png")
const CURSOR_POINTER = preload("res://assets/sprites/cursor_pointer.png")
const BUTTON_PRESS = preload("res://assets/audios/button_press.ogg")

enum RibbonColor {BLUE, RED, BLACK}

@onready var tile_map_layer_blue: TileMapLayer = $TileMapLayerBlue
@onready var tile_map_layer_red: TileMapLayer = $TileMapLayerRed
@onready var tile_map_layer_black: TileMapLayer = $TileMapLayerBlack
@onready var label: Label = $Label

@export var text: String = ""
@export var color: RibbonColor = RibbonColor.BLUE

func _ready() -> void:
	set_text(text)
	set_color(color)

func _on_pressed() -> void:
	GlobalAudioManager.play_audio(BUTTON_PRESS)

func _on_mouse_entered() -> void:
	Input.set_custom_mouse_cursor(CURSOR_POINTER, Input.CURSOR_ARROW, Vector2(22, 17))

func _on_mouse_exited() -> void:
	Input.set_custom_mouse_cursor(CURSOR_DEFAULT, Input.CURSOR_ARROW, Vector2(22, 17))

func set_text(value: String) -> void:
	label.text = value

func set_color(value: RibbonColor) -> void:
	tile_map_layer_blue.visible = value == RibbonColor.BLUE
	tile_map_layer_red.visible = value == RibbonColor.RED
	tile_map_layer_black.visible = value == RibbonColor.BLACK
