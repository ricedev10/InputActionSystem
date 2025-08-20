--!strict
--[=[
	typecheck supported wrapper for creating InputContext, InputAction, and InputBindings

	API:

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

]=]

local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local Types = require(script.Types)

local Input = {}
Input.__index = function(self: Types.Context, index: string)
	return rawget(self, index) or Input[index] or rawget(self, "_context")[index]
end
Input.__newindex = function(self: Types.Context, index: string, value: any)
	rawset(self, index, value)
	rawget(self, "_context")[index] = value
end
Input.InputActionType = {
	Bool = {
		Name = "Bool",
		type = "boolean",
	} :: Types.BoolType,
	Direction1D = {
		Name = "Direction1D",
		type = "number",
	} :: Types.Direction1DType,
	Direction2D = {
		Name = "Direction2D",
		type = "Vector2",
	} :: Types.Direction2DType,
}
Input.Priority = {
	High = {
		Value = 3000,
	},
	Default = {
		Value = 2000,
	},
	Low = {
		Value = 1000,
	},
}

function Input.new(name: string, enabled: boolean?, priority: number?, sink: boolean?): Types.Context
	if not RunService:IsClient() then
		error(`can only create Input devices on the client!`)
	end

	local context: Types.Context = {} :: any

	local inputContext = Instance.new("InputContext")
	inputContext.Name = name
	inputContext.Priority = priority or 1000
	inputContext.Sink = sink or false
	inputContext.Enabled = enabled or false
	context._context = inputContext

	local PlayerGui = Players.LocalPlayer:FindFirstChildOfClass("PlayerGui")
	if not PlayerGui then
		warn("Input may not work; PlayerGui not found, but InputContext will be parented to PlayerGui once found")
		task.spawn(function()
			repeat
				Players.LocalPlayer.ChildAdded:Wait()
				PlayerGui = Players.LocalPlayer:FindFirstChildOfClass("PlayerGui")
			until PlayerGui
			inputContext.Parent = PlayerGui
		end)
	end
	inputContext.Parent = PlayerGui

	return setmetatable(context, Input) :: any
end

-- ACTION Class
local Action = {}
Action.__index = function(self: Types.Context, index: string)
	return rawget(self, index) or Action[index] or rawget(self, "_instance")[index]
end
Action.__newindex = function(self: Types.Context, index: string, value: any)
	rawset(self, index, value)
	rawget(self, "_instance")[index] = value
end

function Input.AddAction<T>(self: Types.Context, name: string, type: T & Types.InputActionType): Types.Action<T>
	local newAction: Types.Action<T> = {} :: any

	local inputActionType: Enum.InputActionType, defaultState: boolean | number | Vector2
	if type.Name == "Bool" then
		inputActionType = Enum.InputActionType.Bool
		defaultState = false
	elseif type.Name == "Direction1D" then
		inputActionType = Enum.InputActionType.Direction1D
		defaultState = 0
	elseif type.Name == "Direction2D" then
		inputActionType = Enum.InputActionType.Direction2D
		defaultState = Vector2.new()
	end

	local inputAction = Instance.new("InputAction")
	inputAction.Name = name
	inputAction.Enabled = true
	inputAction.Type = inputActionType
	inputAction.Parent = self._context
	newAction._instance = inputAction

	newAction._bindings = {}
	newAction._state = defaultState :: any

	return setmetatable(newAction, Action) :: any
end

function Action.AddBinding<T>(
	self: Types.Action<T>,
	keyCode: Enum.KeyCode,
	scale: number,
	compositeDirections: {
		Up: Enum.KeyCode,
		Down: Enum.KeyCode,
		Right: Enum.KeyCode,
		Left: Enum.KeyCode,
	}?
): Types.Binding<T>
	local binding = {} :: Types.Binding<T>

	local inputBinding = Instance.new("InputBinding")
	inputBinding.KeyCode = keyCode
	inputBinding.Scale = scale
	if compositeDirections then
		inputBinding.Up = compositeDirections.Up
		inputBinding.Down = compositeDirections.Down
		inputBinding.Right = compositeDirections.Right
		inputBinding.Left = compositeDirections.Left
	end
	inputBinding.Parent = self._instance
	binding._instance = inputBinding

	return setmetatable(binding, Action) :: any
end

function Action.Fire(self: Types.Action, value)
	self._instance:Fire(value)
end

function Action.GetState(self: Types.Action)
	return self._instance:GetState()
end

return Input :: Types.Input
