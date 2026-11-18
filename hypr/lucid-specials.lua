-- written by Lucid Settings > Workspaces, and rewritten on every change there
return {
    keep = true,
    hide_on_switch = false,
    dim = 0.2,
    blur = false,
    gaps = 0,
    workspaces = {
        special = { enabled = true, apps = {} },
        music = { enabled = true, apps = {
            { name = "Red", cmd = "exec '/usr/bin/flatpak' 'run' '--branch=stable' '--arch=x86_64' '--command=red' '--file-forwarding' 'com.ktechpit.red' '@@u' '@@'", class = { "com.ktechpit.red", "red" } },
        } },
        comms = { enabled = true, apps = {
            { name = "ZapFast", cmd = "exec 'zapfast'", class = { "zapfast" } },
        } },
        todo = { enabled = true, apps = {
            { name = "Planify", cmd = "exec '/usr/bin/flatpak' 'run' '--branch=stable' '--arch=x86_64' '--command=io.github.alainm23.planify' '--file-forwarding' 'io.github.alainm23.planify' '@@u' '@@'", class = { "io.github.alainm23.planify" } },
        } },
        sysmon = { enabled = true, apps = {
            { name = "btop", cmd = "if command -v kitty >/dev/null 2>&1; then exec kitty --class 'lucid.btop' -e 'btop'; elif command -v foot >/dev/null 2>&1; then exec foot --app-id='lucid.btop' 'btop'; elif command -v alacritty >/dev/null 2>&1; then exec alacritty --class 'lucid.btop' -e 'btop'; elif command -v ghostty >/dev/null 2>&1; then exec ghostty --class='lucid.btop' -e 'btop'; fi", class = { "lucid.btop" } },
        } },
    },
}
