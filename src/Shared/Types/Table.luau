--!strict

export type Any = { [any]: any }

export type AnyArray = { any }
export type NumberArray = { number }
export type StringArray = { string }
export type FunctionArray = { (...any) -> ...any }
export type InstanceArray = { Instance }
export type Array2D = { AnyArray }
export type ObjectArray = { Any }

export type StringKey = { [string]: any }
export type InstanceKey = { [Instance]: any }

return nil
