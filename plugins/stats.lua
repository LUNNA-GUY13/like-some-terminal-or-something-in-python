return function(kernel)
    return {
        command = "stats",
        run = function()
            -- Accessing the shared data pool
            local count = (kernel.shared.run_count or 0) + 1
            kernel.shared.run_count = count
            kernel.console.print("[green]This mod has been run " .. count .. " times this session.[/]")
        end
    }
end