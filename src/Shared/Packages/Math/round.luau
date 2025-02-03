--!strict

local pow = math.pow

local function roundToNth(n: number, nth: number)
	local factor: number = pow(10, nth)
	return math.floor(n * factor + 0.5) / factor
end

local function roundToInt(n: number)
	return math.floor(n + 0.5)
end

local function roundTenth(n: number)
	return math.floor(n * 10 + 0.5) / 10
end

local function roundHundreth(n: number)
	return math.floor(n * 100 + 0.5) / 100
end

local function roundThousanth(n: number)
	return math.floor(n * 1000 + 0.5) / 1000
end

return {
	roundToNth = roundToNth,
	roundHundreth = roundHundreth,
	roundThousanth = roundThousanth,
	roundToInt = roundToInt,
	roundTenth = roundTenth,
}
