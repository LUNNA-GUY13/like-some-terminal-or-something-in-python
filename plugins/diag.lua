return function(kernel)
    local log_file = "logs.txt"

    -- Injection: Ensure the kernel has a way to store transient session errors too
    if python.eval("not hasattr(kernel, 'error_log')") then
        python.eval("setattr(kernel, 'error_log', [])")
    end

    return {
        command = "diag",
        run = function(action, ...)
            local args = {...}
            local message = table.concat(args, " ")

            -- 1. ACTION: ADD (The Manual Reporter)
            -- Usage: diag add "Something happened"
            if action == "add" then
                local f = io.open(log_file, "a")
                if f then
                    local timestamp = os.date("%Y-%m-%d %H:%M:%S")
                    f:write("[" .. timestamp .. "] " .. message .. "\n")
                    f:close()
                    kernel.console.print("[bold green]✔ Incident recorded to black box.[/]")
                end

            -- 2. ACTION: CLEAR
            -- Usage: diag clear
            elseif action == "clear" then
                local f = io.open(log_file, "w")
                if f then f:close() end
                python.eval("kernel.error_log.clear()")
                kernel.console.print("[bold red]✔ All logs (file and session) wiped clean.[/]")

            -- 3. DEFAULT: VIEW (The Reporting Station)
            -- Usage: diag
            else
                kernel.console.print("[bold magenta]--- LUNNA BS SYSTEM LOGS ---[/]")
                
                -- Check for physical log file
                local f = io.open(log_file, "r")
                if f then
                    for line in f:lines() do
                        -- Semantic Highlighting
                        local lower_line = line:lower()
                        if string.find(lower_line, "error") or string.find(lower_line, "crash") or string.find(lower_line, "failed") then
                            kernel.console.print("[bold red]![/] " .. line)
                        elseif string.find(lower_line, "warn") or string.find(lower_line, "quirk") then
                            kernel.console.print("[bold yellow]?[/] " .. line)
                        elseif string.find(lower_line, "pokemon") then
                            kernel.console.print("[bold magenta]◓[/] " .. line) -- Special quirk for your test!
                        else
                            kernel.console.print("[bold cyan]i[/] " .. line)
                        end
                    end
                    f:close()
                else
                    kernel.console.print("[dim]  No logs exist. The horizon is clear.[/]")
                end

                -- Also show transient session errors that haven't been saved to disk yet
                local session_errs = python.eval("len(kernel.error_log)")
                if session_errs > 0 then
                    kernel.console.print("\n[bold yellow]--- Unsaved Session Errors ---[/]")
                    for i = 0, session_errs - 1 do
                        kernel.console.print("[red]✗[/] " .. tostring(kernel.error_log[i]))
                    end
                end

                kernel.console.print("[bold magenta]----------------------------[/]")
            end
        end
    }
end