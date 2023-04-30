gpu.fill(1, 1, x, y, " ")
cursor.x, cursor.y = 0, 0
gpu.setForeground(0x000000)
gpu.setBackground(0xFFFFFF)
while(true) do
    local signal = table.pack(computer.pullSignal(1))
    if signal[1] ~= nil then
        if signal[1] == 'key_down' then
            if singal[3] == 13 then
                return true
            end
        elseif signal[1] == 'touch' or signal[1] == 'drag' then
            gpu.set(signal[3], signal[4], " ")
        end
    end
end