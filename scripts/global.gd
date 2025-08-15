extends Node

var target:Vector3

@rpc("any_peer", "call_remote", "reliable")
func notify_message(_message:String)->void:
	var notifies = get_tree().get_nodes_in_group("notify")
	if len(notifies) == 1:
		notifies[0].add_message(_message)
	pass

# testing if the authority server is for remote not other peers
func sent_notify_message(pid:int, _message:String)->void:
	print("sent_notify_message id: ", pid)
	print("multiplayer.is_server(): ", multiplayer.is_server())
	if multiplayer.is_server():
		if pid == 0:
			notify_message(_message)
		else: 
			notify_message.rpc_id(pid,_message)
	else:
		notify_message(_message)

func show_connection_status()-> void:
	#connectionstatus
	var connectionstatuses = get_tree().get_nodes_in_group("connectionstatus")
	if len(connectionstatuses) == 1:
		connectionstatuses[0].show()
	#pass

func hide_connection_status()-> void:
	#connectionstatus
	var connectionstatuses = get_tree().get_nodes_in_group("connectionstatus")
	if len(connectionstatuses) == 1:
		connectionstatuses[0].hide()
	#pass
