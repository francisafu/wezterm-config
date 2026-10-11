local wezterm = require('wezterm')
local c = require('colors.palette')

local nf = wezterm.nerdfonts

local M = {}

local PROGRESS_STALE_AFTER = 30

local ICON_LEFT = nf.ple_left_half_circle_thick
local ICON_RIGHT = nf.ple_right_half_circle_thick
local ICON_ADMIN = nf.md_shield_half_full
local ICON_WSL = nf.cod_terminal_linux
local ICON_PROCESS = {
   pwsh = nf.cod_terminal_powershell,
   powershell = nf.cod_terminal_powershell,
   cmd = nf.cod_terminal_cmd,
}
local ICON_PCT_FRAMES = {
   nf.md_circle_slice_1,
   nf.md_circle_slice_2,
   nf.md_circle_slice_3,
   nf.md_circle_slice_4,
   nf.md_circle_slice_5,
   nf.md_circle_slice_6,
   nf.md_circle_slice_7,
   nf.md_circle_slice_8,
}
local ICON_IND_FRAMES = { '◜', '◠', '◝', '◞', '◡', '◟' }

local COLORS = {
   bar = c.crust,
   default = { bg = c.surface0, fg = c.text, unseen = c.peach, pct = c.green, err = c.red, ind = c.rosewater },
   hover = { bg = c.surface1, fg = c.text, unseen = c.peach, pct = c.green, err = c.red, ind = c.rosewater },
   active = { bg = c.blue, fg = c.crust, unseen = c.crust, pct = c.crust, err = c.crust, ind = c.crust },
}

local function clean_process_name(proc)
   return (proc:gsub('.*[/\\]', ''):gsub('%.exe$', ''))
end

local function process_icon(process_name, is_admin)
   local name = process_name:lower()
   if name:sub(1, 3) == 'wsl' then
      return ICON_WSL
   end
   if is_admin then
      return ICON_ADMIN
   end
   return ICON_PROCESS[name]
end

local function unseen_icon(count)
   if count >= 10 then
      return nf.md_numeric_9_plus_box_multiple
   end
   return nf['md_numeric_' .. count .. '_box_multiple']
end

local progress_seen = {}
local function progress_stale(pane_id, key)
   local now = os.time()
   local entry = progress_seen[pane_id]
   if not entry or entry.key ~= key then
      progress_seen[pane_id] = { key = key, since = now }
      return false
   end
   return now - entry.since > PROGRESS_STALE_AFTER
end

local ind_frame = 0
local function collect_progress(panes)
   local out = {}
   for _, pane in ipairs(panes) do
      local prog = pane.progress
      local item, key
      if prog == 'Indeterminate' then
         ind_frame = ind_frame % #ICON_IND_FRAMES + 1
         item, key = { icon = ICON_IND_FRAMES[ind_frame], kind = 'ind' }, 'ind'
      elseif type(prog) == 'table' and (prog.Percentage or prog.Error) then
         local pct = prog.Percentage or prog.Error
         local frame = math.max(1, math.min(#ICON_PCT_FRAMES, math.ceil(pct * #ICON_PCT_FRAMES / 100)))
         item = { icon = ICON_PCT_FRAMES[frame], kind = prog.Error and 'err' or 'pct' }
         key = item.kind .. pct
      end
      if item and not progress_stale(pane.pane_id, key) then
         table.insert(out, item)
         if #out >= 3 then
            break
         end
      end
   end
   return out
end

local function render(tab, hover, max_width, is_admin)
   local state = tab.is_active and 'active' or (hover and 'hover' or 'default')
   local col = COLORS[state]

   local process_name = clean_process_name(tab.active_pane.foreground_process_name or '')
   local pane_title = tab.active_pane.title or ''
   local icon = process_icon(process_name, is_admin)

   local title
   if tab.tab_title and #tab.tab_title > 0 then
      title = tab.tab_title
   elseif #process_name > 0 then
      title = process_name .. ' ~ ' .. pane_title
   else
      title = pane_title
   end

   local unseen
   if not tab.is_active then
      local count = 0
      for _, p in ipairs(tab.panes) do
         if p.has_unseen_output then
            count = count + 1
         end
      end
      if count > 0 then
         unseen = unseen_icon(count)
      end
   end

   local progress = collect_progress(tab.panes)

   local index = tostring(tab.tab_index + 1)
   local fixed = 2 + 2 + #index + 1 + 2 * #progress
   if icon then
      fixed = fixed + 2
   end
   if unseen then
      fixed = fixed + 2
   end

   local budget = math.max(1, max_width - fixed)
   local width = wezterm.column_width(title)
   if width > budget then
      title = wezterm.truncate_right(title, budget - 1) .. '…'
   else
      title = title .. string.rep(' ', budget - width)
   end

   local cells = {
      { Background = { Color = COLORS.bar } },
      { Foreground = { Color = col.bg } },
      { Text = ICON_LEFT },
      { Background = { Color = col.bg } },
      { Foreground = { Color = col.fg } },
      { Text = ' ' .. index .. ' ' },
   }
   if icon then
      table.insert(cells, { Text = icon .. ' ' })
   end
   table.insert(cells, { Attribute = { Intensity = 'Bold' } })
   table.insert(cells, { Text = title })
   table.insert(cells, { Attribute = { Intensity = 'Normal' } })
   for _, p in ipairs(progress) do
      table.insert(cells, { Foreground = { Color = col[p.kind] } })
      table.insert(cells, { Text = ' ' .. p.icon })
   end
   if unseen then
      table.insert(cells, { Foreground = { Color = col.unseen } })
      table.insert(cells, { Text = ' ' .. unseen })
   end
   table.insert(cells, { Text = ' ' })
   table.insert(cells, { Background = { Color = COLORS.bar } })
   table.insert(cells, { Foreground = { Color = col.bg } })
   table.insert(cells, { Text = ICON_RIGHT })
   return cells
end

function M.setup(is_admin)
   wezterm.on('format-tab-title', function(tab, _tabs, _panes, _config, hover, max_width)
      return render(tab, hover, max_width, is_admin)
   end)
end

return M
