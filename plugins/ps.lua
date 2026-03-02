return function(kernel)
    return {
        command = "ps",
        run = function(...)
            local ps_cmd = table.concat({...}, " ")
            if ps_cmd == "" then return end

            kernel.console.print("[bold blue]PS == [/][dim]" .. ps_cmd .. "[/]")
            
            local handle = io.popen('powershell -NoProfile -Command "' .. ps_cmd .. '"')
            local result = handle:read("*a")
            handle:close()

            if result and result ~= "" then
                -- FIX: Import Panel directly through the bridge so it's never 'None'
                local Panel = python.import("rich.panel").Panel
                local p = Panel(result, {title="PowerShell Output", border_style="blue"})
                kernel.console.print(p)
            end
        end
    }
end