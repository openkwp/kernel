gpu = component.proxy(component.list("gpu")())

cursor = {
    x = 3,
    y = 1,
    oldx = 3,
    oldy = 1
}

local errorn = 0

function redrawCursor()
    gpu.set(cursor.oldx, cursor.oldy, table.pack(gpu.get(cursor.oldx, cursor.oldy))[1])
    gpu.setForeground(0x000000)
    gpu.setBackground(0xFFFFFF)
    gpu.set(cursor.x, cursor.y, " ")
    gpu.setForeground(0xFFFFFF)
    gpu.setBackground(0x000000)
    cursor.oldx, cursor.oldy = cursor.x, cursor.y
end

local function errorHandler(text)
    errorn = errorn + 1
    gpu.set(cursor.x, cursor.y, "sh: " .. errorn .. ": " .. command .. ": " .. text)
end

function start()
    local thread = fs.open(command)
    if thread == nil then
        errorHandler("not found")
        return
    end
    local file = fs.read(thread, fs.size(command))
    if file == nil then
        errorHandler("permission denied")
        return
    end
    local callable, reason = load(file)
    if callable == false then
        errorHandler("syntax error: " .. reason)
    end
    local status, reason = pcall(callable)
    if status == false then
        errorHandler(reason)
    end
    fs.close(thread)
end

command = ""

x, y = gpu.getResolution()
gpu.fill(1, 1, x, y, " ")
gpu.set(1, 1, "# ")
while(true) do
    redrawCursor()
    local signal = table.pack(computer.pullSignal(1))
    if signal[1] ~= nil then
        if signal[1] == 'key_down' then
            if signal[3] == 8 then
                if command ~= "" then
                    gpu.set(cursor.oldx, cursor.oldy, " ")
                    command = unicode.sub(command, 1, unicode.len(command) - 1)
                    cursor.x = cursor.x - 1
                end
            elseif signal[3] == 13 then
                cursor.x, cursor.y = 1, cursor.y + 1
                redrawCursor()

                start()
                
                command = ""
                cursor.x, cursor.y = 3, cursor.y + 1
                gpu.set(1, cursor.y, "# ")
                redrawCursor()
            else
                gpu.set(cursor.x, cursor.y, unicode.char(signal[3]))
                command = command .. unicode.char(signal[3])
                cursor.x = cursor.x + 1
            end
        end
    end
end
