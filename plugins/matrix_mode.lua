return function(kernel)
    return {
        command = "matrix_mode",
        run = function(color_code)
            if not color_code then 
                print("Usage: matrix_mode [color_name]")
                return 
            end
            kernel.settings.theme_color = color_code
            kernel.console.print("[bold " .. color_code .. "]Theme updated to " .. color_code .. "![/]")
        end
    }
end