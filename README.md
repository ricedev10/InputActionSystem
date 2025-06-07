Basic API:

	Input.new() -> InputContext
	Input.InputActionType: {
		Bool: type
		Direction1D: type
		Direction2D: type
	} -- list of custom InputActionTypes
	Input.Priority: {
		High: {Value: number}
		Default: {Value: number}
		Low: {Value: number}
	}

	InputContext:AddAction() -> InputAction
	
	InputAction:AddBinding() -> InputBinding
