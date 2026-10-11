return {
   default_prog = { 'pwsh.exe' },
   launch_menu = {
      { label = 'PowerShell 7', args = { 'pwsh.exe' } },
      { label = 'WSL:Ubuntu', domain = { DomainName = 'WSL:Ubuntu' } },
      { label = 'Windows PowerShell', args = { 'powershell.exe' } },
      { label = 'Command Prompt', args = { 'cmd.exe' } },
   },
   wsl_domains = {
      {
         name = 'WSL:Ubuntu',
         distribution = 'Ubuntu',
         username = 'francis',
         default_cwd = '/home/francis/repo',
      },
   },
}
