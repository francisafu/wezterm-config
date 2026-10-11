local wezterm = require('wezterm')

local Config = {}
Config.__index = Config

function Config:init()
   return setmetatable({ options = wezterm.config_builder() }, self)
end

function Config:append(new_options)
   for k, v in pairs(new_options) do
      if self.options[k] ~= nil then
         wezterm.log_warn('Duplicate config option detected: ' .. k)
      else
         self.options[k] = v
      end
   end
   return self
end

return Config
