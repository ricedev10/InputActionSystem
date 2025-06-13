local InputActionSystem = require(path.to.InputActionSystem)

local CameraInput = InputActionSystem.new("CameraInput", true, InputActionSystem.Priority.Default.Value, true)

local MouseMovementAction = CameraInput:AddAction("MouseMovement", InputActionSystem.InputActionType.Direction2D)

UserInputService.InputChanged:Connect(function(inputObject, gameProcessed)
	if inputObject.UserInputType == Enum.UserInputType.MouseMovement then
		MouseMovementAction:Fire(UserInputService:GetMouseDelta())
	end
end)

return {
	MouseMovement = MouseMovementAction,
}
