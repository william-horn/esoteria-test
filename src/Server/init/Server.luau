local Shared = game.ReplicatedStorage.Shared
local Packages = Shared.Packages

local splitWith = require(Packages.String.Util.splitWith)
local StringEscaper = require(Packages.String.Classes.StringEscaper)

local Escaper: StringEscaper.StringEscaper = StringEscaper.new("/", { "$", "^" })
Escaper:remove("^")
Escaper:add("^")

local esc = Escaper:escape("Hello /$world /^thing ok?")
print(esc)

print(Escaper:unescape(esc))

return true
