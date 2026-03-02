return function(kernel)
    return {
        command = "forge",
        run = function(mode, target_file, ...)
            if not mode or not target_file then
                kernel.console.print("[yellow]Usage:[/] forge [exe|dll|windowed] [file.py]")
                kernel.console.print("[dim]Note: 'forge exe self' will compile the current shell.[/]")
                return
            end

            -- Handle the "self" keyword to compile the running script
            local target = target_file
            if target == "self" then
                target = python.eval("os.path.abspath(sys.argv[0])")
            end

            kernel.console.print("[bold cyan]🔨 Forging: [/]" .. target .. " [dim](" .. mode .. ")[/]")

            local cmd = ""
            if mode == "exe" then
                -- Single file executable
                cmd = "pyinstaller --onefile --noconfirm " .. target
            elseif mode == "windowed" then
                -- Executable without a console window
                cmd = "pyinstaller --onefile --noconvirm --noconsole " .. target
            elseif mode == "dll" then
                -- Compiling to a shared library (Requires Nuitka for true DLLs, 
                -- or we use PyInstaller's directory mode)
                cmd = "pyinstaller --onedir --noconfirm " .. target
                kernel.console.print("[yellow]Notice: DLL mode currently generates a shared distribution folder.[/]")
            end

            -- Execute the forge process
            kernel.console.print("[bold yellow]⚡ Process started. This may take a minute...[/]")
            
            -- We use os.execute to let the user see the compilation progress in real-time
            local success = os.execute(cmd)

            if success then
                kernel.console.print("\n[bold green]✔ Forge Complete![/] Check the [bold]dist/[/] folder.")
            else
                kernel.console.print("\n[bold red]✗ Forge Failed.[/] Ensure 'pyinstaller' is installed.")
            end
        end
    }
end