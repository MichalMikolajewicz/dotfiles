local profile_file = vim.fn.stdpath("config") .. "/.profile"
local profile = "full"

if vim.fn.filereadable(profile_file) == 1 then
  local lines = vim.fn.readfile(profile_file)
  if lines[1] then
    profile = vim.trim(lines[1])
  end
end

return {
  name = profile,
  has = function(feature)
    if feature == "csharp" then
      return profile == "full" or profile == "csharp"
    end
    return true
  end,
}
