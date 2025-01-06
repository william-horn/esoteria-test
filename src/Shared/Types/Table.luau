--!strict

type AnyTable = { [any]: any }

export type Any = AnyTable

export type AnyArray = { any }
export type NumberArray = { number }
export type StringArray = { string }
export type FunctionArray = { (...any) -> ...any }
export type InstanceArray = { Instance }
export type Array2D = { AnyArray }
export type ObjectArray = { AnyTable }

export type StringKey = { [string]: any }
export type InstanceKey = { [Instance]: any }

export type Class = {
	__index: AnyTable,
	[string]: any,
}

return nil
