--[[ File Writer ]]--


local writer = require 'scriptum.writer'
local fileWriter = {}


local anyText = "(.*)"
local spaceChar = "%s"
local comment = " --"
local commaComment = ", --"
local patternUnpackComment = anyText..commaComment..anyText
local patternUnpackComment2 = anyText..spaceChar..comment..anyText
local subpatternCode = "~"..anyText
local patternLeadingSpace = spaceChar.."*"..anyText
local toRoot = "Back to root"


--[[ Write module description
Will force a repeated header on a line that is '||', as code for a manual new line.
> file (userdata) io.file
> set ({integer=string}) lines to write
]]
local function writeVignette(file, set)
  local function firstToUpper(text)
    return (text:gsub("^%l", string.upper))
  end
  local codeBlockOpened = false
  local field = "description"
  if set[field] then
    local count = 0
    local maximum = #set[field]
    for j = 2, maximum do
      local text = set[field][j]
      text = text:gsub("%(a%)", "@")
      text = text:gsub("%(start%)", "--".."[[")
      text = text:gsub("%(end%)", "]]")
      count = count + 1
      if text == "||" then
        file:write("\n")
        file:write("\n**"..firstToUpper(field).."**:")
        count = 0
      else
        local code = string.match(text, subpatternCode)
        if code then
          if count == 2 then
            file:write("\n")
          end
          file:write("\n    "..code)
          codeBlockOpened = true
        else
          if codeBlockOpened then
            codeBlockOpened = false
          end
          file:write("\n"..text)
        end
      end
    end
  end
end


--[[
> file (userdata) io.file
> v3 (table) document model
]]
local function printFn(file, v3)
  file:write(" (")
  local cat = ""
  local count = 0
  for _, v4 in pairs(v3.pars) do
    if v4.name then
      count = count + 1
      if count > 1 then
        cat = cat..", "..v4.name
      else
        cat = cat..v4.name
      end
      if not v4.default then
        cat = cat.."\\*"
      end
    end
  end
  file:write(cat..")")
  if v3.returns then
    file:write(" : ")
    cat = ""
    count = 0
    for _, v4 in pairs(v3.returns) do
      if v4.name then
        count = count + 1
        if count > 1 then
          cat = cat..", "..v4.name
        else
          cat = cat..v4.name
        end
      end
    end
    file:write(cat)
  end
  file:write("\n")
end


--[[
> file (userdata) io.file
> v3 (table) document model
> which ("pars"|"returns")
]]
local function printParamsOrReturns(file, v3, which)
  for _, v4 in pairs(v3[which]) do
    local text2
    if which == "pars" then
      text2 = "> &rarr; "
    else
      text2 = "> &larr; "
    end
    if v4.name then
      text2 = text2.."**"..v4.name.."**"
    end
    if v4.typing then
      text2 = text2.." ("..v4.typing..")"
    end
    if v4.default then
      text2 = text2.." *["..v4.default.."]*"
    end
    if v4.note then
      text2 = text2.." `"..v4.note.."`"
    end
    file:write(text2.."<br/>\n")
  end
end


--[[
> file (userdata) io.file
> v3 (table) document model
]]
local function printUnpack(file, v3)
  for _, v4 in pairs(v3.unpack) do
    if v4.lines then
      for i = 1, #v4.lines do
        local line = v4.lines[i]
        local comment1 = string.match(line, patternUnpackComment)
        local comment2 = string.match(line, patternUnpackComment2)
        if comment1 then
          file:write("> - "..comment1:match(patternLeadingSpace))
          local stripped = line:gsub(comment1, "")
          stripped = stripped:gsub(commaComment, "")
          stripped = stripped:gsub("-", ""):match(patternLeadingSpace)
          file:write(" `"..stripped.."`  \n")
        elseif comment2 then
          file:write("> - "..comment2:match(patternLeadingSpace))
          local stripped = line:gsub(comment2, "")
          stripped = stripped:gsub(comment, "")
          stripped = stripped:gsub("-", ""):match(patternLeadingSpace)
          file:write(" `"..stripped.."`  \n")
        else
          file:write("> - "..line:gsub(",", ""):match(patternLeadingSpace).."  \n")
        end
      end
    end
  end
  file:write(">  \n")
end


--[[
> rootPath (string)
> outPath (string)
> config (table)
> data (table)
]]
function fileWriter.write(rootPath, outPath, module, i)
  local data = module.fileData[module.files[i]]
  local outFilename = module.reqs[i]..".md"
  outFilename = outPath.."/"..outFilename
  local file = writer.open(outFilename)
  if not file then return end

  if data.header then
    file:write("# "..(data.header.description[1] or "Vignette").."\n")
    writeVignette(file, data.header)
    file:write("\n")
  else
    writer.stripOutRoot(data.file, rootPath):write("# "..file.."\n")
  end

  -- Requires --
  local hasREQ = false
  for _, req in pairs(data.requires) do
    if not hasREQ then
      file:write("\n## Requires\n")
      hasREQ = true
    end
    if module.reqs[req] then
      file:write("\n+ ["..req.."]("..req..".md)")
    else
      file:write("\n+ "..req)
    end

  end
  if hasREQ then
    file:write("\n")
  end

  -- API --
  local hasAPI = false
  local count = 0
  for _, v3 in pairs(data.api) do
    if v3.name then
      if not hasAPI then
        file:write("\n## API\n")
        hasAPI = true
      end
      count = count + 1
      local nameText = v3.name:gsub("module.", "")
      file:write("\n**"..nameText:match(patternLeadingSpace).."**")
      if v3.pars then
        printFn(file, v3)
      end
      if v3.desc then
        file:write("\n> "..v3.desc.."\n>\n")
      end
      if v3.pars then
        printParamsOrReturns(file, v3, 'pars')
      end
      if v3.unpack then
        printUnpack(file, v3)
      end
      if v3.returns then
        file:write(">\n")
        printParamsOrReturns(file, v3, 'returns')
      end
    end
  end
  file:write("\n## Project\n\n+ ["..toRoot.."](README.md)\n")
  file:close()
end


return fileWriter