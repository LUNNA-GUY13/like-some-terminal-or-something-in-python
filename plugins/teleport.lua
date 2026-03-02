return function(kernel)
    return {
        command = "jump",
        run = function(action, name)
            -- Use the kernel's shared data pool to persist bookmarks
            kernel.shared.bookmarks = kernel.shared.bookmarks or {}

            if action == "add" and name then
                local cwd = os.getenv("PWD") or io.popen("cd"):read("*l")
                kernel.shared.bookmarks[name] = cwd
                kernel.console.print("[bold green]✔ Bookmark saved:[/] " .. name .. " -> " .. cwd)
            
            elseif action == "to" and name then
                local target = kernel.shared.bookmarks[name]
                if target then
                    os.execute("cd " .. target) -- Note: Shell context changes vary by OS
                    kernel.console.print("[bold cyan]🚀 Teleported to:[/] " .. target)
                else
                    kernel.console.print("[bold red]✗ Error:[/] Bookmark '" .. name .. "' not found.")
                end
            
            else
                kernel.console.print("[yellow]Usage:[/] jump add [name] | jump to [name]")
            end
        end
    }
end