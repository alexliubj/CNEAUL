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

function extract_keys(table)
  local keys = {}
  for key, value in pairs(table) do
    if type(value) == "table" then
      -- recursively extract keys from nested tables
      local nested_keys = extract_keys(value)
      for _, nested_key in ipairs(nested_keys) do
        table.insert(keys, key .. "." .. nested_key)
      end
    else
      table.insert(keys, key)
    end
  end
  table.sort(keys)
  return keys
end

function extract_values(t, keys)
  local values = {}
  for _, key in ipairs(keys) do
    local value = t
    for k in key:gmatch("[^%.]+") do
      value = value[k]
      if not value then break end
    end
    table.insert(values, value)
  end
  return values
end

-- example table
local t = {
  foo = 1,
  bar = {
    baz = 2,
    qux = {
      quux = 3
    }
  }
}

-- extract keys and print them
local keys = extract_keys(t)
for _, key in ipairs(keys) do
  print(key)
end

-- extract values based on the keys
local values = extract_values(t, keys)

-- print the values
for _, value in ipairs(values) do
  print(value)
end

function create_table_from_key_value_arrays(keys, values)
  local t = {}
  for i = 1, #keys do
    local key = keys[i]
    local value = values[i]
    local subtable = t
    for subkey in key:gmatch("[^%.]+") do
      if not subtable[subkey] then
        subtable[subkey] = {}
      end
      subtable = subtable[subkey]
    end
    subtable[#subtable + 1] = value
  end
  return t
end

-- example table
local t = {
  foo = 1,
  bar = {
    baz = 2,
    qux = {
      quux = 3
    }
  }
}

-- function create_table_from_key_value_arrays(keys, values)
--   local t = {}
--   for i = 1, #keys do
--     local key = keys[i]
--     local value = values[i]
--     local subtable = t
--     for subkey in key:gmatch("[^%.]+") do
--       if not subtable[subkey] then
--         subtable[subkey] = {}
--       end
--       subtable = subtable[subkey]
--     end
--     if #subtable == 0 then
--       subtable[1] = value
--     else
--       error("Multiple values found for key " .. key)
--     end
--   end
--   return t
-- end


-- extract keys and values
local keys = extract_keys(t)
local values = extract_values(t, keys)

-- create a new table from the keys and values
local new_table = create_table_from_key_value_arrays(keys, values)

-- print the new table
for key, value in pairs(new_table) do
  print(key, value)
end



