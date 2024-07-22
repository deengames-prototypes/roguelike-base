extends Control

@onready var console_log = %ConsoleLog

func _ready() -> void:
	console_log.text = ""
	CoreEventBus.log_to_console.connect(log_message)

func log_message(message:String) -> void:
	%ConsoleLog.text += message + "\n"
	# Show only the most recent messages
	%ConsoleLog.lines_skipped = %ConsoleLog.get_line_count() - %ConsoleLog.max_lines_visible
