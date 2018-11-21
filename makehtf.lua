kpse.set_program_name("luatex")
local lfs = require "lfs"
local htflib = require "htflibs.htflib"
local fontobj = require "htflibs.fontobj"

-- load a map file. pdftex.map should contain all possible fonts
local fonts = fontobj("pdftex")


local function write_file(htfname, contents)
  local f = io.open(htfname, "w")
  f:write(contents)
  f:close()
end

local function find_missing_fonts(tex4ht_output)
  local missing_fonts = {}
  for htf_font in tex4ht_output:gmatch("Couldn't find font `(.-)%.htf") do
    table.insert(missing_fonts, htf_font)
  end
  return missing_fonts
end

-- make test run on the dvi/xdv file to find unsupported fonts
local function run_tex4ht(dvifile)
  -- redirect stderr 
  local ext = dvifile:match("^.+(%..+)$")
  local command = io.popen("tex4ht -" .. ext .. " " .. dvifile .. " 2>&1", "r")
  local result = command:read("*all")
  command:close()
  return find_missing_fonts(result)
end

local missing_fonts = run_tex4ht(arg[1])

for _, fontfile in ipairs(missing_fonts) do
  local fontobject 
  -- the virtual fonts have priority over tfm fonts
  local vffile = kpse.find_file(fontfile, "vf")
  if vffile then
    fontobject = fonts:load_virtual_font(vffile)
  else
    local tfmfile = kpse.find_file(fontfile, "tfm")
    if tfmfile then
      fontobject = fonts:load_tfm_font(tfmfile)
    end
  end
  if fontobject then
    local htfname = fontfile .. ".htf"
    print("writing " .. htfname)
    write_file(htfname, htflib.fontobj_to_htf_table(fontobject).."\n" .. htflib.fontobj_get_css(fontobject) .."\n")
    for _, missing in ipairs(fontobject.missing_glyphs) do
      print("Missing glyph", missing)
    end
  end

end
