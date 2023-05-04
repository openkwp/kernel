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

local f, reason = load(file)
if f == nil then
    error("kernel panic: syntax error in " .. shell .. ": " .. reason)
end

local callable = coroutine.create(f)

while coroutine.status(callable) ~= "dead" do
    local status, reason = coroutine.resume(callable)
    if status == false then
        error("kernel panic: " .. shell .. ": " .. reason)
    end
end
computer.shutdown()
