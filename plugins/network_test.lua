return function(kernel)
    return {
        command = "network_test",
        run = function(...)
            local args = {...}
            kernel.console.print("[bold cyan]Executing network_test...[/]")
            for i, v in ipairs(args) do
                print("Arg " .. i .. ": " .. v)
            end
        end
    }
end