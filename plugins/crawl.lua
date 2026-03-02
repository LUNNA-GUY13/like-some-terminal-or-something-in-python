return function(kernel)
    return {
        command = "crawl",
        run = function(query, start_dir)
            local search_path = start_dir or "."
            if not query then
                kernel.console.print("[yellow]Usage: crawl [filename/ext] [optional_path][/]")
                return
            end

            kernel.console.print("[bold magenta] Crawling for: [/]" .. query .. " in " .. search_path)
            
            -- Using a cross-platform command to list files recursively
            local cmd = (package.config:sub(1,1) == "\\") 
                and "dir /s /b " .. search_path .. " | findstr " .. query
                or "find " .. search_path .. " -name '*" .. query .. "*'"

            local handle = io.popen(cmd)
            local result = handle:read("*a")
            handle:close()

            if result == "" then
                kernel.console.print("[red]✗ No matches found.[/]")
            else
                kernel.console.print("[green]✔ Matches found:[/]")
                kernel.console.print(result)
            end
        end
    }
end