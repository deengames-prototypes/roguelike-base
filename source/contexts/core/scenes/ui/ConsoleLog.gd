extends Control

@onready var console_log = %ConsoleLog

func _ready() -> void:
	console_log.text = ""
