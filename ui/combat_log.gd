class_name CombatLog
extends Control

@onready var rich_text_label = %RichTextLabel

func log_event(text: String) -> void:
	rich_text_label.append_text(text)
	rich_text_label.newline()
