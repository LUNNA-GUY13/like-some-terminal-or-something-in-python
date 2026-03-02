return function(kernel)
    return {
        command = "alias",
        run = function(name, ...)
            local cmd_to_run = table.concat({...}, " ")
            
            if not name or not cmd_to_run then
                kernel.console.print("[yellow]Usage:[/] alias [name] [full command]")
                return
            end

            -- We inject a NEW JSON-style plugin directly into the Kernel's memory
            -- This proves we don't need to edit the core to expand the command list
            kernel.json_plugins[name] = {
                command = name,
                action = cmd_to_run
            }

            kernel.console.print("[bold green]✔ Alias Created:[/] '" .. name .. "' now runs '" .. cmd_to_run .. "'")
        end
    }
end