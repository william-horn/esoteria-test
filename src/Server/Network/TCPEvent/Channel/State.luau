export type State = {
	timesFired: number | (prev: any) -> any,
	[any]: nil,
}

return {
	timesFired = 0,
} :: State
