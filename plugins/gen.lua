return function(kernel)
    return {
        command = "gen",
        run = function(template_type, name)
            if not template_type or not name then
                kernel.console.print("[yellow]Usage:[/] gen [theme|cmd|logic] [mod_name]")
                return
            end

            local filename = "plugins/" .. name .. ".lua"
            local content = ""

            -- 1. THEME MOD TEMPLATE
            if template_type == "theme" then
                content = [[return function(kernel)
    return {
        command = "]] .. name .. [[",
        run = function(color_code)
            if not color_code then 
                print("Usage: ]] .. name .. [[ [color_name]")
                return 
            end
            kernel.settings.theme_color = color_code
            kernel.console.print("[bold " .. color_code .. "]Theme updated to " .. color_code .. "![/]")
        end
    }
end]]

            -- 2. COMMAND/UTILITY MOD TEMPLATE
            elseif template_type == "cmd" then
                content = [[return function(kernel)
    return {
        command = "]] .. name .. [[",
        run = function(...)
            local args = {...}
            kernel.console.print("[bold cyan]Executing ]] .. name .. [[...[/]")
            for i, v in ipairs(args) do
                print("Arg " .. i .. ": " .. v)
            end
        end
    }
end]]

            -- 3. LOGIC/SYSTEM MOD TEMPLATE (Shared Data Access)
            elseif template_type == "logic" then
                content = [[return function(kernel)
    return {
        command = "]] .. name .. [[",
        run = function()
            -- Accessing the shared data pool
            local count = (kernel.shared.run_count or 0) + 1
            kernel.shared.run_count = count
            kernel.console.print("[green]This mod has been run " .. count .. " times this session.[/]")
        end
    }
end]]
            end

            -- Write the file using Lua's native IO
            local f = io.open(filename, "w")
            if f then
                f:write(content)
                f:close()
                kernel.console.print("[bold green]✔ Generated " .. template_type .. " mod:[/] " .. filename)
                kernel.console.print("[dim]Run 'plugloader' to activate it.[/]")
            else
                kernel.console.print("[bold red]✗ Error:[/] Could not write to " .. filename)
            end
        end
    }
end