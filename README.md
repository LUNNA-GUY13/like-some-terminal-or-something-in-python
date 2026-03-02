# like-some-terminal-or-something-in-python
This  ̶**~~python script~~** A REVOUTLUTIONARY cmd that allows for modding using lua! So yeah instead of modding a video game you will play for 100 hours mod this **~~shit~~** ̶ this technology :) - thanking ted for calling me to TEDtalk. 

# HELLO GITHUB.COM USER
THIS IS THE BEST CMD YOU'LL EVER FIND  NOT JUST A .PY FILE
# IF YOU WANT TO USE IT AND DON'T HAVE THESE LIBARIES
`pip install rich lupa prompt_toolkit`
## AND IF YOU WANT TO COMPLIE THIS INTO A .EXE/.DLL
`pip install pyinstaller`

# THE DOCS OR SOMETHING
## the built in vanilla commands!!

|**Commands**| **the thing it does** |
|--|--|
| help | it shows all modded commands |
| plugloader| it loads and reloads the mods/plugins|
| theme| changes color it's amazing|

### we can make mods with Lua and Plugins(smaller mods) with json

**sample json plugin** 
    `{"command": "hi", "action": "echo hi"}`


**sample lua mod**
`lua`

        return function(kernel)
            return {
                command = "hello",
                run = function(name)
                    -- Fallback for name argument
                    local user = name or "User"
                    
                    -- Accessing the Python kernel's settings directly
                    local current_theme = kernel.settings.theme or "default"
                    
                    -- Using the Python 'rich' console for consistent styling
                    kernel.console.print("[bold green]Hello, " .. user .. "![/]")
                    kernel.console.print("[dim]The system is currently running the [bold]" .. current_theme .. "[/] theme.[/]")
                    
                    -- Proof of bridge: manipulating shared data
                    if not kernel.shared.greet_count then kernel.shared.greet_count = 0 end
                    kernel.shared.greet_count = kernel.shared.greet_count + 1
                    
                    kernel.console.print("[cyan]Total greets this session: [/]" .. kernel.shared.greet_count) ### **Building Your Own Mod**

# **Building Your Own Mod**

Creating a mod is just writing a Lua function that returns a table.

1.  **`command`**: This is what you type into the shell.
    
2.  **`run`**: This is the logic. You get full access to the `kernel` object, which includes:
    
    -   `kernel.console`: The Python `rich` console.
        
    -   `kernel.settings`: Data from `settings.json`.
        
    -   `kernel.shared`: A temporary table to store data between different mods
***

    HELLO WHY THE FUCK DID YOU READ THE WHOLE README LIKE ARE YOU   JOBLESS?

***
