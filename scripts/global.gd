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


func generate_random_name(min_length: int = 3, max_length: int = 8) -> String:
	var vowels = ["a", "e", "i", "o", "u"]
	var consonants = ["b", "c", "d", "f", "g", "h", "j", "k", "l", "m", "n", "p", "r", "s", "t", "v", "w", "y"]
	var name_length = randi_range(min_length, max_length)
	var _name = ""
	var use_vowel = randi() % 2 == 0
	
	for i in range(name_length):
		if use_vowel:
			_name += vowels[randi() % vowels.size()]
		else:
			_name += consonants[randi() % consonants.size()]
		use_vowel = !use_vowel
	
	# Capitalize first letter
	_name = _name.capitalize()
	
	return _name
