extends Label

@export var state_machine: StateMachine:
	set(value):
		if state_machine != null:
			state_machine.active_state_changed.disconnect(_active_state_changed)
		state_machine = value
		if state_machine != null:
			var current_state: State = state_machine.get_active_state()
			if current_state != null:
				text = current_state.name
			state_machine.active_state_changed.connect(_active_state_changed)
 
func _active_state_changed(current: State, _previous: State) -> void:
	text = current.name
