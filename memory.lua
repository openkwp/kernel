gpu.set(1, cursor.y, "Total " .. string.format("%.0f", tostring(computer.totalMemory() / 1024)) .. " KB")
cursor.y = cursor.y + 1
gpu.set(1, cursor.y, "Used " .. string.format("%.0f", tostring((computer.totalMemory() - computer.freeMemory()) / 1024)) .. " KB")
cursor.y = cursor.y + 1
gpu.set(1, cursor.y, "Free " .. string.format("%.0f", tostring(computer.freeMemory() / 1024)) .. " KB")