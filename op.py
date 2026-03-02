import os, shlex, subprocess, sys, json, time
from prompt_toolkit import PromptSession
from prompt_toolkit.styles import Style
from prompt_toolkit.completion import WordCompleter

# The Visual Engine
from rich import print as rprint
from rich.table import Table
from rich.panel import Panel
from rich.console import Console
from rich.progress import Progress, SpinnerColumn, TextColumn, BarColumn, TaskProgressColumn

# Advanced Modding Support (Lua)
try:
    from lupa import LuaRuntime
    LUA_ENABLED = True
except ImportError:
    LUA_ENABLED = False

class LunnaKernel:
    def __init__(self):
        self.dir = "plugins"
        self.console = Console()
        self.json_plugins = {}
        self.lua_mods = {}
        self.shared = {} 
        self.settings = self.load_cfg()
        self.lua = LuaRuntime(unpack_returned_tuples=True) if LUA_ENABLED else None
        
        if not os.path.exists(self.dir): os.makedirs(self.dir)

    def load_cfg(self):
        if os.path.exists("settings.json"):
            with open("settings.json", "r") as f: return json.load(f)
        return {"theme": "default"}

    def save_cfg(self):
        with open("settings.json", "w") as f:
            json.dump(self.settings, f)

    def sync(self):
        self.json_plugins.clear()
        self.lua_mods.clear()
        files = [f for f in os.listdir(self.dir) if f.endswith(('.json', '.lua'))]
        
        with Progress(SpinnerColumn(), TextColumn("[bold cyan]Syncing Registry: {task.description}"), BarColumn(), transient=True) as progress:
            task = progress.add_task("Loading...", total=len(files) if files else 1)
            for file in files:
                path = os.path.join(self.dir, file)
                if file.endswith(".json"):
                    try: 
                        with open(path, 'r', encoding='utf-8') as f:
                            data = json.load(f)
                            self.json_plugins[data['command']] = data
                    except: pass
                elif file.endswith(".lua") and LUA_ENABLED:
                    try:
                        with open(path, 'r') as f:
                            mod_constructor = self.lua.execute(f.read())
                            mod = mod_constructor(self) 
                            self.lua_mods[mod['command']] = mod
                    except Exception as e: rprint(f"[red]Lua Error ({file}): {e}[/]")
                progress.advance(task)
                time.sleep(0.05) # Visual polish
        return len(self.json_plugins) + len(self.lua_mods)

kernel = LunnaKernel()

# ----------------------------------------------------
# UI RENDERING
# ----------------------------------------------------

def show_welcome():
    os.system('cls' if os.name == 'nt' else 'clear')
    
    # THEMES RE-INTEGRATED
    THEME_MAP = {
        "default": "cyan",
        "matrix": "green",
        "cyberpunk": "magenta",
        "ghost": "white"
    }
    color = THEME_MAP.get(kernel.settings.get('theme'), "cyan")

    # THE 2-HOUR ASCII MASTERPIECE (RESTORED)
    logo = f"""
[bold {color}]
      :::        :::    ::: ::::    ::: ::::    :::     :::     
      :+:        :+:    :+: :+:+:   :+: :+:+:   :+:   :+: :+:   
     +:+        +:+    +:+ :+:+:+  +:+ :+:+:+  +:+  +:+   +:+  
    +#+        +#+    +:+ +#+ +:+ +#+ +#+ +:+ +#+ +#++:++#++: 
   +#+        +#+    +:+ +#+  +#+#+# +#+  +#+#+# +#+     +#+ 
  #+#        #+#    #+# #+#   #+#+# #+#   #+#+# #+#     +#+ 
##########  ########  ###    #### ###    #### ###     ### 
[/][bold white]            >-- LUNNA UNLIMITED BASE SYSTEM v1(shit post demo)--< [/]
"""
    rprint(logo)
    
    # STATUS PANEL
    lua_status = "[bold green]ONLINE[/]" if LUA_ENABLED else "[bold red]OFFLINE (lupa missing)[/]"
    status_grid = f"Theme: [bold {color}]{kernel.settings['theme']}[/] | Lua Engine: {lua_status} | Registry: [bold cyan]{len(kernel.json_plugins) + len(kernel.lua_mods)}[/] mods"
    rprint(Panel(status_grid, border_style=f"bright_{color}", expand=False))

def process_input(text):
    if not text: return
    clean_text = text.split("#")[0].strip()
    if not clean_text: return
    
    parts = shlex.split(clean_text)
    cmd, args = parts[0].lower(), parts[1:]

    # Priority 1: Lua Mods (Unlimited Access)
    if cmd in kernel.lua_mods:
        try: kernel.lua_mods[cmd]['run'](*args)
        except Exception as e: rprint(f"[bold red]Mod Crash:[/] {e}")
    
    # Priority 2: JSON Plugins
    elif cmd in kernel.json_plugins:
        rprint(f"[italic dim]Executing JSON Plugin: {cmd}...[/]")
        subprocess.run(kernel.json_plugins[cmd]['action'], shell=True)

    # Priority 3: Built-ins
    elif cmd == "theme":
        if args and args[0] in ["default", "matrix", "cyberpunk", "ghost"]:
            kernel.settings['theme'] = args[0]
            kernel.save_cfg()
            show_welcome()
            rprint(f"[bold green]✔ Theme persistent: {args[0]}[/]")
        else:
            rprint("[yellow]Themes: default, matrix, cyberpunk, ghost[/]")

    elif cmd == "plugloader":
        count = kernel.sync()
        rprint(f"[bold green]✔ Registry Re-synced ({count} active).[/]")

    elif cmd == "help":
        table = Table(title="Lunna command Registry", border_style="bold magenta")
        table.add_column("Command", style="cyan")
        table.add_column("Type", style="green")
        table.add_column("Access", style="yellow")
        
        for c in kernel.lua_mods: table.add_row(c, "LUA MOD", "UNLIMITED")
        for c in kernel.json_plugins: table.add_row(c, "JSON PLUGIN", "RESTRICTED")
        rprint(table)

    elif cmd == "clear": show_welcome()
    elif cmd == "exit": sys.exit()
    else:
        # Standard OS Fallback
        subprocess.run(clean_text, shell=True)

# ----------------------------------------------------
# MAIN EXECUTION
# ----------------------------------------------------
def main():
    kernel.sync()
    show_welcome()
    
    # Setup prompt styling
    THEME_COLORS = {
        "default": ("ansicyan", "ansiyellow"),
        "matrix": ("ansigreen", "ansigreen"),
        "cyberpunk": ("ansimagenta", "ansicyan"),
        "ghost": ("ansiwhite", "ansiwhite")
    }

    while True:
        try:
            t_set = THEME_COLORS.get(kernel.settings['theme'], THEME_COLORS['default'])
            style = Style.from_dict({
                'host': f"{t_set[0]} bold",
                'arrow': t_set[1],
            })
            
            cwd = os.getcwd().split(os.sep)[-1] or "root"
            prompt = [('class:host', 'lunna'), ('', f' [{cwd}] '), ('class:arrow', '❯ ')]
            
            session = PromptSession(style=style)
            text = session.prompt(prompt)
            process_input(text)
        except (KeyboardInterrupt, EOFError): break

if __name__ == "__main__":
    main()