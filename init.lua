fs = component.proxy(component.invoke(component.list("eeprom")(), "getData"))
local shell = "sh.lua"

local thread = fs.open(shell, "r")
if thread == nil then
    error("kernel panic: can't access " .. shell)
end
local file, chunk = ""
while true do
    chunk = fs.read(thread, math.huge)
    
    if chunk ~= nil then
        file = file .. chunk
    else
        break
    end
end
fs.close(thread)

local callable, reason = load(file)
if callable == nil then
    error("kernel panic: syntax error in " .. shell .. ": " .. reason)
end

local status, reason = pcall(callable)
if status == false then
    error("kernel panic: " .. shell .. ": " .. reason)
end
computer.shutdown()
