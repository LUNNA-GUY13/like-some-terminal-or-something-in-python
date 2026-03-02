return function(kernel)
    return {
        command = "run",
        run = function(filename)
            if not filename then
                kernel.console.print("[bold yellow]Lunna LSC Runner[/] | v1.0-Shitpost")
                kernel.console.print("Usage: run [script.lsc]")
                return
            end

            -- Extension safety
            if not string.find(filename, "%.lsc$") then filename = filename .. ".lsc" end
            
            local f = io.open(filename, "r")
            if not f then
                kernel.console.print("[bold red]ERROR:[/] Script not found. Check your 'plugins' folder.")
                return
            end

            -- Connect to the Python engine directly
            -- Based on your op.py, the function is process_input
            local engine = python.eval("process_input") 

            kernel.console.print("[bold magenta] DEPLOYING LSC:[/][white] " .. filename .. "[/]")

            for line in f:lines() do
                -- Clean whitespace
                local cmd = line:gsub("^%s*(.-)%s*$", "%1")
                
                -- THE SHIELD: Skip comments, empty lines, and those pesky log timestamps 
                if cmd ~= "" and not cmd:match("^%[") and not cmd:match("^#") then
                    kernel.console.print("[cyan]=> [/]" .. cmd)
                    
                    local success, err = pcall(function() 
                        engine(cmd) 
                    end)

                    if not success then
                        kernel.console.print("[bold red]CRASHED:[/] " .. tostring(err))
                    end
                end
            end
            f:close()
            kernel.console.print("[bold green]✔ LSC Sequence Complete.[/]")
        end
    }
end