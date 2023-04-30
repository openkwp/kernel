local thread = fs.open("cat.lua")
file = fs.read(thread, fs.size("cat.lua"))
fs.close(thread)
lines = {}
for s in string.gmatch(file, "[^\n]+") do
    table.insert(lines, s)
end
for i in pairs(lines) do
    gpu.set(1, cursor.y, tostring(i))
    cursor.y = cursor.y + 1
end