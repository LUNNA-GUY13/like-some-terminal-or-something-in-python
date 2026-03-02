return function(kernel)
    return {
        command = "scribe",
        run = function(mode, filename, ...)
            local content = table.concat({...}, " ")
            
            if not mode or not filename then
                kernel.console.print("[yellow]Usage:[/] scribe [new|add|read] [filename] [\"content\"]")
                return
            end

            if mode == "new" then
                local f = io.open(filename, "w")
                if f then
                    f:write(content)
                    f:close()
                    kernel.console.print("[bold green]✔ File Created:[/] " .. filename)
                else
                    kernel.console.print("[bold red]✗ Error:[/] Could not create file.")
                end

            elseif mode == "add" then
                local f = io.open(filename, "a")
                if f then
                    f:write("\n" .. os.date("[%Y-%m-%d %H:%M:%S] ") .. content)
                    f:close()
                    kernel.console.print("[bold cyan]➕ Content Appended to:[/] " .. filename)
                else
                    kernel.console.print("[bold red]✗ Error:[/] File not found.")
                end

            elseif mode == "read" then
                local f = io.open(filename, "r")
                if f then
                    local body = f:read("*all")
                    f:close()
                    
                    -- FIX: Access Panel from Python via the kernel bridge
                    -- FIX: Use a Lua table {} to pass named arguments (kwargs)
                    local p = python.eval("Panel")(body, {title=filename, border_style="dim"})
                    kernel.console.print(p)
                else
                    kernel.console.print("[bold red]✗ Error:[/] Could not read " .. filename)
                end
            end
        end
    }
end