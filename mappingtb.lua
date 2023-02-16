local sha2 = require("sha2")

local max_ins = 95

local function gen_alphabet(seed)
  local input_list = {}
  for i = 1, max_ins do
    table.insert(input_list, i)
  end

  local output_list = {}
  local count = 0
  while #output_list < max_ins do
    count = count + 1
    local hash_input = seed .. "," .. count
    local hash_output = tonumber(sha2.sha256(hash_input), 16)
    local pick = hash_output % #input_list + 1
    table.insert(output_list, input_list[pick])
    table.remove(input_list, pick)
  end

  return output_list
end

local function rev_alphabet(alphabet)
  local input_list = alphabet
  local output_list = {}
  for i = 1, max_ins do
    output_list[i] = i
  end

  for count = 1, max_ins do
    output_list[input_list[count]] = count
  end

  return output_list
end

local alphabet = gen_alphabet(12312312)
print(table.concat(alphabet, ", "))
local r_alphabet = rev_alphabet(alphabet)
print(table.concat(r_alphabet, ", "))

local mapping_str = ""
for i = 1, max_ins * 2 do
  mapping_str = mapping_str .. string.char(i + 31)
end

for i = 1, max_ins do
  local c = alphabet[i] + 31
  mapping_str = mapping_str .. string.char(c)
end

for i = 1, max_ins do
  local c = r_alphabet[i] + 31
  mapping_str = mapping_str .. string.char(c)
end

print(mapping_str)

local function encrypt_signal_alg(str)
  local lst = {string.byte(str, 1, -1)}
  local l = #lst

  for i = 1, l do
    for j = 1, i % 2 + 1 do
      local c = lst[i]
      if c >= 32 and c < 127 then
        lst[i] = string.byte(mapping_str:sub(c - 31, c - 31))
      end
    end
  end

  return string.char(table.unpack(lst))
end

local to_encode = "ssdfjslfjlksf"
print(to_encode)
print(encrypt_signal_alg(to_encode))
