--!strict

type AnyTable = { [any]: any }

export type Any = (...any) -> any

export type String = (...string) -> string
export type Number = (...number) -> number
export type Table = (...AnyTable) -> AnyTable

export type StringResult = (...any) -> string
export type NumberResult = (...any) -> number
export type BooleanResult = (...any) -> boolean
export type TableResult = (...any) -> AnyTable

return nil
