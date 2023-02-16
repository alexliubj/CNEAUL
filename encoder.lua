local FNV1 = {}

function FNV1.hash(str)
  local FNV_offset_basis = 2166136261
  local FNV_prime = 16777619
  local hash = FNV_offset_basis
  
  for i = 1, #str do
    hash = bit.bxor(hash, string.byte(str, i))
    hash = hash * FNV_prime
  end
  
  return hash
end

return FNV1

local function encrypt_nested_strings(tbl, seed)
  local alphabet = gen_alphabet(seed)
  local mapping_str = ""
  for i = 1, #alphabet do
    mapping_str = mapping_str .. string.char(alphabet[i] + 31)
  end
  local r_alphabet = rev_alphabet(alphabet)
  for i = 1, #r_alphabet do
    mapping_str = mapping_str .. string.char(r_alphabet[i] + 31)
  end
  
  local nonce = tostring(math.random(1, 1000000))
  local hash_input = nonce
  local encrypted_tbl = {}
  
  for i, v in pairs(tbl) do
    if type(v) == "table" then
      encrypted_tbl[i] = encrypt_nested_strings(v, seed)
    else
      encrypted_tbl[i] = encrypt_signal_alg(v, mapping_str)
      hash_input = hash_input .. encrypted_tbl[i]
    end
  end
  
  local hash_value = FNV1.hash(hash_input)
  
  return encrypted_tbl, nonce, hash_value
end

local function decrypt_nested_strings(tbl, nonce, hash_value, seed)
  local alphabet = gen_alphabet(seed)
  local mapping_str = ""
  for i = 1, #alphabet do
    mapping_str = mapping_str .. string.char(alphabet[i] + 31)
  end
  local r_alphabet = rev_alphabet(alphabet)
  for i = 1, #r_alphabet do
    mapping_str = mapping_str .. string.char(r_alphabet[i] + 31)
  end

  local hash_input = nonce
  local decrypted_tbl = {}

  for i, v in pairs(tbl) do
    if type(v) == "table" then
      decrypted_tbl[i] = decrypt_nested_strings(v, nonce, hash_value, seed)
    else
      local decrypted_value = decrypt_signal_alg(v, string.sub(mapping_str, 1, max_ins))
      hash_input = hash_input .. v
      if FNV1.hash(hash_input) ~= hash_value then
        error("Hash mismatch. Possible data tampering.")
      end
      decrypted_tbl[i] = decrypted_value
    end
  end

  return decrypted_tbl
end
