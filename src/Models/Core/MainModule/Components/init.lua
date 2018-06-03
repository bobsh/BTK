--- Components Library
--
-- @classmod Components

local Components = {}

for _, v in ipairs(script:GetChildren()) do
    Components[v.Name] = require(v)
end

return Components