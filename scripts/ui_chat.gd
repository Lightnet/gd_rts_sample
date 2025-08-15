extends Control

@onready var line_edit_message: LineEdit = $VBoxContainer/LineEdit_Message


func _on_btn_sent_message_pressed() -> void:
	if multiplayer.is_server():
		sent_message.rpc("PEER ID: 1" + " > " +line_edit_message.text)
	else:
		request_message.rpc_id(1,line_edit_message.text) #pass, single message
	pass

@rpc("any_peer","call_remote")
func request_message(message):
	# if not server then return
	if not multiplayer.is_server(): return
	# need to get id from get_remote_sender_id
	print("REMOTE ID:", multiplayer.get_remote_sender_id())
	# pass to message and id
	sent_message_id.rpc(message, multiplayer.get_remote_sender_id())
	#pass

#make sure it server
@rpc("authority","call_local")
func sent_message_id(message,id):
	# if not server then return
	if not multiplayer.is_server(): return
	#get remote id from client
	print("authority >> call_local >> sent_message_id ID:", id)
	# later use to get user name from list
	#Global.notify_message(message)
	var msg = "PEER ID:" + str(id) + " > " + message
	sent_message.rpc(msg)
	#pass

# if server then sync with server and clients
@rpc("authority","call_local")
func sent_message(message):
	print("ID:", multiplayer.get_remote_sender_id())
	Global.notify_message(message)
	#pass
