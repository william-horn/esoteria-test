--!strict

export type Any = { [any]: any }

export type AnyArray = { [number]: any }
export type NumberArray = { [number]: number }
export type StringArray = { [number]: string }
export type InstanceArray = { [number]: Instance }
export type Array2D = { [number]: AnyArray }
export type ObjectArray = { [number]: Any }

export type StringKey = { [string]: any }
export type InstanceKey = { [Instance]: any }

return nil
