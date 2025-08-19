
# Information
  Work in progress. This is just a script need to disable and enable for peer id assign for auth loop.

  This is useful for player input and character3d.

  There may be over lap when call if there no is_multiplayer_authority() in _process.
  For example when the server and client has no is_multiplayer_authority. When they call for the server and client my trigger twice which need to rework the code. Mean who in charge of the for prefabs node entity.

  Another is handle the effects like sound and effects when doing some hit effect. It need to sync.

  This is work in progress test build.


# set_multiplayer_authority()
```
set_multiplayer_authority(peer_id:int)
```
current client peer id.
```
multiplayer.get_unique_id()
```
 this will get the current peer id.
1 = server

# is_multiplayer_authority()
```
if is_multiplayer_authority():
	pass
```

# notes:
- ...


# Notes:
- it need to filter out the sync
