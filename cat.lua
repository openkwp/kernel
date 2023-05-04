local thread = fs.open("cat.lua")
file = fs.read(thread, fs.size("cat.lua"))
fs.close(thread)
lines = {}
for s in string.gmatch(file, "[^\n]+") do
    gpu.set(1, cursor.y, s)
    cursor.y = cursor.y + 1
end