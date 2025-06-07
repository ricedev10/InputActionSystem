--!strict
local Types = {}
local packages = script.Parent.Parent
local Signal = require(packages.Signal)

export type Input = {
	new: (name: string, enabled: boolean?, priority: number?, sink: boolean?) -> Context,
	InputActionType: {
		Bool: BoolType,
		Direction1D: Direction1DType,
		Direction2D: Direction2DType,
	},
	Priority: {
		High: {
			Value: number,
		},
		Default: {
			Value: number,
		},
		Low: {
			Value: number,
		},
	},
}

-- Input Actoin Types
export type BoolType = {
	Name: "Bool",
	type: "boolean",
}
export type Direction1DType = {
	Name: "Direction1D",
	type: "number",
}
export type Direction2DType = {
	Name: "Direction2D",
	type: "Vector2",
}
export type InputActionType = BoolType | Direction1DType | Direction2DType

-- When Input.new()
export type Context = {
	Name: string,
	Priority: number,
	Sink: boolean,
	Enabled: boolean,

	-- AddAction: <T>(self: Context, name: string, type: T & InputActionType) -> Action<T>,
	AddAction: (<T>(self: Context, name: string, type: T & BoolType) -> ActionBool<T & BoolType>) & (<T>(
		self: Context,
		name: string,
		type: T & Direction1DType
	) -> ActionDirection1D<T & Direction1DType>) & (<T>(
		self: Context,
		name: string,
		type: T & Direction2DType
	) -> ActionDirection2D<T & Direction2DType>),

	_context: InputContext,
}

-- types of "Actions"
export type Action<T = any> = {
	Name: string,
	Enabled: boolean,
	Type: T,

	Fire: (self: Action<T>, newState: T) -> (),
	GetState: (self: Action<T>) -> T,

	StateChanged: Signal.event<(T), ()>,

	_signal: Signal.newSignal<(T), ()>,
	_state: T,
	_bindings: { Binding },
	_instance: InputAction,
}

export type ActionBool<T> = Action<boolean> & {
	Enabled: boolean,
	Type: T & BoolType,

	AddBinding: (self: ActionBool<T>, KeyCode: Enum.KeyCode, Scale: number) -> Binding<T>,

	Pressed: Signal.event<>, -- when state transitions from false to true
	Released: Signal.event<>, -- when state transitions from true to false
}

export type ActionDirection1D<T> = Action<number> & {
	Enabled: boolean,
	Type: T & Direction1DType,

	AddBinding: (
		self: ActionDirection1D<T>,
		KeyCode: Enum.KeyCode,
		Scale: number,
		CompositeDirections: {
			Up: Enum.KeyCode,
			Down: Enum.KeyCode,
		}
	) -> Binding<T> & {
		Down: Enum.KeyCode,
		Up: Enum.KeyCode,
	},
}

export type ActionDirection2D<T> = Action<Vector2> & {
	Enabled: boolean,
	Type: T & Direction2DType,

	AddBinding: (
		self: ActionDirection2D<T>,
		KeyCode: Enum.KeyCode,
		Scale: number,
		CompositeDirections: {
			Up: Enum.KeyCode,
			Down: Enum.KeyCode,
			Right: Enum.KeyCode,
			Left: Enum.KeyCode,
		}
	) -> Binding<T> & {
		Up: Enum.KeyCode,
		Down: Enum.KeyCode,
		Right: Enum.KeyCode,
		Left: Enum.KeyCode,
	},
}

-- Binding class
export type Binding<T = InputActionType> = {
	Name: string,
	Type: T,

	KeyCode: Enum.KeyCode,
	Scale: number,

	_instance: InputBinding,
}

--[[ test type
local input: Input
local context = input.new("my input")

local moveAction = context:AddAction("move", input.InputActionType.Direction2D)
moveAction:AddBinding(Enum.KeyCode.A, 1, {
	Up = Enum.KeyCode.A,
	Down = Enum.KeyCode.Right,
	Left = Enum.KeyCode.A,
	Right = Enum.KeyCode.A,
})
moveAction:Fire(Vector2.new(1, 1))
 ]]
return Types
