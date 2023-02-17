function prng(seed)
  local a = seed
  return function()
    local t = (a * 1597334677) % 2^32
    t = (t >> 24) | ((t >> 8) & 0xff00) | ((t << 8) & 0xff0000) | (t << 24)
    a = a ~ (a << 13)
    a = a ~ (a >> 17)
    a = a ~ (a << 5)
    return math.floor(((a + t) % 2^32) / 2^32 * (2^31 - 1))
  end
end

function sort_table(table)
  local keys = {}

  for key in pairs(table) do
    table.insert(keys, key)
  end

  table.sort(keys)

  for i, key in ipairs(keys) do
    local value = table[key]
    if type(value) == "table" then
      table[key] = sort_table(value)
    end
  end

  return table
end


function split_table(table)
  local keys = {}
  local values = {}

  for key, value in pairs(table) do
    table.insert(keys, key)
    if type(value) == "table" then
      table.insert(values, split_table(value))
    else
      table.insert(values, value)
    end
  end

  return keys, values
end


function join_table(keys, values)
  local table = {}

  for i, key in ipairs(keys) do
    if type(values[i]) == "table" then
      table[key] = join_table(values[i][1], values[i][2])
    else
      table[key] = values[i]
    end
  end

  return table
end


local my_table = {
  foo = "bar",
  baz = {
    qux = 42,
    quux = {
      corge = true,
      grault = false
    }
  }
}

local keys, values = split_table(my_table)
local new_table = join_table(keys, values)

