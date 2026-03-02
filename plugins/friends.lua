return function(kernel)
    return {
        command = "friend",
        run = function(action, ...)
            local sub_args = {...}
            
            if not action then
                kernel.console.print("[bold green]Hey User![/]")
                kernel.console.print("[cyan]I'm here to help. Try 'friend status' or 'friend tips'![/]")
                return
            end

            if action == "status" then
                -- FIX: Use kernel.lua_mods.values() or similar if pairs fails
                -- For a quick fix, we just try to get the length through a Python helper
                local mod_count = python.eval("len")(kernel.lua_mods)
                local plug_count = python.eval("len")(kernel.json_plugins)
                
                kernel.console.print("[bold magenta]Friend Diagnostics:[/]")
                kernel.console.print("  [cyan]Lua Mods Loaded:[/] " .. tostring(mod_count))
                kernel.console.print("  [cyan]JSON Plugins Loaded:[/] " .. tostring(plug_count))
                kernel.console.print("  [cyan]Current Mood:[/] [yellow]Slightly buggy but loyal[/]")
            
            elseif action == "tips" then
                kernel.console.print("[italic green][/]if you want tips on this just read the README.md or idk read python it's bascailly english OR just ask the dev[/]")
                kernel.console.print("[italic red][/] i am text on on screen and i have no idea what im doing but im here to help you with your mods and plugins and stuff so just ask if you need help or read the docs or something[/]")

            end
        end
    }
end