extends Control

@onready var ui_network: Control = $"."
@onready var line_edit_notify: LineEdit = $"../UIDebug/VBoxContainer/LineEdit_notify"

func _ready() -> void:
	pass

#func _process(delta: float) -> void:
	#pass

func _on_btn_host_pressed() -> void:
	GameNetwork._network_host()
	ui_network.hide()
	#pass

func _on_btn_join_pressed() -> void:
	GameNetwork._network_join()
	ui_network.hide()
	#pass

func _on_btn_test_notify_pressed() -> void:
	Global.notify_message(line_edit_notify.text)
	pass
