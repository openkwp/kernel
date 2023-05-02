fs = component.proxy(component.invoke(component.list("eeprom")(), "getData"))

local thread = fs.open("/sh.lua", "r")
if thread == nil then
    error("kernel panic: can't access sh.lua")
end
local file = fs.read(thread, fs.size("/sh.lua"))
if file == nil then
    error("kernel panic: can't read sh.lua")
end
local file2 = fs.read(thread, fs.size("/sh.lua"))
if file ~= nil then
    file = file .. file2
end
local filestring, reason = load(file)
if filestring == nil then
    error("kernel panic: syntax error in sh.lua: " .. reason)
end
local status, reason = pcall(filestring)
if status == false then
    error("kernel panic: sh.lua: " .. reason)
end
fs.close(thread)
computer.shutdown()
