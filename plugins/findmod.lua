return function(kernel)
    return {
        command = "find",
        run = function(query)
            if not query or query == "" then 
                kernel.console.print("[yellow]Usage: find [query][/]")
                return 
            end
            
            kernel.console.print("[bold magenta] Searching Registry for: [/]" .. query)
            local found = false

            -- Search JSON Plugins
            for cmd, data in pairs(kernel.json_plugins) do
                if string.find(tostring(cmd):lower(), tostring(query):lower()) then
                    local action = data.action or "no action"
                    kernel.console.print("[cyan]JSON > [/][bold]" .. cmd .. "[/] : [dim]" .. action .. "[/]")
                    found = true
                end
            end

            -- Search Lua Mods
            for cmd, _ in pairs(kernel.lua_mods) do
                if string.find(tostring(cmd):lower(), tostring(query):lower()) then
                    kernel.console.print("[green]LUA  > [/][bold]" .. cmd .. "[/]")
                    found = true
                end
            end

            if not found then
                kernel.console.print("[red]✗ No mods matching '[/]" .. query .. "[red]' found.[/]")
            end
        end
    }
end