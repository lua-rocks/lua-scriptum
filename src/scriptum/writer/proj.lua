--[[ Project Writer ]]--


local writer = require 'src.scriptum.writer'
local projWriter = {}


--[[ Write project index file
> rootPath (string)
> outPath (string)
> module (table)
]]
function projWriter.write(rootPath, outPath, module)
  local file = writer.open(outPath.."/README.md")
  if not file then return end
  file:write("# Project Code Documentation\n\n## Index\n")
  for i = 1, #module.files do
    local data = module.fileData[module.files[i]]
    local name = writer.stripOutRoot(data.file, rootPath)
    local link = writer.makeOutputFileName(data.file, rootPath)
    file:write("\n+ ["..name.."]("..link..")\n")
  end
end


return projWriter
