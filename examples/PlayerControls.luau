local InputActionSystem = require(path.to.InputActionSystem)
   
-- create input
local PlayerContext = InputActionSystem.new("PlayerInput", true, InputActionSystem.Priority.Default.Value, false)

-- add actions
local moveDirectionAction = PlayerContext:AddAction("MoveDirection", InputActionSystem.InputActionType.Direction2D)
moveDirectionAction:AddBinding(Enum.KeyCode.W, 1, {
   Up = Enum.KeyCode.W,
   Down = Enum.KeyCode.S,
   Right = Enum.KeyCode.D,
   Left = Enum.KeyCode.A,
})

local jumpAction = PlayerContext:AddAction("JumpAction", InputActionSystem.InputActionType.Bool)
jumpAction:AddBinding(Enum.KeyCode.Space, 1)
jumpAction:AddBinding(Enum.KeyCode.Up, 1)

return {
   Context = PlayerContext,
   MoveDirection = moveDirectionAction,
   JumpAction = jumpAction,
}
