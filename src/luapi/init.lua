--[[ LUAPI (WIP)
This document was created with this module. View the lua source file to see
example input and see the raw markdown file for example output.

> files ({string=table...}) require path = parsed file table
> paths (list) project paths
< luapi (table)
]]
local module = {}


local config = {
  rootPath = nil, -- search files here
  pathFilters = nil, -- extra search filters
  outPath = "doc", -- generate output here
}


local projParser = require 'luapi.parser.proj'
local fileParser = require 'luapi.parser.file'
local projWriter = require 'luapi.writer.proj'
local fileWriter = require 'luapi.writer.file'


--[[ Start document generation
> rootPath (string) path to read source code from
> pathFilters (table) [] search files only in these subdirs (relative to root)
> outPath (string) ["doc"] path to output to (relative to root)
]]
function module.start(rootPath, pathFilters, outPath)
  rootPath = rootPath or config.rootPath
  pathFilters = pathFilters or config.pathFilters
  outPath = outPath or config.outPath
  module.files = {}
  module.paths = {
    root = rootPath,
    out = outPath
  }

  -- Parse --
  local files, requires = projParser.getFiles(rootPath, pathFilters)
  for index, reqpath in ipairs(requires) do
    module.files[reqpath] = fileParser.parse(files[index])
    module.files[reqpath].luapath = files[index]
    module.files[reqpath].mdpath = rootPath .. '/' .. outPath .. '/' ..
      requires[index] .. '.md'
  end

  -- Generate markdown --
  projWriter.write(outPath, module)
  for reqpath in pairs(module.files) do
    fileWriter.write(reqpath, module)
  end
end


--[[ Modify the configuration of this module programmatically
Provide a table with keys that share the same name as the config parameters:
> overrides (table) each key is from a valid name, the value is the override
]]
function module.config(overrides)
  for k, v in pairs(overrides) do
    if config[k] then config[k] = v end
  end
end


return module
