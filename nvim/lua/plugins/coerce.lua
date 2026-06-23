-- Case coercion via coerce.nvim: type `cr{case}` followed by a motion or
-- text-object in normal mode (or use it on a visual selection).
--   crc → camelCase    crm → MixedCase    crs/cr_ → snake_case
--   cru → UPPER_CASE   crk → kebab-case   cr. → dot.case
-- Pure Lua; pulls in coop.nvim (same author) automatically. Loads at startup so
-- the `cr` operator is always available.

return {
  {
    "gregorias/coerce.nvim",
    config = function()
      require("coerce").setup()
    end,
  },
}
