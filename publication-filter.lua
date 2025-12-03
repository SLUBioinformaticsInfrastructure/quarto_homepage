-- Group bibliography entries by year (>= 2020), add year subheadings,
-- and number entries continuously over all years.
local utils = require 'pandoc.utils'

function Pandoc(doc)
  -- Run citeproc ourselves (this generates the bibliography)
  doc = utils.citeproc(doc)

  -- Find the bibliography div (id = "refs")
  for i, blk in ipairs(doc.blocks) do
    if blk.t == "Div" and blk.identifier == "refs" then

      local byyear = {}
      local years = {}

      -- Collect entries and filter by year >= 2020
      for _, refblk in ipairs(blk.content) do
        local text = utils.stringify(refblk)
        local year = text:match("(%d%d%d%d)")

        if year and tonumber(year) >= 2018 then
          if not byyear[year] then
            byyear[year] = {}
            table.insert(years, year)
          end
          table.insert(byyear[year], refblk)
        end
      end

      -- Sort years descending
      table.sort(years, function(a, b)
        return tonumber(a) > tonumber(b)
      end)

      -- Rebuild bibliography with year headers + globally numbered list
      local newcontent = {}
      local counter = 1  -- global publication index

      for _, year in ipairs(years) do
        -- Year heading
        table.insert(newcontent, pandoc.Header(2, year))

        -- Items for this year
        local items = {}
        for _, refblk in ipairs(byyear[year]) do
          table.insert(items, { refblk })
        end

        -- Ordered list that continues numbering
        local attrs = pandoc.ListAttributes(counter, 'Decimal', 'Period')
        table.insert(newcontent, pandoc.OrderedList(items, attrs))

        -- Advance counter
        counter = counter + #items
      end

      blk.content = newcontent
      doc.blocks[i] = blk
      break
    end
  end

  return doc
end