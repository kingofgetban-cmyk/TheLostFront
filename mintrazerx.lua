--[[
    MintraZERX Contro Flow
    Architecture: Custom Lua 
    Anti-Tamper Desigm
    Made by valexcryzer
]]
return (function(...)
    if islclosure and type(loadstring) == "function" and islclosure(loadstring) then
        return nil
    end
    if debug and debug.getinfo and type(loadstring) == "function" then
        local inf = debug.getinfo(loadstring)
        if inf and (inf.what == "Lua" or (inf.linedefined and inf.linedefined > 0)) then
            return nil
        end
    end
    if typeof and typeof(game) == "Instance" and getrawmetatable then
        local ok, mt = pcall(getrawmetatable, game)
        if ok and type(mt) == "table" and mt.__namecall and islclosure and islclosure(mt.__namecall) then
            return nil
        end
    end

    local _0x_decoy_sbox_alpha = { 0xec, 0x77, 0x1fe, 0x141, 0x2c8, 0x253, 0x3da, 0x4ad, 0x434, 0x5bf, 0x506, 0x689, 0x610, 0x79b, 0x762, 0x8f5, 0x87c, 0x9c7, 0x94e, 0xad1, 0xa58, 0xb23, 0xcaa, 0xc3d, 0xd84, 0xd0f, 0xe96, 0xe19, 0xfe0, 0xf6b, 0x10f2, 0x1045, 0x11cc, 0x1157, 0x12de, 0x13a1, 0x1328, 0x14b3, 0x143a, 0x158d, 0x1514, 0x169f, 0x1666, 0x17e9, 0x1770, 0x18fb, 0x1842, 0x19d5, 0x195c, 0x1a27, 0x1bae, 0x1b31, 0x1cb8, 0x1c03, 0x1d8a, 0x1d1d, 0x1ee4, 0x1e6f, 0x1ff6, 0x1f79, 0x20c0, 0x204b, 0x21d2, 0x22a5, 0x222c, 0x23b7, 0x233e, 0x2481, 0x2408, 0x2593, 0x251a, 0x26ed, 0x2674, 0x27ff, 0x2746, 0x28c9, 0x2850, 0x29db, 0x2aa2, 0x2a35, 0x2bbc, 0x2b07, 0x2c8e, 0x2c11, 0x2d98, 0x2d63, 0x2eea, 0x2e7d, 0x2fc4, 0x2f4f, 0x30d6, 0x3059, 0x3120, 0x32ab, 0x3232, 0x3385, 0x330c, 0x3497, 0x341e, 0x35e1, 0x3568, 0x36f3, 0x367a, 0x37cd, 0x3754, 0x38df, 0x39a6, 0x3929, 0x3ab0, 0x3a3b, 0x3b82, 0x3b15, 0x3c9c, 0x3c67, 0x3dee, 0x3d71, 0x3ef8, 0x3e43, 0x3fca, 0x3f5d, 0x4024, 0x41af, 0x4136, 0x42b9, 0x4200, 0x438b, 0x4312, 0x44e5, 0x446c, 0x45f7, 0x457e, 0x46c1, 0x4648, 0x47d3, 0x475a, 0x482d, 0x49b4, 0x493f, 0x4a86, 0x4a09, 0x4b90, 0x4b1b, 0x4ce2, 0x4c75, 0x4dfc, 0x4d47, 0x4ece, 0x4e51, 0x4fd8, 0x50a3, 0x502a, 0x51bd, 0x5104, 0x528f, 0x5216, 0x5399, 0x5360, 0x54eb, 0x5472, 0x55c5, 0x554c, 0x56d7, 0x565e, 0x5721, 0x58a8, 0x5833, 0x59ba, 0x590d, 0x5a94, 0x5a1f, 0x5be6, 0x5b69, 0x5cf0, 0x5c7b, 0x5dc2, 0x5d55, 0x5edc, 0x5fa7, 0x5f2e, 0x60b1, 0x6038, 0x6183, 0x610a, 0x629d, 0x6264, 0x63ef, 0x6376, 0x64f9, 0x6440, 0x65cb, 0x6552, 0x6625, 0x67ac, 0x6737, 0x68be, 0x6801, 0x6988, 0x6913, 0x6a9a, 0x6a6d, 0x6bf4, 0x6b7f, 0x6cc6, 0x6c49, 0x6dd0, 0x6d5b, 0x6e22, 0x6fb5, 0x6f3c, 0x7087, 0x700e, 0x7191, 0x7118, 0x72e3, 0x726a, 0x73fd, 0x7344, 0x74cf, 0x7456, 0x75d9, 0x76a0, 0x762b, 0x77b2, 0x7705, 0x788c, 0x7817, 0x799e, 0x7961, 0x7ae8, 0x7a73, 0x7bfa, 0x7b4d, 0x7cd4, 0x7c5f, 0x7d26, 0x7ea9, 0x7e30, 0x7fbb, 0x7f02, 0x8095, 0x801c, 0x81e7, 0x816e, 0x82f1, 0x8278, 0x83c3, 0x834a, 0x84dd, 0x85a4, 0x852f, 0x86b6, 0x8639, 0x8780, 0x870b, 0x8892, 0x8865 }
    local _0x_decoy_sbox_beta = { 0x75, 0xac, 0x1eb, 0x222, 0x319, 0x450, 0x48f, 0x5c6, 0x63d, 0x774, 0x7b3, 0x8ea, 0x921, 0xa18, 0xb57, 0xb8e, 0xcc5, 0xd3c, 0xe7b, 0xeb2, 0xfe9, 0x1020, 0x111f, 0x1256, 0x128d, 0x13c4, 0x1403, 0x157a, 0x15b1, 0x16e8, 0x1727, 0x181e, 0x1955, 0x198c, 0x1acb, 0x1b02, 0x1c79, 0x1cb0, 0x1def, 0x1e26, 0x1f1d, 0x2054, 0x2093, 0x21ca, 0x2201, 0x2378, 0x23b7, 0x24ee, 0x2525, 0x261c, 0x275b, 0x2792, 0x28c9, 0x2900, 0x2a7f, 0x2ab6, 0x2bed, 0x2c24, 0x2d63, 0x2e5a, 0x2e91, 0x2fc8, 0x3007, 0x317e, 0x31b5, 0x32ec, 0x332b, 0x3462, 0x3559, 0x3590, 0x36cf, 0x3706, 0x387d, 0x38b4, 0x39f3, 0x3a2a, 0x3b61, 0x3c58, 0x3c97, 0x3dce, 0x3e05, 0x3f7c, 0x3fbb, 0x40f2, 0x4129, 0x4260, 0x435f, 0x4396, 0x44cd, 0x4504, 0x4643, 0x46ba, 0x47f1, 0x4828, 0x4967, 0x4a5e, 0x4a95, 0x4bcc, 0x4c0b, 0x4d42, 0x4db9, 0x4ef0, 0x4f2f, 0x5066, 0x515d, 0x5194, 0x52d3, 0x530a, 0x5441, 0x54b8, 0x55f7, 0x562e, 0x5765, 0x585c, 0x589b, 0x59d2, 0x5a09, 0x5b40, 0x5bbf, 0x5cf6, 0x5d2d, 0x5e64, 0x5ea3, 0x5f9a, 0x60d1, 0x6108, 0x6247, 0x62be, 0x63f5, 0x642c, 0x656b, 0x65a2, 0x6699, 0x67d0, 0x680f, 0x6946, 0x69bd, 0x6af4, 0x6b33, 0x6c6a, 0x6ca1, 0x6d98, 0x6ed7, 0x6f0e, 0x7045, 0x70bc, 0x71fb, 0x7232, 0x7369, 0x73a0, 0x749f, 0x75d6, 0x760d, 0x7744, 0x7783, 0x78fa, 0x7931, 0x7a68, 0x7aa7, 0x7b9e, 0x7cd5, 0x7d0c, 0x7e4b, 0x7e82, 0x7ff9, 0x8030, 0x816f, 0x81a6, 0x829d, 0x83d4, 0x8413, 0x854a, 0x8581, 0x86f8, 0x8737, 0x886e, 0x88a5, 0x899c, 0x8adb, 0x8b12, 0x8c49, 0x8c80, 0x8dff, 0x8e36, 0x8f6d, 0x8fa4, 0x90e3, 0x91da, 0x9211, 0x9348, 0x9387, 0x94fe, 0x9535, 0x966c, 0x96ab, 0x97e2, 0x98d9, 0x9910, 0x9a4f, 0x9a86, 0x9bfd, 0x9c34, 0x9d73, 0x9daa, 0x9ee1, 0x9fd8, 0xa017, 0xa14e, 0xa185, 0xa2fc, 0xa33b, 0xa472, 0xa4a9, 0xa5e0, 0xa6df, 0xa716, 0xa84d, 0xa884, 0xa9c3, 0xaa3a, 0xab71, 0xaba8, 0xace7, 0xadde, 0xae15, 0xaf4c, 0xaf8b, 0xb0c2, 0xb139, 0xb270, 0xb2af, 0xb3e6, 0xb4dd, 0xb514, 0xb653, 0xb68a, 0xb7c1, 0xb838, 0xb977, 0xb9ae, 0xbae5, 0xbbdc, 0xbc1b, 0xbd52, 0xbd89, 0xbec0, 0xbf3f, 0xc076, 0xc0ad, 0xc1e4, 0xc223, 0xc31a, 0xc451, 0xc488, 0xc5c7, 0xc63e }
    local _0x_decoy_sbox_gamma = { 0x2e, 0x133, 0x238, 0x33d, 0x3c2, 0x4c7, 0x5cc, 0x6d1, 0x7d6, 0x8db, 0x9e0, 0xae5, 0xbea, 0xcef, 0xdf4, 0xef9, 0xffe, 0x1083, 0x1188, 0x128d, 0x1392, 0x1497, 0x159c, 0x16a1, 0x17a6, 0x18ab, 0x19b0, 0x1ab5, 0x1bba, 0x1cbf, 0x1d44, 0x1e49, 0x1f4e, 0x2053, 0x2158, 0x225d, 0x2362, 0x2467, 0x256c, 0x2671, 0x2776, 0x287b, 0x2900, 0x2a05, 0x2b0a, 0x2c0f, 0x2d14, 0x2e19, 0x2f1e, 0x3023, 0x3128, 0x322d, 0x3332, 0x3437, 0x353c, 0x35c1, 0x36c6, 0x37cb, 0x38d0, 0x39d5, 0x3ada, 0x3bdf, 0x3ce4, 0x3de9, 0x3eee, 0x3ff3, 0x40f8, 0x41fd, 0x4282, 0x4387, 0x448c, 0x4591, 0x4696, 0x479b, 0x48a0, 0x49a5, 0x4aaa, 0x4baf, 0x4cb4, 0x4db9, 0x4ebe, 0x4f43, 0x5048, 0x514d, 0x5252, 0x5357, 0x545c, 0x5561, 0x5666, 0x576b, 0x5870, 0x5975, 0x5a7a, 0x5b7f, 0x5c04, 0x5d09, 0x5e0e, 0x5f13, 0x6018, 0x611d, 0x6222, 0x6327, 0x642c, 0x6531, 0x6636, 0x673b, 0x67c0, 0x68c5, 0x69ca, 0x6acf, 0x6bd4, 0x6cd9, 0x6dde, 0x6ee3, 0x6fe8, 0x70ed, 0x71f2, 0x72f7, 0x73fc, 0x7481, 0x7586, 0x768b, 0x7790, 0x7895, 0x799a, 0x7a9f, 0x7ba4, 0x7ca9, 0x7dae, 0x7eb3, 0x7fb8, 0x80bd, 0x8142, 0x8247, 0x834c, 0x8451, 0x8556, 0x865b, 0x8760, 0x8865, 0x896a, 0x8a6f, 0x8b74, 0x8c79, 0x8d7e, 0x8e03, 0x8f08, 0x900d, 0x9112, 0x9217, 0x931c, 0x9421, 0x9526, 0x962b, 0x9730, 0x9835, 0x993a, 0x9a3f, 0x9ac4, 0x9bc9, 0x9cce, 0x9dd3, 0x9ed8, 0x9fdd, 0xa0e2, 0xa1e7, 0xa2ec, 0xa3f1, 0xa4f6, 0xa5fb, 0xa680, 0xa785, 0xa88a, 0xa98f, 0xaa94, 0xab99, 0xac9e, 0xada3, 0xaea8, 0xafad, 0xb0b2, 0xb1b7, 0xb2bc, 0xb341, 0xb446, 0xb54b, 0xb650, 0xb755, 0xb85a, 0xb95f, 0xba64, 0xbb69, 0xbc6e, 0xbd73, 0xbe78, 0xbf7d, 0xc002, 0xc107, 0xc20c, 0xc311, 0xc416, 0xc51b, 0xc620, 0xc725, 0xc82a, 0xc92f, 0xca34, 0xcb39, 0xcc3e, 0xccc3, 0xcdc8, 0xcecd, 0xcfd2, 0xd0d7, 0xd1dc, 0xd2e1, 0xd3e6, 0xd4eb, 0xd5f0, 0xd6f5, 0xd7fa, 0xd8ff, 0xd984, 0xda89, 0xdb8e, 0xdc93, 0xdd98, 0xde9d, 0xdfa2, 0xe0a7, 0xe1ac, 0xe2b1, 0xe3b6, 0xe4bb, 0xe540, 0xe645, 0xe74a, 0xe84f, 0xe954, 0xea59, 0xeb5e, 0xec63, 0xed68, 0xee6d, 0xef72, 0xf077, 0xf17c, 0xf201, 0xf306, 0xf40b, 0xf510, 0xf615, 0xf71a, 0xf81f, 0xf924, 0xfa29 }
    local _0x_decoy_entropy_key = { 0x6960d3bb, 0x8f9281fc, 0xc28db848, 0x560c0035, 0xc26b7ead, 0xf1e0eeca, 0x96866549, 0x864cc7c1, 0x1be51216, 0x7f8f7fc3, 0x73c0d22e, 0x4bf92c8f, 0x2558663a, 0x962109f0, 0x1bc93351, 0x4b43bf8d, 0xf504774a, 0x3125ff1e, 0xbe8cfcf4, 0x6657e1d3, 0x8249aab4, 0xd347a06d, 0x09204eb0, 0xd5e7441e, 0x4715d937, 0x3fd3055a, 0x6bad2c26, 0x8b896dbf, 0xb7d094af, 0x2e7d7a24, 0xd4ef6099, 0xb659e498 }
    local _0x_decoy_entropy_nonce = { 0xe194d505, 0x942a7387, 0xd344854d, 0xff3a676f, 0x7f33dca6, 0x5d8829ba, 0x050c8e4f, 0xbd85cfc9, 0x5194f1d1, 0x4cabbf41, 0xa2ca6b7f, 0x07a6fbd3, 0xa286e80f, 0x7c6877b2, 0x0aa4d7a8, 0xbadc4f97 }
    local function _0x_decoy_feistel_transform(_in_stream, _seed_ctx)
        local _acc = _seed_ctx or 0x5F3759DF
        local _trans_res = {}
        for _di = 1, #_in_stream do
            local _byte_val = _in_stream[_di] or 0
            local _box_val = _0x_decoy_sbox_alpha[((_byte_val + _di) % 256) + 1] or 0x11
            local _mix = ((_box_val * 37) + _acc) % 256
            table.insert(_trans_res, _mix)
            _acc = ((_acc * 1664525) + 1013904223) % 4294967296
        end
        return _trans_res
    end
    local _0x_decoy_trampoline_table = {}
    _0x_decoy_trampoline_table[0x0] = function(_x, _y) return (((_x or 55597) * 31) + ((_y or 45850) * 17)) % 65536 end
    _0x_decoy_trampoline_table[0x1] = function(_x, _y) return (((_x or 56923) * 31) + ((_y or 20561) * 17)) % 65536 end
    _0x_decoy_trampoline_table[0x2] = function(_x, _y) return (((_x or 32305) * 31) + ((_y or 36797) * 17)) % 65536 end
    _0x_decoy_trampoline_table[0x3] = function(_x, _y) return (((_x or 54736) * 31) + ((_y or 47653) * 17)) % 65536 end
    _0x_decoy_trampoline_table[0x4] = function(_x, _y) return (((_x or 14796) * 31) + ((_y or 50499) * 17)) % 65536 end
    _0x_decoy_trampoline_table[0x5] = function(_x, _y) return (((_x or 21615) * 31) + ((_y or 4468) * 17)) % 65536 end
    _0x_decoy_trampoline_table[0x6] = function(_x, _y) return (((_x or 20163) * 31) + ((_y or 35364) * 17)) % 65536 end
    _0x_decoy_trampoline_table[0x7] = function(_x, _y) return (((_x or 17107) * 31) + ((_y or 20276) * 17)) % 65536 end
    _0x_decoy_trampoline_table[0x8] = function(_x, _y) return (((_x or 50003) * 31) + ((_y or 24968) * 17)) % 65536 end
    _0x_decoy_trampoline_table[0x9] = function(_x, _y) return (((_x or 27714) * 31) + ((_y or 2398) * 17)) % 65536 end
    _0x_decoy_trampoline_table[0xA] = function(_x, _y) return (((_x or 63013) * 31) + ((_y or 8284) * 17)) % 65536 end
    _0x_decoy_trampoline_table[0xB] = function(_x, _y) return (((_x or 9273) * 31) + ((_y or 27647) * 17)) % 65536 end
    _0x_decoy_trampoline_table[0xC] = function(_x, _y) return (((_x or 24479) * 31) + ((_y or 60521) * 17)) % 65536 end
    _0x_decoy_trampoline_table[0xD] = function(_x, _y) return (((_x or 20879) * 31) + ((_y or 47467) * 17)) % 65536 end
    _0x_decoy_trampoline_table[0xE] = function(_x, _y) return (((_x or 30555) * 31) + ((_y or 29270) * 17)) % 65536 end
    _0x_decoy_trampoline_table[0xF] = function(_x, _y) return (((_x or 15266) * 31) + ((_y or 47358) * 17)) % 65536 end
    _0x_decoy_trampoline_table[0x10] = function(_x, _y) return (((_x or 54916) * 31) + ((_y or 2463) * 17)) % 65536 end
    _0x_decoy_trampoline_table[0x11] = function(_x, _y) return (((_x or 1300) * 31) + ((_y or 17590) * 17)) % 65536 end
    _0x_decoy_trampoline_table[0x12] = function(_x, _y) return (((_x or 9333) * 31) + ((_y or 55261) * 17)) % 65536 end
    _0x_decoy_trampoline_table[0x13] = function(_x, _y) return (((_x or 42618) * 31) + ((_y or 11491) * 17)) % 65536 end
    _0x_decoy_trampoline_table[0x14] = function(_x, _y) return (((_x or 28964) * 31) + ((_y or 50671) * 17)) % 65536 end
    _0x_decoy_trampoline_table[0x15] = function(_x, _y) return (((_x or 18981) * 31) + ((_y or 8596) * 17)) % 65536 end
    _0x_decoy_trampoline_table[0x16] = function(_x, _y) return (((_x or 2813) * 31) + ((_y or 47509) * 17)) % 65536 end
    _0x_decoy_trampoline_table[0x17] = function(_x, _y) return (((_x or 22411) * 31) + ((_y or 25371) * 17)) % 65536 end
    _0x_decoy_trampoline_table[0x18] = function(_x, _y) return (((_x or 45708) * 31) + ((_y or 45685) * 17)) % 65536 end
    _0x_decoy_trampoline_table[0x19] = function(_x, _y) return (((_x or 26127) * 31) + ((_y or 53309) * 17)) % 65536 end
    _0x_decoy_trampoline_table[0x1A] = function(_x, _y) return (((_x or 42401) * 31) + ((_y or 54471) * 17)) % 65536 end
    _0x_decoy_trampoline_table[0x1B] = function(_x, _y) return (((_x or 33661) * 31) + ((_y or 53780) * 17)) % 65536 end
    _0x_decoy_trampoline_table[0x1C] = function(_x, _y) return (((_x or 33164) * 31) + ((_y or 62904) * 17)) % 65536 end
    _0x_decoy_trampoline_table[0x1D] = function(_x, _y) return (((_x or 31086) * 31) + ((_y or 1676) * 17)) % 65536 end
    _0x_decoy_trampoline_table[0x1E] = function(_x, _y) return (((_x or 44760) * 31) + ((_y or 12343) * 17)) % 65536 end
    _0x_decoy_trampoline_table[0x1F] = function(_x, _y) return (((_x or 21053) * 31) + ((_y or 6358) * 17)) % 65536 end
    _0x_decoy_trampoline_table[0x20] = function(_x, _y) return (((_x or 30713) * 31) + ((_y or 11683) * 17)) % 65536 end
    _0x_decoy_trampoline_table[0x21] = function(_x, _y) return (((_x or 2519) * 31) + ((_y or 62008) * 17)) % 65536 end
    _0x_decoy_trampoline_table[0x22] = function(_x, _y) return (((_x or 50855) * 31) + ((_y or 52935) * 17)) % 65536 end
    _0x_decoy_trampoline_table[0x23] = function(_x, _y) return (((_x or 38260) * 31) + ((_y or 15479) * 17)) % 65536 end
    _0x_decoy_trampoline_table[0x24] = function(_x, _y) return (((_x or 21513) * 31) + ((_y or 22685) * 17)) % 65536 end
    _0x_decoy_trampoline_table[0x25] = function(_x, _y) return (((_x or 11576) * 31) + ((_y or 30028) * 17)) % 65536 end
    _0x_decoy_trampoline_table[0x26] = function(_x, _y) return (((_x or 16214) * 31) + ((_y or 13493) * 17)) % 65536 end
    _0x_decoy_trampoline_table[0x27] = function(_x, _y) return (((_x or 44227) * 31) + ((_y or 6246) * 17)) % 65536 end
    _0x_decoy_trampoline_table[0x28] = function(_x, _y) return (((_x or 39052) * 31) + ((_y or 64054) * 17)) % 65536 end
    _0x_decoy_trampoline_table[0x29] = function(_x, _y) return (((_x or 30782) * 31) + ((_y or 33927) * 17)) % 65536 end
    _0x_decoy_trampoline_table[0x2A] = function(_x, _y) return (((_x or 3122) * 31) + ((_y or 60007) * 17)) % 65536 end
    _0x_decoy_trampoline_table[0x2B] = function(_x, _y) return (((_x or 34917) * 31) + ((_y or 24012) * 17)) % 65536 end
    _0x_decoy_trampoline_table[0x2C] = function(_x, _y) return (((_x or 59590) * 31) + ((_y or 59836) * 17)) % 65536 end
    _0x_decoy_trampoline_table[0x2D] = function(_x, _y) return (((_x or 45344) * 31) + ((_y or 54422) * 17)) % 65536 end
    _0x_decoy_trampoline_table[0x2E] = function(_x, _y) return (((_x or 28153) * 31) + ((_y or 32559) * 17)) % 65536 end
    _0x_decoy_trampoline_table[0x2F] = function(_x, _y) return (((_x or 10672) * 31) + ((_y or 60308) * 17)) % 65536 end
    _0x_decoy_trampoline_table[0x30] = function(_x, _y) return (((_x or 7199) * 31) + ((_y or 60501) * 17)) % 65536 end
    _0x_decoy_trampoline_table[0x31] = function(_x, _y) return (((_x or 41537) * 31) + ((_y or 30244) * 17)) % 65536 end
    _0x_decoy_trampoline_table[0x32] = function(_x, _y) return (((_x or 44838) * 31) + ((_y or 57440) * 17)) % 65536 end
    _0x_decoy_trampoline_table[0x33] = function(_x, _y) return (((_x or 32605) * 31) + ((_y or 53331) * 17)) % 65536 end
    _0x_decoy_trampoline_table[0x34] = function(_x, _y) return (((_x or 9523) * 31) + ((_y or 29726) * 17)) % 65536 end
    _0x_decoy_trampoline_table[0x35] = function(_x, _y) return (((_x or 41206) * 31) + ((_y or 9086) * 17)) % 65536 end
    _0x_decoy_trampoline_table[0x36] = function(_x, _y) return (((_x or 41201) * 31) + ((_y or 41368) * 17)) % 65536 end
    _0x_decoy_trampoline_table[0x37] = function(_x, _y) return (((_x or 30602) * 31) + ((_y or 40519) * 17)) % 65536 end
    _0x_decoy_trampoline_table[0x38] = function(_x, _y) return (((_x or 23662) * 31) + ((_y or 47270) * 17)) % 65536 end
    _0x_decoy_trampoline_table[0x39] = function(_x, _y) return (((_x or 64912) * 31) + ((_y or 51691) * 17)) % 65536 end
    _0x_decoy_trampoline_table[0x3A] = function(_x, _y) return (((_x or 44766) * 31) + ((_y or 54277) * 17)) % 65536 end
    _0x_decoy_trampoline_table[0x3B] = function(_x, _y) return (((_x or 42664) * 31) + ((_y or 57265) * 17)) % 65536 end
    _0x_decoy_trampoline_table[0x3C] = function(_x, _y) return (((_x or 49524) * 31) + ((_y or 21554) * 17)) % 65536 end
    _0x_decoy_trampoline_table[0x3D] = function(_x, _y) return (((_x or 54437) * 31) + ((_y or 22138) * 17)) % 65536 end
    _0x_decoy_trampoline_table[0x3E] = function(_x, _y) return (((_x or 51604) * 31) + ((_y or 31903) * 17)) % 65536 end
    _0x_decoy_trampoline_table[0x3F] = function(_x, _y) return (((_x or 3831) * 31) + ((_y or 20445) * 17)) % 65536 end
    _0x_decoy_trampoline_table[0x40] = function(_x, _y) return (((_x or 45217) * 31) + ((_y or 33107) * 17)) % 65536 end
    _0x_decoy_trampoline_table[0x41] = function(_x, _y) return (((_x or 53411) * 31) + ((_y or 31425) * 17)) % 65536 end
    _0x_decoy_trampoline_table[0x42] = function(_x, _y) return (((_x or 34192) * 31) + ((_y or 4615) * 17)) % 65536 end
    _0x_decoy_trampoline_table[0x43] = function(_x, _y) return (((_x or 41241) * 31) + ((_y or 9405) * 17)) % 65536 end
    _0x_decoy_trampoline_table[0x44] = function(_x, _y) return (((_x or 44030) * 31) + ((_y or 25268) * 17)) % 65536 end
    _0x_decoy_trampoline_table[0x45] = function(_x, _y) return (((_x or 7414) * 31) + ((_y or 44889) * 17)) % 65536 end
    _0x_decoy_trampoline_table[0x46] = function(_x, _y) return (((_x or 30963) * 31) + ((_y or 13181) * 17)) % 65536 end
    _0x_decoy_trampoline_table[0x47] = function(_x, _y) return (((_x or 11858) * 31) + ((_y or 57545) * 17)) % 65536 end
    _0x_decoy_trampoline_table[0x48] = function(_x, _y) return (((_x or 19899) * 31) + ((_y or 14632) * 17)) % 65536 end
    _0x_decoy_trampoline_table[0x49] = function(_x, _y) return (((_x or 36912) * 31) + ((_y or 29755) * 17)) % 65536 end
    _0x_decoy_trampoline_table[0x4A] = function(_x, _y) return (((_x or 14510) * 31) + ((_y or 41864) * 17)) % 65536 end
    _0x_decoy_trampoline_table[0x4B] = function(_x, _y) return (((_x or 32137) * 31) + ((_y or 37305) * 17)) % 65536 end
    _0x_decoy_trampoline_table[0x4C] = function(_x, _y) return (((_x or 14462) * 31) + ((_y or 62712) * 17)) % 65536 end
    _0x_decoy_trampoline_table[0x4D] = function(_x, _y) return (((_x or 36130) * 31) + ((_y or 3456) * 17)) % 65536 end
    _0x_decoy_trampoline_table[0x4E] = function(_x, _y) return (((_x or 44061) * 31) + ((_y or 36478) * 17)) % 65536 end
    _0x_decoy_trampoline_table[0x4F] = function(_x, _y) return (((_x or 48281) * 31) + ((_y or 63638) * 17)) % 65536 end

    local _unpack = unpack or table.unpack

    local function _RunProto(proto, env, upvalues, ...)
        local code = proto.c
        local k    = proto.k
        local protos = proto.p
        local pc   = 1
        local stack= {}
        local varargs = { ... }

        for i = 1, #varargs do
            stack[i - 1] = varargs[i]
        end

        local openUpvals = {}

        local function getRK(idx)
            if idx >= 256 then
                return k[idx - 255]
            else
                return stack[idx]
            end
        end

        while true do
            local inst = code[pc]
            if not inst then break end
            pc = pc + 1

            local op = inst[1]
            local a  = inst[2]
            local b  = inst[3]
            local c  = inst[4]
            local bx = inst[5]
            local sbx= inst[6]

            if op == 0x4A then
                stack[a] = stack[b]
            elseif op == 0x1F then
                stack[a] = k[bx + 1]
            elseif op == 0x6D then
                stack[a] = (b ~= 0)
                if c ~= 0 then pc = pc + 1 end
            elseif op == 0x91 then
                for i = a, a + b do stack[i] = nil end
            elseif op == 0x24 then
                local uv = upvalues[b + 1]
                stack[a] = uv and uv[1]
            elseif op == 0xB7 then
                local uv = upvalues[b + 1]
                local t = uv and uv[1]
                stack[a] = t and t[getRK(c)]
            elseif op == 0x3E then
                stack[a] = stack[b][getRK(c)]
            elseif op == 0xC5 then
                local uv = upvalues[a + 1]
                local t = uv and uv[1]
                if t then t[getRK(b)] = getRK(c) end
            elseif op == 0x58 then
                local uv = upvalues[b + 1]
                if uv then uv[1] = stack[a] end
            elseif op == 0x73 then
                stack[a][getRK(b)] = getRK(c)
            elseif op == 0xAA then
                stack[a] = {}
            elseif op == 0x16 then
                stack[a + 1] = stack[b]
                stack[a] = stack[b][getRK(c)]
            elseif op == 0x2D then
                stack[a] = getRK(b) + getRK(c)
            elseif op == 0x61 then
                stack[a] = getRK(b) - getRK(c)
            elseif op == 0x8B then
                stack[a] = getRK(b) * getRK(c)
            elseif op == 0x42 then
                stack[a] = getRK(b) / getRK(c)
            elseif op == 0x59 then
                stack[a] = getRK(b) % getRK(c)
            elseif op == 0x7E then
                stack[a] = getRK(b) ^ getRK(c)
            elseif op == 0x93 then
                stack[a] = -stack[b]
            elseif op == 0xA8 then
                stack[a] = not stack[b]
            elseif op == 0xBD then
                stack[a] = #stack[b]
            elseif op == 0x34 then
                local res = ""
                for i = b, c do res = res .. tostring(stack[i]) end
                stack[a] = res
            elseif op == 0x11 then
                pc = pc + sbx
            elseif op == 0x4F then
                if (getRK(b) == getRK(c)) ~= (a ~= 0) then pc = pc + 1 end
            elseif op == 0x85 then
                if (getRK(b) < getRK(c)) ~= (a ~= 0) then pc = pc + 1 end
            elseif op == 0xBA then
                if (getRK(b) <= getRK(c)) ~= (a ~= 0) then pc = pc + 1 end
            elseif op == 0x29 then
                if (not not stack[a]) ~= (c ~= 0) then pc = pc + 1 end
            elseif op == 0x5C then
                if (not not stack[b]) ~= (c ~= 0) then
                    stack[a] = stack[b]
                    pc = pc + 1
                end
            elseif op == 0x9A or op == 0x71 then
                local f = stack[a]
                local args = {}
                local numArgs = 0
                if b == 0 then
                    local top = a + 1
                    while stack[top] ~= nil do
                        numArgs = numArgs + 1
                        args[numArgs] = stack[top]
                        top = top + 1
                    end
                else
                    numArgs = b - 1
                    for i = 1, numArgs do
                        args[i] = stack[a + i]
                    end
                end
                local rets = { f(_unpack(args, 1, numArgs)) }
                if c == 0 then
                    for i = 1, #rets do stack[a + i - 1] = rets[i] end
                elseif c > 1 then
                    for i = 1, c - 1 do stack[a + i - 1] = rets[i] end
                end
            elseif op == 0x37 then
                local rets = {}
                local nret = b - 1
                if b == 0 then
                    local top = a
                    local cnt = 0
                    while stack[top] ~= nil do
                        cnt = cnt + 1
                        rets[cnt] = stack[top]
                        top = top + 1
                    end
                    return _unpack(rets, 1, cnt)
                else
                    for i = 1, nret do
                        rets[i] = stack[a + i - 1]
                    end
                    return _unpack(rets, 1, nret)
                end
            elseif op == 0x83 then
                stack[a] = stack[a] - stack[a + 2]
                pc = pc + sbx
            elseif op == 0x6E then
                local step = stack[a + 2]
                local idx = stack[a] + step
                local limit = stack[a + 1]
                if (step > 0 and idx <= limit) or (step < 0 and idx >= limit) then
                    stack[a] = idx
                    stack[a + 3] = idx
                    pc = pc + sbx
                end
            elseif op == 0xA2 then
                local f = stack[a]
                local s = stack[a + 1]
                local var = stack[a + 2]
                local rets = { f(s, var) }
                for i = 1, c do stack[a + 2 + i] = rets[i] end
            elseif op == 0xB9 then
                if stack[a + 1] ~= nil then
                    stack[a] = stack[a + 1]
                    pc = pc + sbx
                end
            elseif op == 0xC8 then
                local n = b
                local cIdx = c
                if n == 0 then n = #stack - a end
                if cIdx == 0 then cIdx = code[pc][5]; pc = pc + 1 end
                local startIdx = (cIdx - 1) * 50
                for i = 1, n do
                    stack[a][startIdx + i] = stack[a + i]
                end
            elseif op == 0x14 then
                local subProto = protos[bx + 1]
                local subUpvals = {}
                for i = 1, #subProto.u do
                    local uvInfo = subProto.u[i]
                    if uvInfo[1] == 1 then
                        local reg = uvInfo[2]
                        if not openUpvals[reg] then
                            openUpvals[reg] = { stack[reg] }
                        else
                            openUpvals[reg][1] = stack[reg]
                        end
                        subUpvals[i] = openUpvals[reg]
                    else
                        subUpvals[i] = upvalues[uvInfo[2] + 1]
                    end
                end
                stack[a] = function(...)
                    for reg, cell in pairs(openUpvals) do
                        cell[1] = stack[reg]
                    end
                    local rets = { _RunProto(subProto, env, subUpvals, ...) }
                    for reg, cell in pairs(openUpvals) do
                        stack[reg] = cell[1]
                    end
                    return _unpack(rets, 1, #rets)
                end
            elseif op == 0x3B then
                local num = b - 1
                if b == 0 then
                    for i = 1, #varargs do stack[a + i - 1] = varargs[i] end
                else
                    for i = 1, num do stack[a + i - 1] = varargs[i] end
                end
            end
        end
    end

    local _MZ_ROOT_PROTO = {
        c = { {0x1F,0,0,0,0,-131071},{0x4A,1,0,0,0,-131071},{0x1F,2,0,1,1,-131070},{0x34,1,1,2,514,-130557},{0x1F,2,0,2,2,-131069},{0xB7,3,0,259,259,-130812},{0x16,3,3,260,1796,-129275},{0x1F,5,0,5,5,-131066},{0x9A,3,3,2,1538,-129533},{0xB7,4,0,259,259,-130812},{0x16,4,4,260,2308,-128763},{0x1F,6,0,6,6,-131065},{0x9A,4,3,2,1538,-129533},{0xB7,5,0,259,259,-130812},{0x16,5,5,260,2820,-128251},{0x1F,7,0,7,7,-131064},{0x9A,5,3,2,1538,-129533},{0xB7,6,0,259,259,-130812},{0x16,6,6,260,3332,-127739},{0x1F,8,0,8,8,-131063},{0x9A,6,3,2,1538,-129533},{0xB7,7,0,259,259,-130812},{0x16,7,7,260,3844,-127227},{0x1F,9,0,9,9,-131062},{0x9A,7,3,2,1538,-129533},{0xB7,8,0,259,259,-130812},{0x16,8,8,260,4356,-126715},{0x1F,10,0,10,10,-131061},{0x9A,8,3,2,1538,-129533},{0x3E,9,3,267,1803,-129268},{0x14,10,0,0,0,-131071},{0x4A,11,10,0,5120,-125951},{0x9A,11,1,3,515,-130556},{0x29,11,0,1,1,-131070},{0x11,0,256,7,131079,8},{0xB7,13,0,268,268,-130803},{0x1F,14,0,13,13,-131058},{0xB7,15,0,270,270,-130801},{0x4A,16,12,0,6144,-124927},{0x9A,15,2,2,1026,-130045},{0x34,14,14,15,7183,-123888},{0x9A,13,2,1,1025,-130046},{0x37,0,1,0,512,-130559},{0x14,13,0,1,1,-131070},{0x14,14,0,2,2,-131069},{0x4A,15,14,0,7168,-123903},{0x9A,15,1,2,514,-130557},{0x14,16,0,3,3,-131068},{0x14,17,0,4,4,-131067},{0xAA,18,0,4,4,-131067},{0x73,18,271,272,139024,7953},{0x73,18,273,272,140048,8977},{0x73,18,274,272,140560,9489},{0x73,18,275,276,141076,10005},{0x14,19,0,5,5,-131066},{0x14,20,0,6,6,-131065},{0x14,21,0,7,7,-131064},{0xAA,22,5,0,2560,-128511},{0xAA,23,0,4,4,-131067},{0x73,23,277,278,142102,11031},{0x73,23,279,280,143128,12057},{0x73,23,281,282,144154,13083},{0x14,24,0,8,8,-131063},{0x73,23,283,24,144920,13849},{0xAA,24,0,4,4,-131067},{0x73,24,277,284,142108,11037},{0x73,24,279,285,143133,12062},{0x73,24,281,286,144158,13087},{0x14,25,0,9,9,-131062},{0x73,24,283,25,144921,13850},{0xAA,25,0,4,4,-131067},{0x73,25,277,287,142111,11040},{0x73,25,279,288,143136,12065},{0x73,25,281,289,144161,13090},{0x14,26,0,10,10,-131061},{0x73,25,283,26,144922,13851},{0xAA,26,0,4,4,-131067},{0x73,26,277,290,142114,11043},{0x73,26,279,291,143139,12068},{0x73,26,281,292,144164,13093},{0x14,27,0,11,11,-131060},{0x73,26,283,27,144923,13852},{0xAA,27,0,4,4,-131067},{0x73,27,277,293,142117,11046},{0x73,27,279,294,143142,12071},{0x73,27,281,295,144167,13096},{0x14,28,0,12,12,-131059},{0x73,27,283,28,144924,13853},{0xC8,22,5,1,2561,-128510},{0x14,23,0,13,13,-131058},{0x14,24,0,14,14,-131057},{0x91,25,0,0,0,-131071},{0x14,26,0,15,15,-131056},{0x4A,25,26,0,13312,-117759},{0x14,26,0,16,16,-131055},{0x14,27,0,17,17,-131054},{0x4A,28,27,0,13824,-117247},{0x9A,28,1,1,513,-130558},{0x37,0,1,0,512,-130559} },
        k = { "https://mintrazerx-keysystem-wf4n.onrender.com","/redeem","mintrazerx_key","game","GetService","Players","HttpService","MarketplaceService","TeleportService","TweenService","CoreGui","LocalPlayer","warn","[MintraZERX Security Guard] Environment integrity check failed: ","tostring","Token",nil,"Key","TargetKey","ExpiresAt",0,"Id","thelostfront","Name","The Lost Front","PlaceId",72299838142412,"IsActive","formulaapex","Formula Apex",5976159288,"scproleplay","SCP: Roleplay",5041144419,"zosamurai","ZO Samurai",6678877691,"bladeball","Blade Ball",13772394625 },
        p = { {
        c = { {0xB7,0,0,256,256,-130815},{0xB7,1,0,257,257,-130814},{0x9A,0,2,2,1026,-130045},{0x4F,0,0,258,258,-130813},{0x11,0,256,35,131107,36},{0xB7,0,0,259,259,-130812},{0x29,0,0,0,0,-131071},{0x11,0,256,7,131079,8},{0xB7,0,0,259,259,-130812},{0xB7,1,0,257,257,-130814},{0x9A,0,2,2,1026,-130045},{0x29,0,0,0,0,-131071},{0x11,0,256,2,131074,3},{0x6D,0,0,0,0,-131071},{0x1F,1,0,4,4,-131067},{0x37,0,3,0,1536,-129535},{0xB7,0,0,261,261,-130810},{0x29,0,0,0,0,-131071},{0x11,0,256,21,131093,22},{0xB7,0,0,261,261,-130810},{0x3E,0,0,262,262,-130809},{0x29,0,0,0,0,-131071},{0x11,0,256,17,131089,18},{0xB7,0,0,261,261,-130810},{0x3E,0,0,262,262,-130809},{0xB7,1,0,257,257,-130814},{0x9A,0,2,2,1026,-130045},{0x29,0,0,0,0,-131071},{0x11,0,256,11,131083,12},{0x3E,1,0,263,263,-130808},{0x4F,1,1,264,776,-130295},{0x11,0,256,5,131077,6},{0x3E,1,0,265,265,-130806},{0x29,1,0,0,0,-131071},{0x11,0,256,5,131077,6},{0x3E,1,0,265,265,-130806},{0x85,0,266,1,136193,5122},{0x11,0,256,2,131074,3},{0x6D,1,0,0,0,-131071},{0x1F,2,0,11,11,-131060},{0x37,1,3,0,1536,-129535},{0xB7,0,0,261,261,-130810},{0x29,0,0,0,0,-131071},{0x11,0,256,15,131087,16},{0xB7,0,0,261,261,-130810},{0x3E,0,0,262,262,-130809},{0x29,0,0,0,0,-131071},{0x11,0,256,11,131083,12},{0xB7,0,0,259,259,-130812},{0x29,0,0,0,0,-131071},{0x11,0,256,8,131080,9},{0xB7,0,0,259,259,-130812},{0xB7,1,0,261,261,-130810},{0x3E,1,1,262,774,-130297},{0x9A,0,2,2,1026,-130045},{0x29,0,0,0,0,-131071},{0x11,0,256,2,131074,3},{0x6D,0,0,0,0,-131071},{0x1F,1,0,12,12,-131059},{0x37,0,3,0,1536,-129535},{0xB7,0,0,269,269,-130802},{0x29,0,0,0,0,-131071},{0x11,0,256,32,131104,33},{0xB7,0,0,269,269,-130802},{0xB7,1,0,270,270,-130801},{0x9A,0,2,2,1026,-130045},{0x4F,0,0,271,271,-130800},{0x11,0,256,27,131099,28},{0xB7,0,0,272,272,-130799},{0x29,0,0,0,0,-131071},{0x11,0,256,24,131096,25},{0xB7,0,0,273,273,-130798},{0xB7,1,0,272,272,-130799},{0xB7,2,0,270,270,-130801},{0x9A,0,3,3,1539,-129532},{0x29,0,0,0,0,-131071},{0x11,0,256,18,131090,19},{0xB7,2,0,256,256,-130815},{0x4A,3,1,0,512,-130559},{0x9A,2,2,2,1026,-130045},{0x4F,0,2,274,1298,-129773},{0x11,0,256,13,131085,14},{0x3E,2,1,275,787,-130284},{0x29,2,0,0,0,-131071},{0x11,0,256,10,131082,11},{0xB7,2,0,259,259,-130812},{0x29,2,0,0,0,-131071},{0x11,0,256,7,131079,8},{0xB7,2,0,259,259,-130812},{0x3E,3,1,275,787,-130284},{0x9A,2,2,2,1026,-130045},{0x29,2,0,0,0,-131071},{0x11,0,256,2,131074,3},{0x6D,2,0,0,0,-131071},{0x1F,3,0,20,20,-131051},{0x37,2,3,0,1536,-129535},{0xAA,0,7,0,3584,-127487},{0x1F,1,0,21,21,-131050},{0x1F,2,0,22,22,-131049},{0x1F,3,0,23,23,-131048},{0x1F,4,0,24,24,-131047},{0x1F,5,0,25,25,-131046},{0x1F,6,0,26,26,-131045},{0x1F,7,0,27,27,-131044},{0xC8,0,7,1,3585,-127486},{0xB7,1,0,284,284,-130787},{0x29,1,0,0,0,-131071},{0x11,0,256,3,131075,4},{0xB7,1,0,284,284,-130787},{0x9A,1,1,2,514,-130557},{0x29,1,0,1,1,-131070},{0x11,0,256,0,131072,1},{0xB7,1,0,285,285,-130786},{0xB7,2,0,286,286,-130785},{0x4A,3,0,0,0,-131071},{0x9A,2,2,4,1028,-130043},{0x11,0,256,15,131087,16},{0x3E,7,1,6,518,-130553},{0x4F,0,7,287,3871,-127200},{0x11,0,256,6,131078,7},{0xB7,7,0,285,285,-130786},{0x29,7,0,0,0,-131071},{0x11,0,256,9,131081,10},{0xB7,7,0,285,285,-130786},{0x3E,7,7,6,3590,-127481},{0x4F,1,7,287,3871,-127200},{0x11,0,256,5,131077,6},{0x6D,7,0,0,0,-131071},{0x1F,8,0,32,32,-131039},{0x4A,9,6,0,3072,-127999},{0x1F,10,0,33,33,-131038},{0x34,8,8,10,4106,-126965},{0x37,7,3,0,1536,-129535},{0xA2,2,0,2,2,-131069},{0xB9,4,255,493,131053,-18},{0x6D,2,1,0,512,-130559},{0x1F,3,0,34,34,-131037},{0x37,2,3,0,1536,-129535},{0x37,0,1,0,512,-130559} },
        k = { "type","loadstring","function","islclosure","SECURITY_VIOLATION: loadstring is intercepted by a Lua closure","debug","getinfo","what","Lua","linedefined",0,"SECURITY_VIOLATION: loadstring tampered with external Lua hook","SECURITY_VIOLATION: debug.getinfo has been modified","typeof","game","Instance","getrawmetatable","pcall","table","__namecall","SECURITY_VIOLATION: game metatable __namecall is hooked","_DEBUG_LOG","SIMPLESPY","HYDROXIDE","TURTLE_SPY","_DUMP_PAYLOAD","ScriptDumper","DexOutput","getfenv","_G","ipairs",nil,"SECURITY_TRAP: Hostile inspection tool detected (",")","INTEGRITY_VERIFIED" },
        p = {  },
        u = { {0,0} },
        np = 0,
        va = 0
    },{
        c = { {0x91,1,0,0,0,-131071},{0xB7,2,0,256,256,-130815},{0xB7,3,0,257,257,-130814},{0x9A,2,2,2,1026,-130045},{0x4F,0,2,258,1282,-129789},{0x11,0,256,9,131081,10},{0xB7,2,0,259,259,-130812},{0xB7,3,0,257,257,-130814},{0x4A,4,0,0,0,-131071},{0x9A,2,3,3,1539,-129532},{0x29,2,0,0,0,-131071},{0x11,0,256,57,131129,58},{0x29,3,0,0,0,-131071},{0x11,0,256,55,131127,56},{0x4A,1,3,0,1536,-129535},{0x11,0,256,53,131125,54},{0xB7,2,0,256,256,-130815},{0xB7,3,0,260,260,-130811},{0x9A,2,2,2,1026,-130045},{0x4F,0,2,258,1282,-129789},{0x11,0,256,9,131081,10},{0xB7,2,0,259,259,-130812},{0xB7,3,0,260,260,-130811},{0x4A,4,0,0,0,-131071},{0x9A,2,3,3,1539,-129532},{0x29,2,0,0,0,-131071},{0x11,0,256,42,131114,43},{0x29,3,0,0,0,-131071},{0x11,0,256,40,131112,41},{0x4A,1,3,0,1536,-129535},{0x11,0,256,38,131110,39},{0xB7,2,0,261,261,-130810},{0x29,2,0,0,0,-131071},{0x11,0,256,14,131086,15},{0xB7,2,0,261,261,-130810},{0x3E,2,2,257,1281,-129790},{0x29,2,0,0,0,-131071},{0x11,0,256,10,131082,11},{0xB7,2,0,259,259,-130812},{0xB7,3,0,261,261,-130810},{0x3E,3,3,257,1793,-129278},{0x4A,4,0,0,0,-131071},{0x9A,2,3,3,1539,-129532},{0x29,2,0,0,0,-131071},{0x11,0,256,24,131096,25},{0x29,3,0,0,0,-131071},{0x11,0,256,22,131094,23},{0x4A,1,3,0,1536,-129535},{0x11,0,256,20,131092,21},{0xB7,2,0,256,256,-130815},{0xB7,3,0,262,262,-130809},{0x9A,2,2,2,1026,-130045},{0x4F,0,2,263,1287,-129784},{0x11,0,256,15,131087,16},{0xB7,2,0,256,256,-130815},{0xB7,3,0,262,262,-130809},{0x3E,3,3,257,1793,-129278},{0x9A,2,2,2,1026,-130045},{0x4F,0,2,258,1282,-129789},{0x11,0,256,9,131081,10},{0xB7,2,0,259,259,-130812},{0xB7,3,0,262,262,-130809},{0x3E,3,3,257,1793,-129278},{0x4A,4,0,0,0,-131071},{0x9A,2,3,3,1539,-129532},{0x29,2,0,0,0,-131071},{0x11,0,256,2,131074,3},{0x29,3,0,0,0,-131071},{0x11,0,256,0,131072,1},{0x4A,1,3,0,1536,-129535},{0x29,1,0,0,0,-131071},{0x11,0,256,5,131077,6},{0x3E,2,1,264,776,-130295},{0x29,2,0,0,0,-131071},{0x11,0,256,22,131094,23},{0x3E,2,1,264,776,-130295},{0x4F,1,2,265,1289,-129782},{0x11,0,256,19,131091,20},{0x3E,2,0,266,266,-130805},{0x4F,1,2,267,1291,-129780},{0x11,0,256,2,131074,3},{0x3E,2,0,266,266,-130805},{0x29,2,0,1,1,-131070},{0x11,0,256,13,131085,14},{0xB7,2,0,259,259,-130812},{0x14,3,0,0,0,-131071},{0x9A,2,2,3,1027,-130044},{0x29,2,0,0,0,-131071},{0x11,0,256,8,131080,9},{0x29,3,0,0,0,-131071},{0x11,0,256,6,131078,7},{0xBD,4,3,0,1536,-129535},{0x85,0,268,4,137220,6149},{0x11,0,256,3,131075,4},{0xAA,4,0,2,2,-131069},{0x73,4,264,265,135433,4362},{0x73,4,269,3,137731,6660},{0x4A,1,4,0,2048,-129023},{0x29,1,0,0,0,-131071},{0x11,0,256,32,131104,33},{0x3E,2,1,264,776,-130295},{0x29,2,0,1,1,-131070},{0x11,0,256,9,131081,10},{0x3E,2,1,270,782,-130289},{0x29,2,0,1,1,-131070},{0x11,0,256,6,131078,7},{0x3E,2,1,271,783,-130288},{0x29,2,0,1,1,-131070},{0x11,0,256,3,131075,4},{0x3E,2,1,272,784,-130287},{0x29,2,0,1,1,-131070},{0x11,0,256,0,131072,1},{0x1F,2,0,9,9,-131062},{0x3E,3,1,269,781,-130290},{0x29,3,0,1,1,-131070},{0x11,0,256,3,131075,4},{0x3E,3,1,273,785,-130286},{0x29,3,0,1,1,-131070},{0x11,0,256,0,131072,1},{0x1F,3,0,18,18,-131053},{0xAA,4,0,2,2,-131069},{0xB7,5,0,275,275,-130796},{0x4A,6,2,0,1024,-130047},{0x9A,5,2,2,1026,-130045},{0x29,5,0,1,1,-131070},{0x11,0,256,0,131072,1},{0x1F,5,0,9,9,-131062},{0x73,4,264,5,135173,4102},{0xB7,5,0,276,276,-130795},{0x4A,6,3,0,1536,-129535},{0x9A,5,2,2,1026,-130045},{0x73,4,269,5,137733,6662},{0x37,4,2,0,1024,-130047},{0xAA,2,0,2,2,-131069},{0x73,2,264,277,135445,4374},{0x73,2,269,278,138006,6935},{0x37,2,2,0,1024,-130047},{0x37,0,1,0,512,-130559} },
        k = { "type","request","function","pcall","http_request","syn","fluxus","table","StatusCode",200,"Method","GET",0,"Body","status_code","status","statusCode","body","","tonumber","tostring",500,"No HTTP method available" },
        p = { {
        c = { {0xB7,0,0,256,256,-130815},{0x16,0,0,257,257,-130814},{0xB7,2,1,258,770,-130301},{0x71,0,3,0,1536,-129535},{0x37,0,0,0,0,-131071},{0x37,0,1,0,512,-130559} },
        k = { "game","HttpGet","Url" },
        p = {  },
        u = { {0,0},{1,0} },
        np = 0,
        va = 0
    } },
        u = { {0,0} },
        np = 1,
        va = 0
    },{
        c = { {0x1F,0,0,0,0,-131071},{0xB7,1,0,257,257,-130814},{0xB7,2,0,258,258,-130813},{0x9A,1,2,2,1026,-130045},{0x4F,0,1,259,771,-130300},{0x11,0,256,13,131085,14},{0xB7,1,0,260,260,-130811},{0xB7,2,0,258,258,-130813},{0x9A,1,2,3,1027,-130044},{0x29,1,0,0,0,-131071},{0x11,0,256,8,131080,9},{0xB7,3,0,257,257,-130814},{0x4A,4,2,0,1024,-130047},{0x9A,3,2,2,1026,-130045},{0x4F,0,3,261,1797,-129274},{0x11,0,256,3,131075,4},{0xBD,3,2,0,1024,-130047},{0x85,0,262,3,134147,3076},{0x11,0,256,0,131072,1},{0x37,2,2,0,1024,-130047},{0xB7,1,0,257,257,-130814},{0xB7,2,0,263,263,-130808},{0x9A,1,2,2,1026,-130045},{0x4F,0,1,259,771,-130300},{0x11,0,256,13,131085,14},{0xB7,1,0,260,260,-130811},{0xB7,2,0,263,263,-130808},{0x9A,1,2,3,1027,-130044},{0x29,1,0,0,0,-131071},{0x11,0,256,8,131080,9},{0xB7,3,0,257,257,-130814},{0x4A,4,2,0,1024,-130047},{0x9A,3,2,2,1026,-130045},{0x4F,0,3,261,1797,-129274},{0x11,0,256,3,131075,4},{0xBD,3,2,0,1024,-130047},{0x85,0,262,3,134147,3076},{0x11,0,256,0,131072,1},{0x37,2,2,0,1024,-130047},{0xB7,1,0,260,260,-130811},{0x14,2,0,0,0,-131071},{0x9A,1,2,3,1027,-130044},{0x29,1,0,0,0,-131071},{0x11,0,256,8,131080,9},{0xB7,3,0,257,257,-130814},{0x4A,4,2,0,1024,-130047},{0x9A,3,2,2,1026,-130045},{0x4F,0,3,261,1797,-129274},{0x11,0,256,3,131075,4},{0xBD,3,2,0,1024,-130047},{0x85,0,262,3,134147,3076},{0x11,0,256,0,131072,1},{0x37,2,2,0,1024,-130047},{0x24,3,1,0,512,-130559},{0x29,3,0,0,0,-131071},{0x11,0,256,6,131078,7},{0xB7,3,1,264,776,-130295},{0x29,3,0,0,0,-131071},{0x11,0,256,3,131075,4},{0xB7,3,0,265,265,-130806},{0xB7,4,1,264,776,-130295},{0x71,3,2,0,1024,-130047},{0x37,3,0,0,0,-131071},{0x1F,3,0,10,10,-131061},{0x37,3,2,0,1024,-130047},{0x37,0,1,0,512,-130559} },
        k = { "","type","gethwid","function","pcall","string",5,"rbx_gethwid","UserId","tostring","UNKNOWN_ROBLOX_DEVICE" },
        p = { {
        c = { {0xB7,0,0,256,256,-130815},{0x16,0,0,257,257,-130814},{0x1F,2,0,2,2,-131069},{0x9A,0,3,2,1538,-129533},{0x16,0,0,259,259,-130812},{0x71,0,2,0,1024,-130047},{0x37,0,0,0,0,-131071},{0x37,0,1,0,512,-130559} },
        k = { "game","GetService","RbxAnalyticsService","GetClientId" },
        p = {  },
        u = { {0,0} },
        np = 0,
        va = 0
    } },
        u = { {0,0},{1,9} },
        np = 0,
        va = 0
    },{
        c = { {0x29,0,0,0,0,-131071},{0x11,0,256,2,131074,3},{0xBD,1,0,0,0,-131071},{0x85,0,1,256,768,-130303},{0x11,0,256,3,131075,4},{0x6D,1,0,0,0,-131071},{0x1F,2,0,1,1,-131070},{0x91,3,0,0,0,-131071},{0x37,1,4,0,2048,-129023},{0xB7,1,0,258,258,-130813},{0x4A,2,0,0,0,-131071},{0x9A,1,2,2,1026,-130045},{0x16,1,1,259,771,-130300},{0x1F,3,0,4,4,-131067},{0x1F,4,0,5,5,-131066},{0x9A,1,4,2,2050,-129021},{0x16,1,1,262,774,-130297},{0x9A,1,2,2,1026,-130045},{0x16,2,1,259,771,-130300},{0x1F,4,0,7,7,-131064},{0x1F,5,0,5,5,-131066},{0x9A,2,4,2,2050,-129021},{0x4F,1,2,264,1288,-129783},{0x11,0,256,10,131082,11},{0x4F,1,2,265,1289,-129782},{0x11,0,256,8,131080,9},{0x4F,1,2,266,1290,-129781},{0x11,0,256,6,131078,7},{0x4F,1,2,267,1291,-129780},{0x11,0,256,4,131076,5},{0x4F,1,2,268,1292,-129779},{0x11,0,256,2,131074,3},{0x4F,1,2,269,1293,-129778},{0x11,0,256,0,131072,1},{0x6D,3,0,1,1,-131070},{0x6D,3,1,0,512,-130559},{0x24,4,1,0,512,-130559},{0x1F,5,0,14,14,-131057},{0x24,6,2,0,1024,-130047},{0x16,6,6,271,3343,-127728},{0x4A,8,1,0,512,-130559},{0x9A,6,3,2,1538,-129533},{0x1F,7,0,16,16,-131055},{0x24,8,2,0,1024,-130047},{0x16,8,8,271,4367,-126704},{0x24,10,3,0,1536,-129535},{0x9A,8,3,2,1538,-129533},{0x34,4,4,8,2056,-129015},{0x24,5,4,0,2048,-129023},{0xAA,6,0,2,2,-131069},{0x73,6,273,4,139780,8709},{0x73,6,274,275,140563,9492},{0x9A,5,2,2,1026,-130045},{0x29,5,0,0,0,-131071},{0x11,0,256,40,131112,41},{0x3E,6,5,276,2836,-128235},{0x4F,0,6,277,3349,-127722},{0x11,0,256,37,131109,38},{0x3E,6,5,278,2838,-128233},{0x29,6,0,0,0,-131071},{0x11,0,256,34,131106,35},{0x3E,6,5,278,2838,-128233},{0xBD,6,6,0,3072,-127999},{0x85,0,279,6,142854,11783},{0x11,0,256,30,131102,31},{0xB7,6,0,280,280,-130791},{0x14,7,0,0,0,-131071},{0x9A,6,2,3,1027,-130044},{0x29,6,0,0,0,-131071},{0x11,0,256,25,131097,26},{0x29,7,0,0,0,-131071},{0x11,0,256,23,131095,24},{0x3E,8,7,281,3865,-127206},{0x4F,0,8,282,4378,-126693},{0x11,0,256,4,131076,5},{0x6D,8,1,0,512,-130559},{0x1F,9,0,27,27,-131044},{0x4A,10,7,0,3584,-127487},{0x37,8,4,0,2048,-129023},{0x11,0,256,15,131087,16},{0x29,3,0,0,0,-131071},{0x11,0,256,6,131078,7},{0x6D,8,1,0,512,-130559},{0x1F,9,0,28,28,-131043},{0xAA,10,0,3,3,-131068},{0x73,10,281,282,144154,13083},{0x73,10,285,286,146206,15135},{0x73,10,287,282,147226,16155},{0x37,8,4,0,2048,-129023},{0x6D,8,0,0,0,-131071},{0x3E,9,7,288,3872,-127199},{0x29,9,0,1,1,-131070},{0x11,0,256,0,131072,1},{0x1F,9,0,33,33,-131038},{0x4A,10,7,0,3584,-127487},{0x37,8,4,0,2048,-129023},{0x29,3,0,0,0,-131071},{0x11,0,256,6,131078,7},{0x6D,6,1,0,512,-130559},{0x1F,7,0,34,34,-131037},{0xAA,8,0,3,3,-131068},{0x73,8,281,282,144154,13083},{0x73,8,285,286,146206,15135},{0x73,8,287,282,147226,16155},{0x37,6,4,0,2048,-129023},{0x29,5,0,0,0,-131071},{0x11,0,256,20,131092,21},{0x3E,6,5,278,2838,-128233},{0x29,6,0,0,0,-131071},{0x11,0,256,17,131089,18},{0x3E,6,5,278,2838,-128233},{0xBD,6,6,0,3072,-127999},{0x85,0,279,6,142854,11783},{0x11,0,256,13,131085,14},{0xB7,6,0,280,280,-130791},{0x14,7,0,1,1,-131070},{0x9A,6,2,3,1027,-130044},{0x29,6,0,0,0,-131071},{0x11,0,256,8,131080,9},{0x29,7,0,0,0,-131071},{0x11,0,256,6,131078,7},{0x3E,8,7,288,3872,-127199},{0x29,8,0,0,0,-131071},{0x11,0,256,3,131075,4},{0x6D,8,0,0,0,-131071},{0x3E,9,7,288,3872,-127199},{0x4A,10,7,0,3584,-127487},{0x37,8,4,0,2048,-129023},{0x6D,6,0,0,0,-131071},{0x1F,7,0,35,35,-131036},{0xB7,8,0,258,258,-130813},{0x29,5,0,0,0,-131071},{0x11,0,256,2,131074,3},{0x3E,9,5,276,2836,-128235},{0x29,9,0,1,1,-131070},{0x11,0,256,0,131072,1},{0x1F,9,0,36,36,-131035},{0x9A,8,2,2,1026,-130045},{0x1F,9,0,37,37,-131034},{0x34,7,7,9,3593,-127478},{0x91,8,0,0,0,-131071},{0x37,6,4,0,2048,-129023},{0x37,0,1,0,512,-130559} },
        k = { 4,"Key too short","tostring","gsub","%s+","","upper","[^A-Z0-9]","MINTRAZERXVIP2026","MINTRAZERXLIFETIME","BOTVIP2026","KEYVIP2026","VALEXCRYZERVIP","MINTRAZERX8GKWJF6R9R29","/api/client/verify?key=","UrlEncode","&hwid=","Url","Method","GET","StatusCode",200,"Body",2,"pcall","valid",true,"Key Validated","Master VIP Validated","tier","VIP","isLifetime","message","Invalid Key","Master VIP Offline Validated","Connection failed (",0,")" },
        p = { {
        c = { {0x24,0,0,0,0,-131071},{0x16,0,0,256,256,-130815},{0xB7,2,1,257,769,-130302},{0x71,0,3,0,1536,-129535},{0x37,0,0,0,0,-131071},{0x37,0,1,0,512,-130559} },
        k = { "JSONDecode","Body" },
        p = {  },
        u = { {0,2},{1,5} },
        np = 0,
        va = 0
    },{
        c = { {0x24,0,0,0,0,-131071},{0x16,0,0,256,256,-130815},{0xB7,2,1,257,769,-130302},{0x71,0,3,0,1536,-129535},{0x37,0,0,0,0,-131071},{0x37,0,1,0,512,-130559} },
        k = { "JSONDecode","Body" },
        p = {  },
        u = { {0,2},{1,5} },
        np = 0,
        va = 0
    } },
        u = { {0,0},{1,0},{1,4},{1,15},{1,13} },
        np = 1,
        va = 0
    },{
        c = { {0xB7,4,0,256,256,-130815},{0x4A,5,0,0,0,-131071},{0x9A,4,2,2,1026,-130045},{0x1F,5,0,1,1,-131070},{0xB7,6,0,256,256,-130815},{0x4A,7,1,0,512,-130559},{0x9A,6,2,2,1026,-130045},{0x1F,7,0,1,1,-131070},{0xB7,8,0,256,256,-130815},{0x4A,9,2,0,1024,-130047},{0x9A,8,2,2,1026,-130045},{0x1F,9,0,1,1,-131070},{0xB7,10,0,256,256,-130815},{0x5C,11,3,1,1537,-129534},{0x11,0,256,0,131072,1},{0x1F,11,0,2,2,-131069},{0x9A,10,2,2,1026,-130045},{0x34,4,4,10,2058,-129013},{0xAA,5,8,0,4096,-126975},{0x1F,6,0,3,3,-131068},{0x1F,7,0,4,4,-131067},{0x1F,8,0,5,5,-131066},{0x1F,9,0,6,6,-131065},{0x1F,10,0,7,7,-131064},{0x1F,11,0,8,8,-131063},{0x1F,12,0,9,9,-131062},{0x1F,13,0,10,10,-131061},{0xC8,5,8,1,4097,-126974},{0xB7,6,0,267,267,-130804},{0x29,6,0,0,0,-131071},{0x11,0,256,3,131075,4},{0xB7,6,0,267,267,-130804},{0x3E,6,6,268,3340,-127731},{0x29,6,0,1,1,-131070},{0x11,0,256,7,131079,8},{0xB7,6,0,269,269,-130802},{0x29,6,0,0,0,-131071},{0x11,0,256,3,131075,4},{0xB7,6,0,269,269,-130802},{0x3E,6,6,268,3340,-127731},{0x29,6,0,1,1,-131070},{0x11,0,256,0,131072,1},{0x14,6,0,0,0,-131071},{0xB7,7,0,267,267,-130804},{0x29,7,0,0,0,-131071},{0x11,0,256,3,131075,4},{0xB7,7,0,267,267,-130804},{0x3E,7,7,270,3854,-127217},{0x29,7,0,1,1,-131070},{0x11,0,256,7,131079,8},{0xB7,7,0,269,269,-130802},{0x29,7,0,0,0,-131071},{0x11,0,256,3,131075,4},{0xB7,7,0,269,269,-130802},{0x3E,7,7,270,3854,-127217},{0x29,7,0,1,1,-131070},{0x11,0,256,0,131072,1},{0x14,7,0,1,1,-131070},{0xB7,8,0,267,267,-130804},{0x29,8,0,0,0,-131071},{0x11,0,256,3,131075,4},{0xB7,8,0,267,267,-130804},{0x3E,8,8,271,4367,-126704},{0x29,8,0,1,1,-131070},{0x11,0,256,7,131079,8},{0xB7,8,0,269,269,-130802},{0x29,8,0,0,0,-131071},{0x11,0,256,3,131075,4},{0xB7,8,0,269,269,-130802},{0x3E,8,8,271,4367,-126704},{0x29,8,0,1,1,-131070},{0x11,0,256,0,131072,1},{0x14,8,0,2,2,-131069},{0x14,9,0,3,3,-131068},{0x14,10,0,4,4,-131067},{0xBD,11,4,0,2048,-129023},{0x1F,12,0,16,16,-131055},{0x4A,13,11,0,5632,-125439},{0x1F,14,0,16,16,-131055},{0x83,12,256,43,131115,44},{0xB7,16,0,273,273,-130798},{0x3E,16,16,274,8466,-122605},{0x4A,17,4,0,2048,-129023},{0x4A,18,15,0,7680,-123391},{0x9A,16,3,2,1538,-129533},{0x61,17,15,272,7952,-123119},{0x59,17,17,275,8979,-122092},{0x2D,17,17,272,8976,-122095},{0x59,18,17,275,8979,-122092},{0x2D,18,18,272,9488,-121583},{0x2D,19,17,276,8980,-122091},{0x59,19,19,275,10003,-121068},{0x2D,19,19,272,10000,-121071},{0x2D,20,17,277,8981,-122090},{0x59,20,20,275,10515,-120556},{0x2D,20,20,272,10512,-120559},{0x4A,21,10,0,5120,-125951},{0x4A,22,6,0,3072,-127999},{0x3E,23,5,17,2577,-128494},{0x4A,24,16,0,8192,-122879},{0x9A,22,3,2,1538,-129533},{0x1F,23,0,22,22,-131049},{0x9A,21,3,2,1538,-129533},{0x4A,22,10,0,5120,-125951},{0x3E,23,5,18,2578,-128493},{0x1F,24,0,23,23,-131048},{0x9A,22,3,2,1538,-129533},{0x4A,23,7,0,3584,-127487},{0x3E,24,5,19,2579,-128492},{0x1F,25,0,24,24,-131047},{0x9A,23,3,2,1538,-129533},{0x2D,24,21,22,10774,-120297},{0x2D,24,24,23,12311,-118760},{0x59,24,24,281,12569,-118502},{0x73,5,17,24,8728,-122343},{0x4A,24,9,0,4608,-126463},{0x3E,25,5,17,2577,-128494},{0x1F,26,0,26,26,-131045},{0x9A,24,3,2,1538,-129533},{0x4A,25,6,0,3072,-127999},{0x3E,26,5,20,2580,-128491},{0x4A,27,24,0,12288,-118783},{0x9A,25,3,2,1538,-129533},{0x73,5,20,25,10265,-120806},{0x6E,12,255,466,131026,-45},{0x1F,12,0,16,16,-131055},{0x1F,13,0,27,27,-131044},{0x1F,14,0,16,16,-131055},{0x83,12,256,33,131105,34},{0x1F,16,0,16,16,-131055},{0x1F,17,0,19,19,-131052},{0x1F,18,0,16,16,-131055},{0x83,16,256,28,131100,29},{0x59,20,19,275,10003,-121068},{0x2D,20,20,272,10512,-120559},{0x2D,21,19,276,10004,-121067},{0x59,21,21,275,11027,-120044},{0x2D,21,21,272,11024,-120047},{0x4A,22,6,0,3072,-127999},{0x3E,23,5,19,2579,-128492},{0x4A,24,9,0,4608,-126463},{0x3E,25,5,20,2580,-128491},{0x1F,26,0,28,28,-131043},{0x9A,24,3,0,1536,-129535},{0x9A,22,0,2,2,-131069},{0x73,5,19,22,9750,-121321},{0x4A,22,10,0,5120,-125951},{0x3E,23,5,19,2579,-128492},{0x1F,24,0,29,29,-131042},{0x9A,22,3,2,1538,-129533},{0x3E,23,5,21,2581,-128490},{0x2D,22,22,23,11287,-119784},{0x59,22,22,281,11545,-119526},{0x73,5,19,22,9750,-121321},{0x4A,22,6,0,3072,-127999},{0x3E,23,5,19,2579,-128492},{0x4A,24,7,0,3584,-127487},{0x3E,25,5,19,2579,-128492},{0x1F,26,0,27,27,-131044},{0x9A,24,3,0,1536,-129535},{0x9A,22,0,2,2,-131069},{0x73,5,19,22,9750,-121321},{0x6E,16,255,481,131041,-30},{0x6E,12,255,476,131036,-35},{0xAA,12,0,0,0,-131071},{0x1F,13,0,16,16,-131055},{0x1F,14,0,19,19,-131052},{0x1F,15,0,16,16,-131055},{0x83,13,256,8,131080,9},{0xB7,17,0,286,286,-130785},{0x3E,17,17,287,8991,-122080},{0x4A,18,12,0,6144,-124927},{0xB7,19,0,273,273,-130798},{0x3E,19,19,288,10016,-121055},{0x1F,20,0,33,33,-131038},{0x3E,21,5,16,2576,-128495},{0x9A,19,3,0,1536,-129535},{0x9A,17,0,1,1,-131070},{0x6E,13,255,501,131061,-10},{0xB7,13,0,286,286,-130785},{0x3E,13,13,290,6946,-124125},{0x4A,14,12,0,6144,-124927},{0x71,13,2,0,1024,-130047},{0x37,13,0,0,0,-131071},{0x37,0,1,0,512,-130559} },
        k = { "tostring",":","GENERIC",1779033703,3144134277,1013904242,2773480762,1359893119,2600822924,528734635,1541459225,"bit","bxor","bit32","rshift","lshift",1,"string","byte",8,6,2,1540483477,461845907,13,4294967296,7,16,11,3432918353,"table","insert","format","%08x","concat" },
        p = { {
        c = { {0x1F,2,0,0,0,-131071},{0x1F,3,0,1,1,-131070},{0x85,1,256,0,131072,1},{0x11,0,256,1,131073,2},{0x85,0,256,1,131073,2},{0x11,0,256,16,131088,17},{0x59,4,0,258,258,-130813},{0x59,5,1,258,770,-130301},{0x4F,1,4,5,2053,-129018},{0x11,0,256,0,131072,1},{0x2D,2,2,3,1027,-130044},{0xB7,4,0,259,259,-130812},{0x3E,4,4,260,2308,-128763},{0x42,5,0,258,258,-130813},{0x9A,4,2,2,1026,-130045},{0x4A,0,4,0,2048,-129023},{0xB7,4,0,259,259,-130812},{0x3E,4,4,260,2308,-128763},{0x42,5,1,258,770,-130301},{0x9A,4,2,2,1026,-130045},{0x4A,1,4,0,2048,-129023},{0x8B,3,3,258,1794,-129277},{0x11,0,255,490,131050,-21},{0x37,2,2,0,1024,-130047},{0x37,0,1,0,512,-130559} },
        k = { 0,1,2,"math","floor" },
        p = {  },
        u = { {0,0} },
        np = 2,
        va = 0
    },{
        c = { {0xB7,2,0,256,256,-130815},{0x3E,2,2,257,1281,-129790},{0x59,3,0,258,258,-130813},{0x7E,4,259,1,132609,1538},{0x42,3,3,4,1540,-129531},{0x71,2,2,0,1024,-130047},{0x37,2,0,0,0,-131071},{0x37,0,1,0,512,-130559} },
        k = { "math","floor",4294967296,2 },
        p = {  },
        u = { {0,0} },
        np = 2,
        va = 0
    },{
        c = { {0x59,2,0,256,256,-130815},{0x7E,3,257,1,131585,514},{0x8B,2,2,3,1027,-130044},{0x59,2,2,256,1280,-129791},{0x37,2,2,0,1024,-130047},{0x37,0,1,0,512,-130559} },
        k = { 4294967296,2 },
        p = {  },
        u = {  },
        np = 2,
        va = 0
    },{
        c = { {0x24,2,0,0,0,-131071},{0x4A,3,0,0,0,-131071},{0x4A,4,1,0,512,-130559},{0x9A,2,3,2,1538,-129533},{0x24,3,1,0,512,-130559},{0x4A,4,0,0,0,-131071},{0x61,5,256,1,131073,2},{0x9A,3,3,2,1538,-129533},{0x2D,2,2,3,1027,-130044},{0x59,2,2,257,1281,-129790},{0x37,2,2,0,1024,-130047},{0x37,0,1,0,512,-130559} },
        k = { 32,4294967296 },
        p = {  },
        u = { {1,8},{1,7} },
        np = 2,
        va = 0
    },{
        c = { {0x59,2,0,256,256,-130815},{0xB7,3,0,257,257,-130814},{0x3E,3,3,258,1794,-129277},{0x42,4,0,256,256,-130815},{0x9A,3,2,2,1026,-130045},{0x59,4,1,256,768,-130303},{0xB7,5,0,257,257,-130814},{0x3E,5,5,258,2818,-128253},{0x42,6,1,256,768,-130303},{0x9A,5,2,2,1026,-130045},{0x8B,6,2,4,1028,-130043},{0x8B,7,3,4,1540,-129531},{0x8B,8,2,5,1029,-130042},{0x2D,7,7,8,3592,-127479},{0x59,8,7,256,3840,-127231},{0x8B,8,8,256,4352,-126719},{0x2D,8,6,8,3080,-127991},{0x59,8,8,259,4355,-126716},{0x37,8,2,0,1024,-130047},{0x37,0,1,0,512,-130559} },
        k = { 65536,"math","floor",4294967296 },
        p = {  },
        u = { {0,0} },
        np = 2,
        va = 0
    } },
        u = { {0,0} },
        np = 4,
        va = 0
    },{
        c = { {0xB7,1,0,256,256,-130815},{0x3E,1,1,257,769,-130302},{0x9A,1,1,2,514,-130557},{0xB7,2,1,258,770,-130301},{0x29,2,0,0,0,-131071},{0x11,0,256,13,131085,14},{0xB7,2,1,259,771,-130300},{0x29,2,0,0,0,-131071},{0x11,0,256,10,131082,11},{0xB7,2,1,260,772,-130299},{0x4F,0,2,0,1024,-130047},{0x11,0,256,7,131079,8},{0xB7,2,1,261,773,-130298},{0x61,2,2,262,1286,-129785},{0x85,0,1,2,514,-130557},{0x11,0,256,3,131075,4},{0x6D,2,1,0,512,-130559},{0xB7,3,1,258,770,-130301},{0xB7,4,1,259,771,-130300},{0x37,2,4,0,2048,-129023},{0x1F,2,0,7,7,-131064},{0x1F,3,0,8,8,-131063},{0x1F,4,0,9,9,-131062},{0x1F,5,0,8,8,-131063},{0x83,3,256,10,131082,11},{0x4A,7,2,0,1024,-130047},{0xB7,8,0,266,266,-130805},{0x3E,8,8,267,4363,-126708},{0x1F,9,0,12,12,-131059},{0xB7,10,0,269,269,-130802},{0x3E,10,10,270,5390,-125681},{0x1F,11,0,15,15,-131056},{0x1F,12,0,16,16,-131055},{0x9A,10,3,0,1536,-129535},{0x9A,8,0,2,2,-131069},{0x34,2,7,8,3592,-127479},{0x6E,3,255,499,131059,-12},{0x24,3,2,0,1024,-130047},{0x16,3,3,273,1809,-129262},{0xAA,5,0,5,5,-131066},{0x73,5,274,2,140290,9219},{0x73,5,275,0,140800,9729},{0x24,6,3,0,1536,-129535},{0x73,5,276,6,141318,10247},{0xB7,6,0,278,278,-130793},{0x3E,6,6,279,3351,-127720},{0x29,6,0,1,1,-131070},{0x11,0,256,0,131072,1},{0x1F,6,0,15,15,-131056},{0x73,5,277,6,141830,10759},{0x73,5,280,1,143361,12290},{0x9A,3,3,2,1538,-129533},{0x24,4,4,0,2048,-129023},{0xAA,5,0,4,4,-131067},{0x24,6,5,0,2560,-128511},{0x1F,7,0,26,26,-131045},{0x34,6,6,7,3079,-127992},{0x73,5,281,6,143878,12807},{0x73,5,283,284,145180,14109},{0xAA,6,0,1,1,-131070},{0x73,6,286,287,146719,15648},{0x73,5,285,6,145926,14855},{0x73,5,288,3,147459,16388},{0x9A,4,2,2,1026,-130045},{0x29,4,0,0,0,-131071},{0x11,0,256,45,131117,46},{0x3E,5,4,289,2337,-128734},{0x4F,0,5,290,2850,-128221},{0x11,0,256,42,131114,43},{0x3E,5,4,288,2336,-128735},{0x29,5,0,0,0,-131071},{0x11,0,256,39,131111,40},{0xB7,5,0,291,291,-130780},{0x14,6,0,0,0,-131071},{0x9A,5,2,3,1027,-130044},{0x29,5,0,0,0,-131071},{0x11,0,256,34,131106,35},{0x29,6,0,0,0,-131071},{0x11,0,256,32,131104,33},{0x3E,7,6,292,3364,-127707},{0x29,7,0,0,0,-131071},{0x11,0,256,29,131101,30},{0x3E,7,6,293,3365,-127706},{0x29,7,0,0,0,-131071},{0x11,0,256,26,131098,27},{0x3E,7,6,294,3366,-127705},{0x29,7,0,0,0,-131071},{0x11,0,256,23,131095,24},{0x24,7,6,0,3072,-127999},{0x4A,8,0,0,0,-131071},{0x4A,9,2,0,1024,-130047},{0x3E,10,6,294,3366,-127705},{0x24,11,3,0,1536,-129535},{0x9A,7,5,2,2562,-128509},{0x3E,8,6,293,3365,-127706},{0xC5,1,258,8,132104,1033},{0xC5,1,259,7,132615,1544},{0xC5,1,260,0,133120,2049},{0xB7,8,0,269,269,-130802},{0x3E,8,8,295,4391,-126680},{0x3E,9,6,296,3368,-127703},{0x29,9,0,1,1,-131070},{0x11,0,256,1,131073,2},{0x8B,9,1,297,809,-130262},{0x2D,9,9,298,4906,-126165},{0x42,9,9,297,4905,-126166},{0x9A,8,2,2,1026,-130045},{0xC5,1,261,8,133640,2569},{0x6D,8,1,0,512,-130559},{0xB7,9,1,258,770,-130301},{0xB7,10,1,259,771,-130300},{0x37,8,4,0,2048,-129023},{0x6D,5,0,0,0,-131071},{0x91,6,1,0,512,-130559},{0x37,5,4,0,2048,-129023},{0x37,0,1,0,512,-130559} },
        k = { "os","time","Token","Key","TargetKey","ExpiresAt",5,"",1,16,"string","format","%02x","math","random",0,255,"JSONEncode","clientNonce","key","hwid","placeId","game","PlaceId","timestamp","Url","/api/client/handshake","Method","POST","Headers","Content-Type","application/json","Body","StatusCode",200,"pcall","success","sessionToken","serverNonce","floor","expiresAt",1000,60000 },
        p = { {
        c = { {0x24,0,0,0,0,-131071},{0x16,0,0,256,256,-130815},{0xB7,2,1,257,769,-130302},{0x71,0,3,0,1536,-129535},{0x37,0,0,0,0,-131071},{0x37,0,1,0,512,-130559} },
        k = { "JSONDecode","Body" },
        p = {  },
        u = { {0,2},{1,4} },
        np = 0,
        va = 0
    } },
        u = { {0,0},{1,18},{1,4},{1,15},{1,13},{1,0},{1,17} },
        np = 1,
        va = 0
    },{
        c = { {0x1F,2,0,0,0,-131071},{0xAA,3,0,0,0,-131071},{0x1F,4,0,1,1,-131070},{0x1F,5,0,2,2,-131069},{0x1F,6,0,1,1,-131070},{0x83,4,256,6,131078,7},{0xB7,8,0,259,259,-130812},{0x3E,8,8,260,4356,-126715},{0x4A,9,2,0,1024,-130047},{0x4A,10,7,0,3584,-127487},{0x9A,8,3,2,1538,-129533},{0x61,9,7,257,3841,-127230},{0x73,3,8,9,4105,-126966},{0x6E,4,255,503,131063,-8},{0xAA,4,0,0,0,-131071},{0xBD,5,0,0,0,-131071},{0x85,0,261,5,133637,2566},{0x11,0,256,9,131081,10},{0xB7,6,0,259,259,-130812},{0x3E,6,6,262,3334,-127737},{0x4A,7,0,0,0,-131071},{0x4A,8,5,0,2560,-128511},{0x4A,9,5,0,2560,-128511},{0x9A,6,4,2,2050,-129021},{0x4F,0,6,263,3335,-127736},{0x11,0,256,1,131073,2},{0x61,5,5,257,2817,-128254},{0x11,0,255,499,131059,-12},{0x1F,6,0,5,5,-131066},{0x1F,7,0,5,5,-131066},{0x1F,8,0,1,1,-131070},{0x4A,9,5,0,2560,-128511},{0x1F,10,0,1,1,-131070},{0x83,8,256,26,131098,27},{0xB7,12,0,259,259,-130812},{0x3E,12,12,260,6404,-124667},{0x4A,13,0,0,0,-131071},{0x4A,14,11,0,5632,-125439},{0x9A,12,3,2,1538,-129533},{0x3E,12,3,12,1548,-129523},{0x29,12,0,0,0,-131071},{0x11,0,256,18,131090,19},{0x8B,13,6,258,3330,-127741},{0x2D,6,13,12,6668,-124403},{0x2D,7,7,264,3848,-127223},{0xBA,0,265,7,135687,4616},{0x11,0,256,13,131085,14},{0x61,7,7,265,3849,-127222},{0xB7,13,0,266,266,-130805},{0x3E,13,13,267,6923,-124148},{0x7E,14,268,7,137223,6152},{0x42,14,6,14,3086,-127985},{0x9A,13,2,2,1026,-130045},{0x59,13,13,269,6925,-124146},{0x7E,14,268,7,137223,6152},{0x59,6,6,14,3086,-127985},{0xB7,14,0,270,270,-130801},{0x3E,14,14,271,7439,-123632},{0x4A,15,4,0,2048,-129023},{0x4A,16,13,0,6656,-124415},{0x9A,14,3,1,1537,-129534},{0x6E,8,255,483,131043,-28},{0xAA,8,0,0,0,-131071},{0x1F,9,0,1,1,-131070},{0xBD,10,1,0,512,-130559},{0x1F,11,0,12,12,-131059},{0x83,9,256,15,131087,16},{0xB7,13,0,270,270,-130801},{0x3E,13,13,271,6927,-124144},{0x4A,14,8,0,4096,-126975},{0xB7,15,0,272,272,-130799},{0xB7,16,0,259,259,-130812},{0x3E,16,16,262,8454,-122617},{0x4A,17,1,0,512,-130559},{0x4A,18,12,0,6144,-124927},{0x2D,19,12,257,6401,-124670},{0x9A,16,4,2,2050,-129021},{0x1F,17,0,17,17,-131054},{0x9A,15,3,2,1538,-129533},{0x29,15,0,1,1,-131070},{0x11,0,256,0,131072,1},{0x1F,15,0,5,5,-131066},{0x9A,13,3,1,1537,-129534},{0x6E,9,255,494,131054,-17},{0xB7,9,0,274,274,-130797},{0x29,9,0,0,0,-131071},{0x11,0,256,3,131075,4},{0xB7,9,0,274,274,-130797},{0x3E,9,9,275,4883,-126188},{0x29,9,0,1,1,-131070},{0x11,0,256,7,131079,8},{0xB7,9,0,276,276,-130795},{0x29,9,0,0,0,-131071},{0x11,0,256,3,131075,4},{0xB7,9,0,276,276,-130795},{0x3E,9,9,275,4883,-126188},{0x29,9,0,1,1,-131070},{0x11,0,256,0,131072,1},{0x14,9,0,0,0,-131071},{0x1F,10,0,21,21,-131050},{0xBD,11,8,0,4096,-126975},{0xAA,12,0,0,0,-131071},{0xAA,13,0,0,0,-131071},{0x1F,14,0,5,5,-131066},{0x1F,15,0,1,1,-131070},{0xBD,16,4,0,2048,-129023},{0x1F,17,0,1,1,-131070},{0x83,15,256,36,131108,37},{0x3E,19,4,18,2066,-129005},{0x61,20,18,257,9473,-121598},{0x59,20,20,11,10251,-120820},{0x2D,20,20,257,10497,-120574},{0x3E,20,8,20,4116,-126955},{0x4A,21,9,0,4608,-126463},{0x4A,22,9,0,4608,-126463},{0x4A,23,19,0,9728,-121343},{0x4A,24,20,0,10240,-120831},{0x9A,22,3,2,1538,-129533},{0x4A,23,10,0,5120,-125951},{0x9A,21,3,2,1538,-129533},{0xB7,22,0,270,270,-130801},{0x3E,22,22,271,11535,-119536},{0x4A,23,13,0,6656,-124415},{0xB7,24,0,259,259,-130812},{0x3E,24,24,278,12566,-118505},{0x4A,25,21,0,10752,-120319},{0x9A,24,2,0,1024,-130047},{0x9A,22,0,1,1,-131070},{0x2D,14,14,257,7425,-123646},{0xBA,0,279,14,142862,11791},{0x11,0,256,10,131082,11},{0xB7,22,0,270,270,-130801},{0x3E,22,22,271,11535,-119536},{0x4A,23,12,0,6144,-124927},{0xB7,24,0,270,270,-130801},{0x3E,24,24,280,12568,-118503},{0x4A,25,13,0,6656,-124415},{0x9A,24,2,0,1024,-130047},{0x9A,22,0,1,1,-131070},{0xAA,22,0,0,0,-131071},{0x4A,13,22,0,11264,-119807},{0x1F,14,0,5,5,-131066},{0x8B,22,10,281,5401,-125670},{0x2D,22,22,19,11283,-119788},{0x59,10,22,269,11533,-119538},{0x6E,15,255,473,131033,-38},{0x85,0,261,14,133646,2575},{0x11,0,256,7,131079,8},{0xB7,15,0,270,270,-130801},{0x3E,15,15,271,7951,-123120},{0x4A,16,12,0,6144,-124927},{0xB7,17,0,270,270,-130801},{0x3E,17,17,280,8984,-122087},{0x4A,18,13,0,6656,-124415},{0x9A,17,2,0,1024,-130047},{0x9A,15,0,1,1,-131070},{0x1F,15,0,1,1,-131070},{0xBD,16,4,0,2048,-129023},{0x1F,17,0,1,1,-131070},{0x83,15,256,0,131072,1},{0x73,4,18,261,9477,-121594},{0x6E,15,255,509,131069,-2},{0x1F,15,0,1,1,-131070},{0xBD,16,8,0,4096,-126975},{0x1F,17,0,1,1,-131070},{0x83,15,256,0,131072,1},{0x73,8,18,261,9477,-121594},{0x6E,15,255,509,131069,-2},{0xB7,15,0,270,270,-130801},{0x3E,15,15,280,7960,-123111},{0x4A,16,12,0,6144,-124927},{0x71,15,2,0,1024,-130047},{0x37,15,0,0,0,-131071},{0x37,0,1,0,512,-130559} },
        k = { "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/",1,64,"string","byte",0,"sub","=",6,8,"math","floor",2,256,"table","insert","tonumber",16,"bit","bxor","bit32",90,"char",4096,"concat",33 },
        p = { {
        c = { {0x1F,2,0,0,0,-131071},{0x1F,3,0,1,1,-131070},{0x85,1,256,0,131072,1},{0x11,0,256,1,131073,2},{0x85,0,256,1,131073,2},{0x11,0,256,16,131088,17},{0x59,4,0,258,258,-130813},{0x59,5,1,258,770,-130301},{0x4F,1,4,5,2053,-129018},{0x11,0,256,0,131072,1},{0x2D,2,2,3,1027,-130044},{0xB7,6,0,259,259,-130812},{0x3E,6,6,260,3332,-127739},{0x42,7,0,258,258,-130813},{0x9A,6,2,2,1026,-130045},{0x4A,0,6,0,3072,-127999},{0xB7,6,0,259,259,-130812},{0x3E,6,6,260,3332,-127739},{0x42,7,1,258,770,-130301},{0x9A,6,2,2,1026,-130045},{0x4A,1,6,0,3072,-127999},{0x8B,3,3,258,1794,-129277},{0x11,0,255,490,131050,-21},{0x37,2,2,0,1024,-130047},{0x37,0,1,0,512,-130559} },
        k = { 0,1,2,"math","floor" },
        p = {  },
        u = { {0,0} },
        np = 2,
        va = 0
    } },
        u = { {0,0} },
        np = 2,
        va = 0
    },{
        c = { {0x24,4,0,0,0,-131071},{0x9A,4,1,3,515,-130556},{0x29,4,0,1,1,-131070},{0x11,0,256,13,131085,14},{0x29,3,0,0,0,-131071},{0x11,0,256,8,131080,9},{0x16,6,3,256,1792,-129279},{0xAA,8,0,3,3,-131068},{0x73,8,257,258,131842,771},{0xB7,9,1,260,772,-130299},{0x4A,10,5,0,2560,-128511},{0x9A,9,2,2,1026,-130045},{0x73,8,259,9,132617,1546},{0x73,8,261,262,133894,2823},{0x9A,6,3,1,1537,-129534},{0x6D,6,0,0,0,-131071},{0x4A,7,5,0,2560,-128511},{0x37,6,3,0,1536,-129535},{0xB7,6,1,260,772,-130299},{0x5C,7,0,1,1,-131070},{0x11,0,256,0,131072,1},{0x1F,7,0,7,7,-131064},{0x9A,6,2,2,1026,-130045},{0x16,6,6,264,3336,-127735},{0x1F,8,0,9,9,-131062},{0x1F,9,0,7,7,-131064},{0x9A,6,4,2,2050,-129021},{0x16,6,6,266,3338,-127733},{0x9A,6,2,2,1026,-130045},{0xBD,7,6,0,3072,-127999},{0x85,0,7,267,3851,-127220},{0x11,0,256,2,131074,3},{0xB7,7,1,268,780,-130291},{0x14,8,0,0,0,-131071},{0x9A,7,2,1,1025,-130046},{0x29,3,0,0,0,-131071},{0x11,0,256,9,131081,10},{0x16,7,3,256,1792,-129279},{0xAA,9,0,3,3,-131068},{0x73,9,257,269,131853,782},{0x1F,10,0,14,14,-131057},{0x4A,11,2,0,1024,-130047},{0x1F,12,0,15,15,-131056},{0x34,10,10,12,5132,-125939},{0x73,9,259,10,132618,1547},{0x73,9,261,272,133904,2833},{0x9A,7,3,1,1537,-129534},{0x24,7,2,0,1024,-130047},{0x4A,8,6,0,3072,-127999},{0x9A,7,2,4,1028,-130043},{0xAA,10,0,1,1,-131070},{0x73,10,273,274,140050,8979},{0x24,11,3,0,1536,-129535},{0x16,11,11,275,5907,-125164},{0xAA,13,0,4,4,-131067},{0x73,13,276,6,141318,10247},{0x24,14,4,0,2048,-129023},{0x73,13,277,14,141838,10767},{0x73,13,278,1,142337,11266},{0x29,7,0,0,0,-131071},{0x11,0,256,1,131073,2},{0x5C,14,8,1,4097,-126974},{0x11,0,256,0,131072,1},{0x91,14,0,0,0,-131071},{0x73,13,279,14,142862,11791},{0x9A,11,3,2,1538,-129533},{0x24,12,5,0,2560,-128511},{0xAA,13,0,4,4,-131067},{0x24,14,6,0,3072,-127999},{0x1F,15,0,25,25,-131046},{0x34,14,14,15,7183,-123888},{0x73,13,280,14,143374,12303},{0x73,13,282,283,144667,13596},{0x73,13,284,10,145418,14347},{0x73,13,285,11,145931,14860},{0x9A,12,2,2,1026,-130045},{0x29,12,0,0,0,-131071},{0x11,0,256,9,131081,10},{0x3E,13,12,286,6430,-124641},{0x4F,0,13,287,6943,-124128},{0x11,0,256,6,131078,7},{0x3E,13,12,285,6429,-124642},{0x29,13,0,0,0,-131071},{0x11,0,256,3,131075,4},{0x3E,13,12,285,6429,-124642},{0xBD,13,13,0,6656,-124415},{0x85,0,13,288,6944,-124127},{0x11,0,256,30,131102,31},{0x1F,13,0,33,33,-131038},{0xB7,14,1,260,772,-130299},{0x29,12,0,0,0,-131071},{0x11,0,256,2,131074,3},{0x3E,15,12,286,6430,-124641},{0x29,15,0,1,1,-131070},{0x11,0,256,0,131072,1},{0x1F,15,0,34,34,-131037},{0x9A,14,2,2,1026,-130045},{0x1F,15,0,35,35,-131036},{0x34,13,13,15,6671,-124400},{0x29,12,0,0,0,-131071},{0x11,0,256,5,131077,6},{0x3E,14,12,285,6429,-124642},{0x29,14,0,0,0,-131071},{0x11,0,256,2,131074,3},{0xB7,14,1,268,780,-130291},{0x14,15,0,1,1,-131070},{0x9A,14,2,1,1025,-130046},{0x29,3,0,0,0,-131071},{0x11,0,256,5,131077,6},{0x16,14,3,256,1792,-129279},{0xAA,16,0,3,3,-131068},{0x73,16,257,292,131876,805},{0x73,16,259,13,132621,1550},{0x73,16,261,262,133894,2823},{0x9A,14,3,1,1537,-129534},{0x6D,14,0,0,0,-131071},{0x4A,15,13,0,6656,-124415},{0x37,14,3,0,1536,-129535},{0x11,14,255,511,131071,0},{0x91,13,0,0,0,-131071},{0x6D,14,0,0,0,-131071},{0xB7,15,1,268,780,-130291},{0x14,16,0,2,2,-131069},{0x9A,15,2,3,1027,-130044},{0x29,15,0,0,0,-131071},{0x11,0,256,19,131091,20},{0x29,16,0,0,0,-131071},{0x11,0,256,17,131089,18},{0x3E,17,16,293,8485,-122586},{0x4F,0,17,294,8998,-122073},{0x11,0,256,14,131086,15},{0x3E,17,16,295,8487,-122584},{0x29,17,0,0,0,-131071},{0x11,0,256,11,131083,12},{0x29,9,0,1,1,-131070},{0x11,0,256,2,131074,3},{0x6D,17,0,0,0,-131071},{0x1F,18,0,40,40,-131031},{0x37,17,3,0,1536,-129535},{0x24,17,7,0,3584,-127487},{0x3E,18,16,295,8487,-122584},{0x4A,19,9,0,4608,-126463},{0x9A,17,3,2,1538,-129533},{0x4A,13,17,0,8704,-122367},{0x6D,14,1,0,512,-130559},{0x11,0,256,0,131072,1},{0x3E,13,12,285,6429,-124642},{0x29,13,0,0,0,-131071},{0x11,0,256,2,131074,3},{0xBD,17,13,0,6656,-124415},{0x85,0,17,297,9001,-122070},{0x11,0,256,2,131074,3},{0x6D,17,0,0,0,-131071},{0x1F,18,0,42,42,-131029},{0x37,17,3,0,1536,-129535},{0x91,17,1,0,512,-130559},{0xB7,19,1,299,811,-130260},{0x29,19,0,0,0,-131071},{0x11,0,256,4,131076,5},{0xB7,19,1,299,811,-130260},{0x9A,19,1,2,514,-130557},{0x3E,19,19,300,10028,-121043},{0x29,19,0,1,1,-131070},{0x11,0,256,18,131090,19},{0xB7,19,1,301,813,-130258},{0x29,19,0,0,0,-131071},{0x11,0,256,4,131076,5},{0xB7,19,1,301,813,-130258},{0x9A,19,1,2,514,-130557},{0x3E,19,19,300,10028,-121043},{0x29,19,0,1,1,-131070},{0x11,0,256,10,131082,11},{0xB7,19,1,302,814,-130257},{0x3E,19,19,300,10028,-121043},{0x29,19,0,1,1,-131070},{0x11,0,256,6,131078,7},{0xB7,19,1,300,812,-130259},{0x29,19,0,1,1,-131070},{0x11,0,256,3,131075,4},{0xB7,19,1,303,815,-130256},{0x29,19,0,0,0,-131071},{0x11,0,256,0,131072,1},{0x14,19,0,3,3,-131068},{0x29,19,0,0,0,-131071},{0x11,0,256,4,131076,5},{0xB7,20,1,304,816,-130255},{0x4A,21,19,0,9728,-121343},{0x9A,20,2,2,1026,-130045},{0x4F,1,20,305,10545,-120526},{0x11,0,256,11,131083,12},{0x1F,20,0,50,50,-131021},{0x29,3,0,0,0,-131071},{0x11,0,256,5,131077,6},{0x16,21,3,256,1792,-129279},{0xAA,23,0,3,3,-131068},{0x73,23,257,307,131891,820},{0x73,23,259,20,132628,1557},{0x73,23,261,262,133894,2823},{0x9A,21,3,1,1537,-129534},{0x6D,21,0,0,0,-131071},{0x4A,22,20,0,10240,-120831},{0x37,21,3,0,1536,-129535},{0xB7,20,1,308,820,-130251},{0x29,20,0,0,0,-131071},{0x11,0,256,7,131079,8},{0xB7,20,1,308,820,-130251},{0x4A,21,19,0,9728,-121343},{0x9A,20,2,2,1026,-130045},{0x29,20,0,0,0,-131071},{0x11,0,256,2,131074,3},{0x6D,20,0,0,0,-131071},{0x1F,21,0,53,53,-131018},{0x37,20,3,0,1536,-129535},{0xB7,20,1,268,780,-130291},{0x4A,21,19,0,9728,-121343},{0x4A,22,13,0,6656,-124415},{0x9A,20,3,4,1540,-129531},{0x29,20,0,0,0,-131071},{0x11,0,256,6,131078,7},{0xB7,23,1,304,816,-130255},{0x4A,24,21,0,10752,-120319},{0x9A,23,2,2,1026,-130045},{0x4F,0,23,305,12081,-118990},{0x11,0,256,1,131073,2},{0x4A,17,21,0,10752,-120319},{0x11,0,256,4,131076,5},{0x5C,18,22,1,11265,-119806},{0x11,0,256,2,131074,3},{0x5C,18,21,1,10753,-120318},{0x11,0,256,0,131072,1},{0x1F,18,0,54,54,-131017},{0x91,13,0,0,0,-131071},{0xB7,23,1,311,823,-130248},{0x29,23,0,0,0,-131071},{0x11,0,256,3,131075,4},{0xB7,23,1,268,780,-130291},{0xB7,24,1,311,823,-130248},{0x1F,25,0,56,56,-131015},{0x9A,23,3,1,1537,-129534},{0x29,17,0,1,1,-131070},{0x11,0,256,15,131087,16},{0x1F,23,0,57,57,-131014},{0xB7,24,1,260,772,-130299},{0x4A,25,18,0,9216,-121855},{0x9A,24,2,2,1026,-130045},{0x34,23,23,24,11800,-119271},{0x29,3,0,0,0,-131071},{0x11,0,256,5,131077,6},{0x16,24,3,256,1792,-129279},{0xAA,26,0,3,3,-131068},{0x73,26,257,307,131891,820},{0x73,26,259,23,132631,1560},{0x73,26,261,262,133894,2823},{0x9A,24,3,1,1537,-129534},{0x6D,24,0,0,0,-131071},{0x4A,25,23,0,11776,-119295},{0x37,24,3,0,1536,-129535},{0xB7,23,1,314,826,-130245},{0x3E,23,23,315,12091,-118980},{0x4A,24,17,0,8704,-122367},{0x9A,23,2,1,1025,-130046},{0x29,3,0,0,0,-131071},{0x11,0,256,8,131080,9},{0x16,23,3,256,1792,-129279},{0xAA,25,0,3,3,-131068},{0x73,25,257,316,131900,829},{0x4A,26,2,0,1024,-130047},{0x1F,27,0,61,61,-131010},{0x34,26,26,27,13339,-117732},{0x73,25,259,26,132634,1563},{0x73,25,261,267,133899,2828},{0x9A,23,3,1,1537,-129534},{0x6D,23,1,0,512,-130559},{0x1F,24,0,60,60,-131011},{0x37,23,3,0,1536,-129535},{0x37,0,1,0,512,-130559} },
        k = { "Notify","Title","Security Trap","Content","tostring","Duration",5,"","gsub","%s+","upper",4,"pcall","Loader Script","Performing secure handshake for ","...",2.5,"Content-Type","application/json","JSONEncode","key","hwid","game","sessionToken","Url","/api/client/script","Method","POST","Headers","Body","StatusCode",200,20,"Failed to download payload from server (",0,")","Error","encrypted",true,"payload","Handshake session key missing for encrypted payload",10,"Payload corrupted or empty","getgenv","loadstring","getfenv","_G","load","type","function","Executor does not support loadstring","Execution Error","islclosure","SECURITY_TRAP: Hostile loader hook detected on compiler","Failed to compile bytecode","collectgarbage","collect","Execution Error: ","task","spawn","Success"," executed securely." },
        p = { {
        c = { {0xB7,0,0,256,256,-130815},{0x29,0,0,0,0,-131071},{0x11,0,256,22,131094,23},{0xB7,0,0,256,256,-130815},{0x1F,1,0,1,1,-131070},{0x9A,0,2,2,1026,-130045},{0x29,0,0,0,0,-131071},{0x11,0,256,17,131089,18},{0xB7,0,0,258,258,-130813},{0x29,0,0,0,0,-131071},{0x11,0,256,14,131086,15},{0xB7,0,0,258,258,-130813},{0x1F,1,0,1,1,-131070},{0x9A,0,2,2,1026,-130045},{0x29,0,0,0,0,-131071},{0x11,0,256,9,131081,10},{0xBD,1,0,0,0,-131071},{0xBA,0,259,1,132609,1538},{0x11,0,256,6,131078,7},{0x16,1,0,260,260,-130811},{0x1F,3,0,5,5,-131066},{0x1F,4,0,6,6,-131065},{0x9A,1,4,2,2050,-129021},{0x16,1,1,263,775,-130296},{0x9A,1,2,2,1026,-130045},{0x58,1,1,0,512,-130559},{0x37,0,1,0,512,-130559} },
        k = { "isfile","mintrazerx_key.txt","readfile",4,"gsub","%s+","","upper" },
        p = {  },
        u = { {0,1},{1,6} },
        np = 0,
        va = 0
    },{
        c = { {0x24,0,0,0,0,-131071},{0x16,0,0,256,256,-130815},{0xB7,2,1,257,769,-130302},{0x9A,0,3,2,1538,-129533},{0x29,0,0,0,0,-131071},{0x11,0,256,4,131076,5},{0x3E,1,0,258,258,-130813},{0x29,1,0,0,0,-131071},{0x11,0,256,1,131073,2},{0x3E,1,0,258,258,-130813},{0x58,1,2,0,1024,-130047},{0x37,0,1,0,512,-130559} },
        k = { "JSONDecode","Body","message" },
        p = {  },
        u = { {0,3},{1,12},{1,13} },
        np = 0,
        va = 0
    },{
        c = { {0x24,0,0,0,0,-131071},{0x16,0,0,256,256,-130815},{0xB7,2,1,257,769,-130302},{0x71,0,3,0,1536,-129535},{0x37,0,0,0,0,-131071},{0x37,0,1,0,512,-130559} },
        k = { "JSONDecode","Body" },
        p = {  },
        u = { {0,3},{1,12} },
        np = 0,
        va = 0
    },{
        c = { {0xB7,1,0,256,256,-130815},{0x4A,2,0,0,0,-131071},{0x71,1,2,0,1024,-130047},{0x37,1,0,0,0,-131071},{0x37,0,1,0,512,-130559} },
        k = { "load" },
        p = {  },
        u = { {0,1} },
        np = 1,
        va = 0
    } },
        u = { {1,10},{0,0},{1,19},{1,4},{1,15},{1,13},{1,0},{1,20} },
        np = 4,
        va = 0
    },{
        c = { {0xB7,0,0,256,256,-130815},{0x3E,0,0,257,257,-130814},{0x4F,1,0,258,258,-130813},{0x11,0,256,12,131084,13},{0xB7,0,0,259,259,-130812},{0x16,0,0,260,260,-130811},{0x1F,2,0,5,5,-131066},{0x9A,0,3,2,1538,-129533},{0x29,0,0,0,0,-131071},{0x11,0,256,7,131079,8},{0xB7,0,0,259,259,-130812},{0x16,0,0,260,260,-130811},{0x1F,2,0,6,6,-131065},{0x9A,0,3,2,1538,-129533},{0x4F,0,0,263,263,-130808},{0x11,0,256,0,131072,1},{0x6D,0,0,1,1,-131070},{0x6D,0,1,0,512,-130559},{0x37,0,2,0,1024,-130047},{0x37,0,1,0,512,-130559} },
        k = { "game","PlaceId",72299838142412,"workspace","FindFirstChild","debris","itemModels",nil },
        p = {  },
        u = { {0,0} },
        np = 0,
        va = 0
    },{
        c = { {0xB7,0,0,256,256,-130815},{0x3E,0,0,257,257,-130814},{0x4F,0,0,258,258,-130813},{0x11,0,256,1,131073,2},{0x6D,0,1,0,512,-130559},{0x37,0,2,0,1024,-130047},{0xAA,0,6,0,3072,-127999},{0x1F,1,0,3,3,-131068},{0x1F,2,0,4,4,-131067},{0x1F,3,0,5,5,-131066},{0x1F,4,0,6,6,-131065},{0x1F,5,0,7,7,-131064},{0x1F,6,0,8,8,-131063},{0xC8,0,6,1,3073,-127998},{0xB7,1,0,265,265,-130806},{0x4A,2,0,0,0,-131071},{0x9A,1,2,4,1028,-130043},{0x11,0,256,7,131079,8},{0xB7,6,0,266,266,-130805},{0x16,6,6,267,3339,-127732},{0x4A,8,5,0,2560,-128511},{0x9A,6,3,2,1538,-129533},{0x29,6,0,0,0,-131071},{0x11,0,256,1,131073,2},{0x6D,6,1,0,512,-130559},{0x37,6,2,0,1024,-130047},{0xA2,1,0,2,2,-131069},{0xB9,3,255,501,131061,-10},{0x6D,1,0,0,0,-131071},{0x37,1,2,0,1024,-130047},{0x37,0,1,0,512,-130559} },
        k = { "game","PlaceId",5976159288,"Canada","Monaco","Spa","Silverstone","Monza","Bahrain","ipairs","workspace","FindFirstChild" },
        p = {  },
        u = { {0,0} },
        np = 0,
        va = 0
    },{
        c = { {0xB7,0,0,256,256,-130815},{0x3E,0,0,257,257,-130814},{0x4F,1,0,258,258,-130813},{0x11,0,256,6,131078,7},{0xB7,0,0,259,259,-130812},{0x16,0,0,260,260,-130811},{0x1F,2,0,5,5,-131066},{0x9A,0,3,2,1538,-129533},{0x4F,0,0,262,262,-130809},{0x11,0,256,0,131072,1},{0x6D,0,0,1,1,-131070},{0x6D,0,1,0,512,-130559},{0x37,0,2,0,1024,-130047},{0x37,0,1,0,512,-130559} },
        k = { "game","PlaceId",5041144419,"workspace","FindFirstChild","SCP",nil },
        p = {  },
        u = { {0,0} },
        np = 0,
        va = 0
    },{
        c = { {0xB7,0,0,256,256,-130815},{0x3E,0,0,257,257,-130814},{0x4F,1,0,258,258,-130813},{0x11,0,256,9,131081,10},{0xB7,0,0,256,256,-130815},{0x16,0,0,259,259,-130812},{0x1F,2,0,4,4,-131067},{0x9A,0,3,2,1538,-129533},{0x16,0,0,261,261,-130810},{0x1F,2,0,6,6,-131065},{0x9A,0,3,2,1538,-129533},{0x4F,0,0,263,263,-130808},{0x11,0,256,0,131072,1},{0x6D,0,0,1,1,-131070},{0x6D,0,1,0,512,-130559},{0x37,0,2,0,1024,-130047},{0x37,0,1,0,512,-130559} },
        k = { "game","PlaceId",6678877691,"GetService","ReplicatedStorage","FindFirstChild","AirDensityMapIdentifier",nil },
        p = {  },
        u = { {0,0} },
        np = 0,
        va = 0
    },{
        c = { {0xB7,0,0,256,256,-130815},{0x3E,0,0,257,257,-130814},{0x4F,1,0,258,258,-130813},{0x11,0,256,16,131088,17},{0xB7,0,0,256,256,-130815},{0x3E,0,0,257,257,-130814},{0x4F,1,0,259,259,-130812},{0x11,0,256,12,131084,13},{0xB7,0,0,260,260,-130811},{0x16,0,0,261,261,-130810},{0x1F,2,0,6,6,-131065},{0x9A,0,3,2,1538,-129533},{0x4F,1,0,263,263,-130808},{0x11,0,256,5,131077,6},{0xB7,0,0,260,260,-130811},{0x16,0,0,261,261,-130810},{0x1F,2,0,8,8,-131063},{0x9A,0,3,2,1538,-129533},{0x4F,0,0,263,263,-130808},{0x11,0,256,0,131072,1},{0x6D,0,0,1,1,-131070},{0x6D,0,1,0,512,-130559},{0x37,0,2,0,1024,-130047},{0x37,0,1,0,512,-130559} },
        k = { "game","PlaceId",13772394625,14732610803,"workspace","FindFirstChild","Balls",nil,"Alive" },
        p = {  },
        u = { {0,0} },
        np = 0,
        va = 0
    },{
        c = { {0xB7,0,0,256,256,-130815},{0x24,1,1,0,512,-130559},{0x9A,0,2,4,1028,-130043},{0x11,0,256,4,131076,5},{0x3E,5,4,257,2305,-128766},{0x9A,5,1,2,514,-130557},{0x29,5,0,0,0,-131071},{0x11,0,256,0,131072,1},{0x37,4,2,0,1024,-130047},{0xA2,0,0,2,2,-131069},{0xB9,2,255,504,131064,-7},{0x91,0,0,0,0,-131071},{0x37,0,2,0,1024,-130047},{0x37,0,1,0,512,-130559} },
        k = { "ipairs","IsActive" },
        p = {  },
        u = { {0,0},{1,22} },
        np = 0,
        va = 0
    },{
        c = { {0xAA,0,2,0,1024,-130047},{0x1F,1,0,0,0,-131071},{0x1F,2,0,1,1,-131070},{0xC8,0,2,1,1025,-130046},{0xB7,1,0,258,258,-130813},{0x4A,2,0,0,0,-131071},{0x9A,1,2,4,1028,-130043},{0x11,0,256,28,131100,29},{0xB7,6,0,259,259,-130812},{0x14,7,0,0,0,-131071},{0x9A,6,2,3,1027,-130044},{0x29,6,0,0,0,-131071},{0x11,5,256,23,131095,24},{0xB7,8,0,260,260,-130811},{0x4A,9,7,0,3584,-127487},{0x9A,8,2,2,1026,-130045},{0x4F,0,8,261,4357,-126714},{0x11,5,256,18,131090,19},{0xBD,8,7,0,3584,-127487},{0x85,0,262,8,134152,3081},{0x11,5,256,15,131087,16},{0xB7,8,0,259,259,-130812},{0x14,9,0,1,1,-131070},{0x9A,8,2,3,1027,-130044},{0x29,8,0,0,0,-131071},{0x11,5,256,10,131082,11},{0xB7,10,0,260,260,-130811},{0x4A,11,9,0,4608,-126463},{0x9A,10,2,2,1026,-130045},{0x4F,0,10,263,5383,-125688},{0x11,5,256,5,131077,6},{0x3E,10,9,264,4872,-126199},{0x29,10,0,0,0,-131071},{0x11,5,256,2,131074,3},{0x37,9,2,0,1024,-130047},{0x11,5,256,0,131072,1},{0x11,5,255,511,131071,0},{0xA2,1,0,2,2,-131069},{0xB9,3,255,480,131040,-31},{0x91,1,0,0,0,-131071},{0x37,1,2,0,1024,-130047},{0x37,0,1,0,512,-130559} },
        k = { "https://sirius.menu/rayfield","https://raw.githubusercontent.com/jensonhirst/Rayfield/main/source","ipairs","pcall","type","string",100,"table","CreateWindow" },
        p = { {
        c = { {0xB7,0,0,256,256,-130815},{0x16,0,0,257,257,-130814},{0x24,2,1,0,512,-130559},{0x71,0,3,0,1536,-129535},{0x37,0,0,0,0,-131071},{0x37,0,1,0,512,-130559} },
        k = { "game","HttpGet" },
        p = {  },
        u = { {0,0},{1,5} },
        np = 0,
        va = 0
    },{
        c = { {0xB7,0,0,256,256,-130815},{0x24,1,1,0,512,-130559},{0x9A,0,2,2,1026,-130045},{0x71,0,1,0,512,-130559},{0x37,0,0,0,0,-131071},{0x37,0,1,0,512,-130559} },
        k = { "loadstring" },
        p = {  },
        u = { {0,0},{1,7} },
        np = 0,
        va = 0
    } },
        u = { {0,0} },
        np = 0,
        va = 0
    },{
        c = { {0x24,1,0,0,0,-131071},{0x9A,1,1,2,514,-130557},{0x29,1,0,1,1,-131070},{0x11,0,256,3,131075,4},{0xB7,2,1,256,768,-130303},{0x1F,3,0,1,1,-131070},{0x9A,2,2,1,1025,-130046},{0x37,0,1,0,512,-130559},{0x16,2,1,258,770,-130301},{0xAA,4,0,6,6,-131065},{0x73,4,259,260,132868,1797},{0x73,4,261,260,133892,2821},{0x73,4,262,263,134407,3336},{0xAA,5,0,1,1,-131070},{0x73,5,265,266,135946,4875},{0x73,4,264,5,135173,4102},{0xAA,5,0,1,1,-131070},{0x73,5,265,266,135946,4875},{0x73,4,267,5,136709,5638},{0x73,4,268,266,137482,6411},{0x9A,2,3,2,1538,-129533},{0x16,3,2,269,1293,-129778},{0x1F,5,0,14,14,-131057},{0x91,6,0,0,0,-131071},{0x9A,3,4,2,2050,-129021},{0x24,4,2,0,1024,-130047},{0x9A,4,1,2,514,-130557},{0x16,5,3,271,1807,-129264},{0x1F,7,0,16,16,-131055},{0x9A,5,3,1,1537,-129534},{0x29,4,0,0,0,-131071},{0x11,0,256,23,131095,24},{0x16,5,3,273,1809,-129262},{0xAA,7,0,2,2,-131069},{0x73,7,274,275,140563,9492},{0x1F,8,0,21,21,-131050},{0x3E,9,4,259,2307,-128764},{0x1F,10,0,22,22,-131049},{0xB7,11,1,279,791,-130280},{0x3E,12,4,280,2328,-128743},{0x9A,11,2,2,1026,-130045},{0x1F,12,0,25,25,-131046},{0x34,8,8,12,4108,-126963},{0x73,7,276,8,141320,10249},{0x9A,5,3,1,1537,-129534},{0x16,5,3,282,1818,-129253},{0xAA,7,0,2,2,-131069},{0x1F,8,0,27,27,-131044},{0x3E,9,4,259,2307,-128764},{0x1F,10,0,28,28,-131043},{0x34,8,8,10,4106,-126965},{0x73,7,259,8,132616,1545},{0x14,8,0,0,0,-131071},{0x73,7,285,8,145928,14857},{0x9A,5,3,1,1537,-129534},{0x11,0,256,4,131076,5},{0x16,5,3,273,1809,-129262},{0xAA,7,0,2,2,-131069},{0x73,7,274,286,140574,9503},{0x73,7,276,287,141599,10528},{0x9A,5,3,1,1537,-129534},{0x16,5,3,271,1807,-129264},{0x1F,7,0,32,32,-131039},{0x9A,5,3,1,1537,-129534},{0xB7,5,1,289,801,-130270},{0x24,6,4,0,2048,-129023},{0x9A,5,2,4,1028,-130043},{0x11,0,256,57,131129,58},{0x3E,10,9,259,4867,-126204},{0xB7,11,1,290,802,-130269},{0x14,12,0,1,1,-131070},{0x9A,11,2,1,1025,-130046},{0xB7,11,1,291,803,-130268},{0x3E,11,11,280,5912,-125159},{0x3E,12,9,280,4888,-126183},{0x4F,1,11,12,5644,-125427},{0x11,0,256,0,131072,1},{0x6D,11,0,1,1,-131070},{0x6D,11,1,0,512,-130559},{0x29,11,0,0,0,-131071},{0x11,0,256,2,131074,3},{0x1F,12,0,36,36,-131035},{0x29,12,0,1,1,-131070},{0x11,0,256,0,131072,1},{0x1F,12,0,37,37,-131034},{0x16,13,3,273,1809,-129262},{0xAA,15,0,2,2,-131069},{0x73,15,274,10,140298,9227},{0x1F,16,0,38,38,-131033},{0xB7,17,1,279,791,-130280},{0x3E,18,9,280,4888,-126183},{0x9A,17,2,2,1026,-130045},{0x1F,18,0,39,39,-131032},{0x4A,19,12,0,6144,-124927},{0x1F,20,0,40,40,-131031},{0xB7,21,1,279,791,-130280},{0x3E,22,9,280,4888,-126183},{0x9A,21,2,2,1026,-130045},{0x1F,22,0,41,41,-131030},{0x34,16,16,22,8214,-122857},{0x73,15,276,16,141328,10257},{0x9A,13,3,1,1537,-129534},{0x29,11,0,0,0,-131071},{0x11,0,256,10,131082,11},{0x16,13,3,282,1818,-129253},{0xAA,15,0,2,2,-131069},{0x1F,16,0,27,27,-131044},{0x3E,17,9,259,4867,-126204},{0x1F,18,0,28,28,-131043},{0x34,16,16,18,8210,-122861},{0x73,15,259,16,132624,1553},{0x14,16,0,2,2,-131069},{0x73,15,285,16,145936,14865},{0x9A,13,3,1,1537,-129534},{0x11,9,256,10,131082,11},{0x16,13,3,282,1818,-129253},{0xAA,15,0,2,2,-131069},{0x1F,16,0,42,42,-131029},{0x3E,17,9,259,4867,-126204},{0x34,16,16,17,8209,-122862},{0x73,15,259,16,132624,1553},{0x14,16,0,3,3,-131068},{0x73,15,285,16,145936,14865},{0x9A,13,3,1,1537,-129534},{0x11,9,256,0,131072,1},{0x11,9,255,511,131071,0},{0xA2,5,0,2,2,-131069},{0xB9,7,255,451,131011,-60},{0x16,5,2,269,1293,-129778},{0x1F,7,0,43,43,-131028},{0x91,8,0,0,0,-131071},{0x9A,5,4,2,2050,-129021},{0x16,6,5,271,2831,-128240},{0x1F,8,0,44,44,-131027},{0x9A,6,3,1,1537,-129534},{0x4A,6,0,0,0,-131071},{0xBD,7,6,0,3072,-127999},{0x85,0,301,7,154119,23048},{0x11,0,256,7,131079,8},{0xB7,7,1,302,814,-130257},{0x3E,7,7,303,3887,-127184},{0x4A,8,6,0,3072,-127999},{0x1F,9,0,48,48,-131023},{0x1F,10,0,45,45,-131026},{0x9A,7,4,2,2050,-129021},{0x1F,8,0,49,49,-131022},{0x34,6,7,8,3592,-127479},{0x16,7,5,273,2833,-128238},{0xAA,9,0,2,2,-131069},{0x73,9,274,306,140594,9523},{0x1F,10,0,51,51,-131020},{0x4A,11,6,0,3072,-127999},{0x1F,12,0,52,52,-131019},{0x24,13,8,0,4096,-126975},{0x1F,14,0,53,53,-131018},{0x24,15,9,0,4608,-126463},{0x34,10,10,15,5135,-125936},{0x73,9,276,10,141322,10251},{0x9A,7,3,1,1537,-129534},{0x16,7,5,282,2842,-128229},{0xAA,9,0,2,2,-131069},{0x73,9,259,310,132918,1847},{0x14,10,0,4,4,-131067},{0x73,9,285,10,145930,14859},{0x9A,7,3,1,1537,-129534},{0x16,7,5,282,2842,-128229},{0xAA,9,0,2,2,-131069},{0x73,9,259,311,132919,1848},{0x14,10,0,5,5,-131066},{0x73,9,285,10,145930,14859},{0x9A,7,3,1,1537,-129534},{0x16,7,5,282,2842,-128229},{0xAA,9,0,2,2,-131069},{0x73,9,259,312,132920,1849},{0x14,10,0,6,6,-131065},{0x73,9,285,10,145930,14859},{0x9A,7,3,1,1537,-129534},{0x16,7,1,313,825,-130246},{0xAA,9,0,3,3,-131068},{0x73,9,274,260,140548,9477},{0x73,9,276,314,141626,10555},{0x73,9,315,316,161596,30525},{0x9A,7,3,1,1537,-129534},{0x37,0,1,0,512,-130559} },
        k = { "warn","[MintraZERX] Failed to load Rayfield library.","CreateWindow","Name","Loader Script","LoadingTitle","LoadingSubtitle","made by valexcryzer","ConfigurationSaving","Enabled",false,"Discord","KeySystem","CreateTab","Games Hub","CreateSection","CURRENT SESSION","CreateParagraph","Title","Detected Active Game","Content","You are currently playing: "," (Place ID: ","tostring","PlaceId",")\
Status: Ready to load script.","CreateButton","Launch "," Script","Callback","No Supported Game Active","Current game is not in the supported list. Select a game below to launch or teleport.","ALL SUPPORTED GAMES","ipairs","pcall","game","Status: Currently in this game","Status: Not in this game","Place ID: ","\
","\
Thumbnail: rbxthumb://type=GameIcon&id=","&w=150&h=150","Teleport to ","License Info","LICENSE STATUS",8,"string","sub",1,"-****-****","Active License","Key: ","\
Hardware ID: ","\
Server: ","Copy Redeem Portal Link","Clear Saved Key & Logout","Close Loader Script","Notify","Authenticated successfully.","Duration",3.5 },
        p = { {
        c = { {0x24,0,0,0,0,-131071},{0x24,1,1,0,512,-130559},{0xB7,2,2,256,1280,-129791},{0xB7,3,2,257,1281,-129790},{0x24,4,3,0,1536,-129535},{0x9A,0,5,1,2561,-128510},{0x37,0,1,0,512,-130559} },
        k = { "Id","Name" },
        p = {  },
        u = { {0,3},{1,0},{1,4},{1,1} },
        np = 0,
        va = 0
    },{
        c = { {0x24,0,0,0,0,-131071},{0x16,0,0,256,256,-130815},{0xB7,2,1,257,769,-130302},{0x9A,0,3,2,1538,-129533},{0x29,0,0,0,0,-131071},{0x11,0,256,4,131076,5},{0x3E,1,0,258,258,-130813},{0x29,1,0,0,0,-131071},{0x11,0,256,1,131073,2},{0x3E,1,0,258,258,-130813},{0x58,1,2,0,1024,-130047},{0x37,0,1,0,512,-130559} },
        k = { "GetProductInfo","PlaceId","Name" },
        p = {  },
        u = { {0,5},{1,9},{1,10} },
        np = 0,
        va = 0
    },{
        c = { {0x24,0,0,0,0,-131071},{0x24,1,1,0,512,-130559},{0xB7,2,2,256,1280,-129791},{0xB7,3,2,257,1281,-129790},{0x24,4,3,0,1536,-129535},{0x9A,0,5,1,2561,-128510},{0x37,0,1,0,512,-130559} },
        k = { "Id","Name" },
        p = {  },
        u = { {0,3},{1,0},{1,9},{1,1} },
        np = 0,
        va = 0
    },{
        c = { {0x24,0,0,0,0,-131071},{0x16,0,0,256,256,-130815},{0xAA,2,0,3,3,-131068},{0x73,2,257,258,131842,771},{0x1F,3,0,4,4,-131067},{0xB7,4,1,261,773,-130298},{0x1F,5,0,6,6,-131065},{0x34,3,3,5,1541,-129530},{0x73,2,259,3,132611,1540},{0x73,2,263,264,134920,3849},{0x9A,0,3,1,1537,-129534},{0xB7,0,2,265,1289,-129782},{0x14,1,0,0,0,-131071},{0x9A,0,2,1,1025,-130046},{0x37,0,1,0,512,-130559} },
        k = { "Notify","Title","Teleporting","Content","Connecting to ","Name","...","Duration",4,"pcall" },
        p = { {
        c = { {0x24,0,0,0,0,-131071},{0x16,0,0,256,256,-130815},{0xB7,2,1,257,769,-130302},{0x24,3,2,0,1024,-130047},{0x9A,0,4,1,2049,-129022},{0x37,0,1,0,512,-130559} },
        k = { "Teleport","PlaceId" },
        p = {  },
        u = { {0,3},{0,1},{0,4} },
        np = 0,
        va = 0
    } },
        u = { {1,1},{1,9},{0,1},{0,6},{0,7} },
        np = 0,
        va = 0
    },{
        c = { {0xB7,0,0,256,256,-130815},{0x29,0,0,0,0,-131071},{0x11,0,256,10,131082,11},{0xB7,0,0,256,256,-130815},{0x24,1,1,0,512,-130559},{0x9A,0,2,1,1025,-130046},{0x24,0,2,0,1024,-130047},{0x16,0,0,257,257,-130814},{0xAA,2,0,3,3,-131068},{0x73,2,258,259,132355,1284},{0x73,2,260,261,133381,2310},{0x73,2,262,263,134407,3336},{0x9A,0,3,1,1537,-129534},{0x11,0,256,7,131079,8},{0x24,0,2,0,1024,-130047},{0x16,0,0,257,257,-130814},{0xAA,2,0,3,3,-131068},{0x73,2,258,264,132360,1289},{0x24,3,1,0,512,-130559},{0x73,2,260,3,133123,2052},{0x73,2,262,265,134409,3338},{0x9A,0,3,1,1537,-129534},{0x37,0,1,0,512,-130559} },
        k = { "setclipboard","Notify","Title","Copied","Content","Redeem portal link copied to clipboard.","Duration",3,"Redeem URL",6 },
        p = {  },
        u = { {0,1},{0,10},{1,1} },
        np = 0,
        va = 0
    },{
        c = { {0xB7,0,0,256,256,-130815},{0x14,1,0,0,0,-131071},{0x9A,0,2,1,1025,-130046},{0x24,0,2,0,1024,-130047},{0x16,0,0,257,257,-130814},{0xAA,2,0,3,3,-131068},{0x73,2,258,259,132355,1284},{0x73,2,260,261,133381,2310},{0x73,2,262,263,134407,3336},{0x9A,0,3,1,1537,-129534},{0x37,0,1,0,512,-130559} },
        k = { "pcall","Notify","Title","Logged Out","Content","Saved key cleared. Please restart the loader.","Duration",5 },
        p = { {
        c = { {0x1F,0,0,0,0,-131071},{0x24,1,0,0,0,-131071},{0x1F,2,0,1,1,-131070},{0x34,0,0,2,2,-131069},{0xB7,1,1,258,770,-130301},{0x29,1,0,0,0,-131071},{0x11,0,256,7,131079,8},{0xB7,1,1,259,771,-130300},{0x4A,2,0,0,0,-131071},{0x9A,1,2,2,1026,-130045},{0x29,1,0,0,0,-131071},{0x11,0,256,2,131074,3},{0xB7,1,1,258,770,-130301},{0x4A,2,0,0,0,-131071},{0x9A,1,2,1,1025,-130046},{0xB7,1,1,258,770,-130301},{0x29,1,0,0,0,-131071},{0x11,0,256,7,131079,8},{0xB7,1,1,259,771,-130300},{0x1F,2,0,4,4,-131067},{0x9A,1,2,2,1026,-130045},{0x29,1,0,0,0,-131071},{0x11,0,256,2,131074,3},{0xB7,1,1,258,770,-130301},{0x1F,2,0,4,4,-131067},{0x9A,1,2,1,1025,-130046},{0x37,0,1,0,512,-130559} },
        k = { "Rayfield/Key System/",".rfld","delfile","isfile","mintrazerx_key.txt" },
        p = {  },
        u = { {0,1},{0,0} },
        np = 0,
        va = 0
    } },
        u = { {0,1},{0,11},{1,1} },
        np = 0,
        va = 0
    },{
        c = { {0x24,0,0,0,0,-131071},{0x16,0,0,256,256,-130815},{0x9A,0,2,1,1025,-130046},{0x37,0,1,0,512,-130559} },
        k = { "Destroy" },
        p = {  },
        u = { {1,1} },
        np = 0,
        va = 0
    } },
        u = { {1,24},{0,0},{1,23},{1,21},{1,22},{1,5},{1,6},{1,9},{1,15},{1,0},{1,1},{1,2} },
        np = 1,
        va = 0
    },{
        c = { {0xB7,0,0,256,256,-130815},{0x29,0,0,0,0,-131071},{0x11,0,256,3,131075,4},{0xB7,0,0,256,256,-130815},{0x9A,0,1,2,514,-130557},{0x29,0,0,1,1,-131070},{0x11,0,256,0,131072,1},{0x24,0,1,0,512,-130559},{0x16,1,0,257,257,-130814},{0x1F,3,0,2,2,-131069},{0x9A,1,3,2,1538,-129533},{0x29,1,0,0,0,-131071},{0x11,0,256,1,131073,2},{0x16,2,1,259,771,-130300},{0x9A,2,2,1,1025,-130046},{0xB7,2,0,260,260,-130811},{0x3E,2,2,261,1285,-129786},{0x1F,3,0,6,6,-131065},{0x9A,2,2,2,1026,-130045},{0x73,2,263,258,134914,3843},{0x73,2,264,265,135433,4362},{0xB7,3,0,267,267,-130804},{0x3E,3,3,266,1802,-129269},{0x3E,3,3,268,1804,-129267},{0x73,2,266,3,136195,5124},{0xB7,3,0,260,260,-130811},{0x3E,3,3,261,1797,-129274},{0x1F,4,0,13,13,-131058},{0x9A,3,2,2,1026,-130045},{0x73,3,263,270,134926,3855},{0xB7,4,0,272,272,-130799},{0x3E,4,4,261,2309,-128762},{0x1F,5,0,17,17,-131054},{0x1F,6,0,18,18,-131053},{0x1F,7,0,17,17,-131054},{0x1F,8,0,19,19,-131052},{0x9A,4,5,2,2562,-128509},{0x73,3,271,4,138756,7685},{0xB7,4,0,272,272,-130799},{0x3E,4,4,261,2309,-128762},{0x1F,5,0,21,21,-131050},{0x1F,6,0,22,22,-131049},{0x1F,7,0,21,21,-131050},{0x1F,8,0,23,23,-131048},{0x9A,4,5,2,2562,-128509},{0x73,3,276,4,141316,10245},{0xB7,4,0,281,281,-130790},{0x3E,4,4,282,2330,-128741},{0x1F,5,0,27,27,-131044},{0x1F,6,0,27,27,-131044},{0x1F,7,0,28,28,-131043},{0x9A,4,4,2,2050,-129021},{0x73,3,280,4,143364,12293},{0x73,3,285,273,146193,15122},{0x73,3,286,287,146719,15648},{0x73,3,288,287,147743,16672},{0x73,3,289,2,147970,16899},{0xB7,4,0,260,260,-130811},{0x3E,4,4,261,2309,-128762},{0x1F,5,0,34,34,-131037},{0x9A,4,2,2,1026,-130045},{0xB7,5,0,292,292,-130779},{0x3E,5,5,261,2821,-128250},{0x1F,6,0,17,17,-131054},{0x1F,7,0,37,37,-131034},{0x9A,5,3,2,1538,-129533},{0x73,4,291,5,148997,17926},{0x73,4,289,3,147971,16900},{0xB7,5,0,260,260,-130811},{0x3E,5,5,261,2821,-128250},{0x1F,6,0,38,38,-131033},{0x9A,5,2,2,1026,-130045},{0xB7,6,0,281,281,-130790},{0x3E,6,6,282,3354,-127717},{0x1F,7,0,40,40,-131031},{0x1F,8,0,40,40,-131031},{0x1F,9,0,41,41,-131030},{0x9A,6,4,2,2050,-129021},{0x73,5,295,6,151046,19975},{0x73,5,298,299,152875,21804},{0x73,5,289,3,147971,16900},{0xB7,6,0,260,260,-130811},{0x3E,6,6,261,3333,-127738},{0x1F,7,0,13,13,-131058},{0x9A,6,2,2,1026,-130045},{0x73,6,263,300,134956,3885},{0xB7,7,0,272,272,-130799},{0x3E,7,7,261,3845,-127226},{0x1F,8,0,17,17,-131054},{0x1F,9,0,45,45,-131026},{0x1F,10,0,17,17,-131054},{0x1F,11,0,45,45,-131026},{0x9A,7,5,2,2562,-128509},{0x73,6,271,7,138759,7688},{0xB7,7,0,272,272,-130799},{0x3E,7,7,261,3845,-127226},{0x1F,8,0,17,17,-131054},{0x1F,9,0,46,46,-131025},{0x1F,10,0,17,17,-131054},{0x1F,11,0,47,47,-131024},{0x9A,7,5,2,2562,-128509},{0x73,6,276,7,141319,10248},{0xB7,7,0,281,281,-130790},{0x3E,7,7,282,3866,-127205},{0x1F,8,0,48,48,-131023},{0x1F,9,0,48,48,-131023},{0x1F,10,0,49,49,-131022},{0x9A,7,4,2,2050,-129021},{0x73,6,280,7,143367,12296},{0x73,6,285,273,146193,15122},{0x73,6,289,3,147971,16900},{0xB7,7,0,260,260,-130811},{0x3E,7,7,261,3845,-127226},{0x1F,8,0,34,34,-131037},{0x9A,7,2,2,1026,-130045},{0xB7,8,0,292,292,-130779},{0x3E,8,8,261,4357,-126714},{0x1F,9,0,50,50,-131021},{0x1F,10,0,17,17,-131054},{0x9A,8,3,2,1538,-129533},{0x73,7,291,8,149000,17929},{0x73,7,289,6,147974,16903},{0xB7,8,0,260,260,-130811},{0x3E,8,8,261,4357,-126714},{0x1F,9,0,38,38,-131033},{0x9A,8,2,2,1026,-130045},{0xB7,9,0,281,281,-130790},{0x3E,9,9,282,4890,-126181},{0x1F,10,0,51,51,-131020},{0x1F,11,0,52,52,-131019},{0x1F,12,0,53,53,-131018},{0x9A,9,4,2,2050,-129021},{0x73,8,295,9,151049,19978},{0x73,8,298,310,152886,21815},{0x73,8,289,6,147974,16903},{0xB7,9,0,311,311,-130760},{0x14,10,0,0,0,-131071},{0x9A,9,2,1,1025,-130046},{0xB7,9,0,260,260,-130811},{0x3E,9,9,261,4869,-126202},{0x1F,10,0,56,56,-131015},{0x9A,9,2,2,1026,-130045},{0x73,9,263,313,134969,3898},{0xB7,10,0,272,272,-130799},{0x3E,10,10,261,5381,-125690},{0x1F,11,0,50,50,-131021},{0x1F,12,0,58,58,-131013},{0x1F,13,0,50,50,-131021},{0x1F,14,0,58,58,-131013},{0x9A,10,5,2,2562,-128509},{0x73,9,271,10,138762,7691},{0xB7,10,0,272,272,-130799},{0x3E,10,10,261,5381,-125690},{0x1F,11,0,17,17,-131054},{0x1F,12,0,59,59,-131012},{0x1F,13,0,17,17,-131054},{0x1F,14,0,59,59,-131012},{0x9A,10,5,2,2562,-128509},{0x73,9,276,10,141322,10251},{0x73,9,316,306,162098,31027},{0x73,9,317,318,162622,31551},{0x73,9,289,6,147974,16903},{0xB7,10,0,260,260,-130811},{0x3E,10,10,261,5381,-125690},{0x1F,11,0,34,34,-131037},{0x9A,10,2,2,1026,-130045},{0xB7,11,0,292,292,-130779},{0x3E,11,11,261,5893,-125178},{0x1F,12,0,50,50,-131021},{0x1F,13,0,17,17,-131054},{0x9A,11,3,2,1538,-129533},{0x73,10,291,11,149003,17932},{0x73,10,289,9,147977,16906},{0xB7,11,0,319,319,-130752},{0x3E,11,11,320,5952,-125119},{0x14,12,0,1,1,-131070},{0x9A,11,2,1,1025,-130046},{0xB7,11,0,260,260,-130811},{0x3E,11,11,261,5893,-125178},{0x1F,12,0,13,13,-131058},{0x9A,11,2,2,1026,-130045},{0x73,11,263,321,134977,3906},{0xB7,12,0,272,272,-130799},{0x3E,12,12,261,6405,-124666},{0x1F,13,0,50,50,-131021},{0x1F,14,0,66,66,-131005},{0x1F,15,0,17,17,-131054},{0x1F,16,0,67,67,-131004},{0x9A,12,5,2,2562,-128509},{0x73,11,271,12,138764,7693},{0xB7,12,0,272,272,-130799},{0x3E,12,12,261,6405,-124666},{0x1F,13,0,17,17,-131054},{0x1F,14,0,68,68,-131003},{0x1F,15,0,17,17,-131054},{0x1F,16,0,47,47,-131024},{0x9A,12,5,2,2562,-128509},{0x73,11,276,12,141324,10253},{0x73,11,316,306,162098,31027},{0x73,11,289,3,147971,16900},{0xB7,12,0,260,260,-130811},{0x3E,12,12,261,6405,-124666},{0x1F,13,0,69,69,-131002},{0x9A,12,2,2,1026,-130045},{0x73,12,263,326,134982,3911},{0x73,12,327,328,167752,36681},{0xB7,13,0,267,267,-130804},{0x3E,13,13,329,6985,-124086},{0x3E,13,13,330,6986,-124085},{0x73,12,329,13,168461,37390},{0x73,12,331,302,169774,38703},{0xB7,13,0,281,281,-130790},{0x3E,13,13,282,6938,-124133},{0x1F,14,0,77,77,-130994},{0x1F,15,0,77,77,-130994},{0x1F,16,0,78,78,-130993},{0x9A,13,4,2,2050,-129021},{0x73,12,332,13,169997,38926},{0xB7,13,0,272,272,-130799},{0x3E,13,13,261,6917,-124154},{0x1F,14,0,50,50,-131021},{0x1F,15,0,17,17,-131054},{0x1F,16,0,50,50,-131021},{0x1F,17,0,17,17,-131054},{0x9A,13,5,2,2562,-128509},{0x73,12,271,13,138765,7694},{0x73,12,316,306,162098,31027},{0xB7,13,0,267,267,-130804},{0x3E,13,13,335,6991,-124080},{0x3E,13,13,336,6992,-124079},{0x73,12,335,13,171533,40462},{0x73,12,289,11,147979,16908},{0xB7,13,0,260,260,-130811},{0x3E,13,13,261,6917,-124154},{0x1F,14,0,69,69,-131002},{0x9A,13,2,2,1026,-130045},{0x73,13,263,337,134993,3922},{0x73,13,327,338,167762,36691},{0xB7,14,0,267,267,-130804},{0x3E,14,14,329,7497,-123574},{0x3E,14,14,339,7507,-123564},{0x73,13,329,14,168462,37391},{0x73,13,331,340,169812,38741},{0xB7,14,0,281,281,-130790},{0x3E,14,14,282,7450,-123621},{0x1F,15,0,85,85,-130986},{0x1F,16,0,86,86,-130985},{0x1F,17,0,87,87,-130984},{0x9A,14,4,2,2050,-129021},{0x73,13,332,14,169998,38927},{0xB7,14,0,272,272,-130799},{0x3E,14,14,261,7429,-123642},{0x1F,15,0,50,50,-131021},{0x1F,16,0,66,66,-131005},{0x1F,17,0,17,17,-131054},{0x1F,18,0,88,88,-130983},{0x9A,14,5,2,2562,-128509},{0x73,13,271,14,138766,7695},{0xB7,14,0,272,272,-130799},{0x3E,14,14,261,7429,-123642},{0x1F,15,0,17,17,-131054},{0x1F,16,0,68,68,-131003},{0x1F,17,0,17,17,-131054},{0x1F,18,0,89,89,-130982},{0x9A,14,5,2,2562,-128509},{0x73,13,276,14,141326,10255},{0x73,13,316,306,162098,31027},{0xB7,14,0,267,267,-130804},{0x3E,14,14,335,7503,-123568},{0x3E,14,14,336,7504,-123567},{0x73,13,335,14,171534,40463},{0x73,13,289,3,147971,16900},{0xB7,14,0,281,281,-130790},{0x3E,14,14,282,7450,-123621},{0x1F,15,0,85,85,-130986},{0x1F,16,0,86,86,-130985},{0x1F,17,0,87,87,-130984},{0x9A,14,4,2,2050,-129021},{0x73,13,332,14,169998,38927},{0xB7,14,0,272,272,-130799},{0x3E,14,14,261,7429,-123642},{0x1F,15,0,50,50,-131021},{0x1F,16,0,66,66,-131005},{0x1F,17,0,17,17,-131054},{0x1F,18,0,88,88,-130983},{0x9A,14,5,2,2562,-128509},{0x73,13,271,14,138766,7695},{0xB7,14,0,272,272,-130799},{0x3E,14,14,261,7429,-123642},{0x1F,15,0,17,17,-131054},{0x1F,16,0,68,68,-131003},{0x1F,17,0,17,17,-131054},{0x1F,18,0,89,89,-130982},{0x9A,14,5,2,2562,-128509},{0x73,13,276,14,141326,10255},{0x73,13,316,306,162098,31027},{0xB7,14,0,267,267,-130804},{0x3E,14,14,335,7503,-123568},{0x3E,14,14,336,7504,-123567},{0x73,13,335,14,171534,40463},{0x73,13,289,3,147971,16900},{0xB7,14,0,260,260,-130811},{0x3E,14,14,261,7429,-123642},{0x1F,15,0,90,90,-130981},{0x9A,14,2,2,1026,-130045},{0x73,14,263,347,135003,3932},{0x73,14,327,348,167772,36701},{0xB7,15,0,267,267,-130804},{0x3E,15,15,329,8009,-123062},{0x3E,15,15,330,8010,-123061},{0x73,14,329,15,168463,37392},{0x73,14,331,303,169775,38704},{0xB7,15,0,281,281,-130790},{0x3E,15,15,282,7962,-123109},{0x1F,16,0,93,93,-130978},{0x1F,17,0,93,93,-130978},{0x1F,18,0,87,87,-130984},{0x9A,15,4,2,2050,-129021},{0x73,14,332,15,169999,38928},{0x73,14,316,306,162098,31027},{0xB7,15,0,272,272,-130799},{0x3E,15,15,261,7941,-123130},{0x1F,16,0,17,17,-131054},{0x1F,17,0,48,48,-131023},{0x1F,18,0,17,17,-131054},{0x1F,19,0,48,48,-131023},{0x9A,15,5,2,2562,-128509},{0x73,14,271,15,138767,7696},{0xB7,15,0,272,272,-130799},{0x3E,15,15,261,7941,-123130},{0x1F,16,0,50,50,-131021},{0x1F,17,0,94,94,-130977},{0x1F,18,0,17,17,-131054},{0x1F,19,0,47,47,-131024},{0x9A,15,5,2,2562,-128509},{0x73,14,276,15,141327,10256},{0x73,14,289,3,147971,16900},{0x3E,15,14,351,7519,-123552},{0x16,15,15,352,8032,-123039},{0x14,17,0,2,2,-131069},{0x9A,15,3,1,1537,-129534},{0xB7,15,0,260,260,-130811},{0x3E,15,15,261,7941,-123130},{0x1F,16,0,13,13,-131058},{0x9A,15,2,2,1026,-130045},{0x73,15,263,353,135009,3938},{0xB7,16,0,272,272,-130799},{0x3E,16,16,261,8453,-122618},{0x1F,17,0,50,50,-131021},{0x1F,18,0,98,98,-130973},{0x1F,19,0,17,17,-131054},{0x1F,20,0,45,45,-131026},{0x9A,16,5,2,2562,-128509},{0x73,15,271,16,138768,7697},{0xB7,16,0,272,272,-130799},{0x3E,16,16,261,8453,-122618},{0x1F,17,0,17,17,-131054},{0x1F,18,0,99,99,-130972},{0x1F,19,0,17,17,-131054},{0x1F,20,0,68,68,-131003},{0x9A,16,5,2,2562,-128509},{0x73,15,276,16,141328,10257},{0xB7,16,0,281,281,-130790},{0x3E,16,16,282,8474,-122597},{0x1F,17,0,100,100,-130971},{0x1F,18,0,100,100,-130971},{0x1F,19,0,89,89,-130982},{0x9A,16,4,2,2050,-129021},{0x73,15,280,16,143376,12305},{0x73,15,285,273,146193,15122},{0x73,15,289,3,147971,16900},{0xB7,16,0,260,260,-130811},{0x3E,16,16,261,8453,-122618},{0x1F,17,0,34,34,-131037},{0x9A,16,2,2,1026,-130045},{0xB7,17,0,292,292,-130779},{0x3E,17,17,261,8965,-122106},{0x1F,18,0,17,17,-131054},{0x1F,19,0,101,101,-130970},{0x9A,17,3,2,1538,-129533},{0x73,16,291,17,149009,17938},{0x73,16,289,15,147983,16912},{0xB7,17,0,260,260,-130811},{0x3E,17,17,261,8965,-122106},{0x1F,18,0,38,38,-131033},{0x9A,17,2,2,1026,-130045},{0xB7,18,0,281,281,-130790},{0x3E,18,18,282,9498,-121573},{0x1F,19,0,102,102,-130969},{0x1F,20,0,102,102,-130969},{0x1F,21,0,53,53,-131018},{0x9A,18,4,2,2050,-129021},{0x73,17,295,18,151058,19987},{0x73,17,298,306,152882,21811},{0x73,17,289,15,147983,16912},{0xB7,18,0,260,260,-130811},{0x3E,18,18,261,9477,-121594},{0x1F,19,0,103,103,-130968},{0x9A,18,2,2,1026,-130045},{0x73,18,263,360,135016,3945},{0xB7,19,0,272,272,-130799},{0x3E,19,19,261,9989,-121082},{0x1F,20,0,50,50,-131021},{0x1F,21,0,105,105,-130966},{0x1F,22,0,50,50,-131021},{0x1F,23,0,17,17,-131054},{0x9A,19,5,2,2562,-128509},{0x73,18,271,19,138771,7700},{0xB7,19,0,272,272,-130799},{0x3E,19,19,261,9989,-121082},{0x1F,20,0,17,17,-131054},{0x1F,21,0,37,37,-131034},{0x1F,22,0,17,17,-131054},{0x1F,23,0,17,17,-131054},{0x9A,19,5,2,2562,-128509},{0x73,18,276,19,141331,10260},{0x73,18,316,306,162098,31027},{0xB7,19,0,267,267,-130804},{0x3E,19,19,329,10057,-121014},{0x3E,19,19,362,10090,-120981},{0x73,18,329,19,168467,37396},{0x73,18,331,303,169775,38704},{0xB7,19,0,281,281,-130790},{0x3E,19,19,282,10010,-121061},{0x1F,20,0,107,107,-130964},{0x1F,21,0,107,107,-130964},{0x1F,22,0,107,107,-130964},{0x9A,19,4,2,2050,-129021},{0x73,18,332,19,170003,38932},{0x73,18,364,365,186733,55662},{0xB7,19,0,281,281,-130790},{0x3E,19,19,282,10010,-121061},{0x1F,20,0,111,111,-130960},{0x1F,21,0,111,111,-130960},{0x1F,22,0,112,112,-130959},{0x9A,19,4,2,2050,-129021},{0x73,18,366,19,187411,56340},{0x73,18,369,265,189193,58122},{0x73,18,289,15,147983,16912},{0xB7,19,0,260,260,-130811},{0x3E,19,19,261,9989,-121082},{0x1F,20,0,69,69,-131002},{0x9A,19,2,2,1026,-130045},{0x73,19,263,370,135026,3955},{0x73,19,327,371,167795,36724},{0xB7,20,0,267,267,-130804},{0x3E,20,20,329,10569,-120502},{0x3E,20,20,362,10602,-120469},{0x73,19,329,20,168468,37397},{0x73,19,331,340,169812,38741},{0xB7,20,0,281,281,-130790},{0x3E,20,20,282,10522,-120549},{0x1F,21,0,85,85,-130986},{0x1F,22,0,85,85,-130986},{0x1F,23,0,116,116,-130955},{0x9A,20,4,2,2050,-129021},{0x73,19,332,20,170004,38933},{0xB7,20,0,272,272,-130799},{0x3E,20,20,261,10501,-120570},{0x1F,21,0,50,50,-131021},{0x1F,22,0,98,98,-130973},{0x1F,23,0,17,17,-131054},{0x1F,24,0,46,46,-131025},{0x9A,20,5,2,2562,-128509},{0x73,19,271,20,138772,7701},{0xB7,20,0,272,272,-130799},{0x3E,20,20,261,10501,-120570},{0x1F,21,0,17,17,-131054},{0x1F,22,0,99,99,-130972},{0x1F,23,0,17,17,-131054},{0x1F,24,0,117,117,-130954},{0x9A,20,5,2,2562,-128509},{0x73,19,276,20,141332,10261},{0x73,19,316,306,162098,31027},{0xB7,20,0,267,267,-130804},{0x3E,20,20,335,10575,-120496},{0x3E,20,20,336,10576,-120495},{0x73,19,335,20,171540,40469},{0x73,19,289,3,147971,16900},{0xB7,20,0,260,260,-130811},{0x3E,20,20,261,10501,-120570},{0x1F,21,0,90,90,-130981},{0x9A,20,2,2,1026,-130045},{0x73,20,263,374,135030,3959},{0x73,20,327,375,167799,36728},{0xB7,21,0,267,267,-130804},{0x3E,21,21,329,11081,-119990},{0x3E,21,21,330,11082,-119989},{0x73,20,329,21,168469,37398},{0x73,20,331,376,169848,38777},{0xB7,21,0,281,281,-130790},{0x3E,21,21,282,11034,-120037},{0x1F,22,0,121,121,-130950},{0x1F,23,0,121,121,-130950},{0x1F,24,0,121,121,-130950},{0x9A,21,4,2,2050,-129021},{0x73,20,332,21,170005,38934},{0xB7,21,0,281,281,-130790},{0x3E,21,21,282,11034,-120037},{0x1F,22,0,122,122,-130949},{0x1F,23,0,123,123,-130948},{0x1F,24,0,124,124,-130947},{0x9A,21,4,2,2050,-129021},{0x73,20,280,21,143381,12310},{0xB7,21,0,272,272,-130799},{0x3E,21,21,261,11013,-120058},{0x1F,22,0,125,125,-130946},{0x1F,23,0,126,126,-130945},{0x1F,24,0,17,17,-131054},{0x1F,25,0,127,127,-130944},{0x9A,21,5,2,2562,-128509},{0x73,20,271,21,138773,7702},{0xB7,21,0,272,272,-130799},{0x3E,21,21,261,11013,-120058},{0x1F,22,0,17,17,-131054},{0x1F,23,0,99,99,-130972},{0x1F,24,0,17,17,-131054},{0x1F,25,0,128,128,-130943},{0x9A,21,5,2,2562,-128509},{0x73,20,276,21,141333,10262},{0x73,20,285,273,146193,15122},{0x73,20,289,3,147971,16900},{0xB7,21,0,260,260,-130811},{0x3E,21,21,261,11013,-120058},{0x1F,22,0,34,34,-131037},{0x9A,21,2,2,1026,-130045},{0xB7,22,0,292,292,-130779},{0x3E,22,22,261,11525,-119546},{0x1F,23,0,17,17,-131054},{0x1F,24,0,129,129,-130942},{0x9A,22,3,2,1538,-129533},{0x73,21,291,22,149014,17943},{0x73,21,289,20,147988,16917},{0xB7,22,0,260,260,-130811},{0x3E,22,22,261,11525,-119546},{0x1F,23,0,90,90,-130981},{0x9A,22,2,2,1026,-130045},{0x73,22,263,386,135042,3971},{0x73,22,327,387,167811,36740},{0xB7,23,0,267,267,-130804},{0x3E,23,23,329,12105,-118966},{0x3E,23,23,339,12115,-118956},{0x73,22,329,23,168471,37400},{0x73,22,331,340,169812,38741},{0xB7,23,0,281,281,-130790},{0x3E,23,23,282,12058,-119013},{0x1F,24,0,132,132,-130939},{0x1F,25,0,132,132,-130939},{0x1F,26,0,19,19,-131052},{0x9A,23,4,2,2050,-129021},{0x73,22,332,23,170007,38936},{0xB7,23,0,281,281,-130790},{0x3E,23,23,282,12058,-119013},{0x1F,24,0,127,127,-130944},{0x1F,25,0,127,127,-130944},{0x1F,26,0,45,45,-131026},{0x9A,23,4,2,2050,-129021},{0x73,22,280,23,143383,12312},{0xB7,23,0,272,272,-130799},{0x3E,23,23,261,12037,-119034},{0x1F,24,0,133,133,-130938},{0x1F,25,0,126,126,-130945},{0x1F,26,0,17,17,-131054},{0x1F,27,0,127,127,-130944},{0x9A,23,5,2,2562,-128509},{0x73,22,271,23,138775,7704},{0xB7,23,0,272,272,-130799},{0x3E,23,23,261,12037,-119034},{0x1F,24,0,125,125,-130946},{0x1F,25,0,134,134,-130937},{0x1F,26,0,17,17,-131054},{0x1F,27,0,128,128,-130943},{0x9A,23,5,2,2562,-128509},{0x73,22,276,23,141335,10264},{0x73,22,285,273,146193,15122},{0x73,22,289,3,147971,16900},{0xB7,23,0,260,260,-130811},{0x3E,23,23,261,12037,-119034},{0x1F,24,0,34,34,-131037},{0x9A,23,2,2,1026,-130045},{0xB7,24,0,292,292,-130779},{0x3E,24,24,261,12549,-118522},{0x1F,25,0,17,17,-131054},{0x1F,26,0,129,129,-130942},{0x9A,24,3,2,1538,-129533},{0x73,23,291,24,149016,17945},{0x73,23,289,22,147990,16919},{0x3E,24,22,351,11615,-119456},{0x16,24,24,352,12640,-118431},{0x14,26,0,3,3,-131068},{0x9A,24,3,1,1537,-129534},{0x6D,24,1,0,512,-130559},{0xB7,25,0,319,319,-130752},{0x3E,25,25,320,13120,-117951},{0x14,26,0,4,4,-131067},{0x9A,25,2,1,1025,-130046},{0x6D,25,0,0,0,-131071},{0x14,26,0,5,5,-131066},{0x3E,27,20,351,10591,-120480},{0x16,27,27,352,14176,-116895},{0x4A,29,26,0,13312,-117759},{0x9A,27,3,1,1537,-129534},{0x3E,27,18,391,9607,-121464},{0x16,27,27,352,14176,-116895},{0x14,29,0,6,6,-131065},{0x9A,27,3,1,1537,-129534},{0x73,2,289,0,147968,16897},{0x37,0,1,0,512,-130559} },
        k = { "gethui","FindFirstChild","MintraZERX_RayKeyUI","Destroy","Instance","new","ScreenGui","Name","ResetOnSpawn",false,"ZIndexBehavior","Enum","Sibling","Frame","KeyMain","Size","UDim2",0,500,215,"Position",0.5,-250,-107,"BackgroundColor3","Color3","fromRGB",22,26,"BorderSizePixel","Active",true,"Draggable","Parent","UICorner","CornerRadius","UDim",10,"UIStroke","Color",55,68,"Thickness",1.2,"BrandLogo",44,18,14,28,34,1,235,175,75,1.6,"pcall","ImageLabel","AvatarImage",-4,2,"BackgroundTransparency","Image","rbxthumb://type=AvatarHeadShot&id=10477883110&w=150&h=150","task","spawn","TitleFrame",-120,24,72,"TextLabel","Title","Text","MintraZERX","Font","GothamBold","TextSize","TextColor3",245,250,"TextXAlignment","Left","Subtitle","Key System Verification • Multi-Game Access Hub","GothamMedium",12,150,155,170,16,38,"TextButton","Close","X",160,-38,"MouseButton1Click","Connect","InputFrame",-40,20,32,8,60,"TextBox","InputBox",-20,"Gotham",240,"PlaceholderText","Paste your license key here...","PlaceholderColor3",120,135,"ClearTextOnFocus","NoteMessage","Enter key and click Verify or press Enter.",165,124,"VerifyButton","VERIFY KEY",13,255,45,110,230,0.55,-25,36,154,6,"GetKeyButton","GET KEY / REDEEM",200,0.45,5,"FocusLost" },
        p = { {
        c = { {0xB7,0,0,256,256,-130815},{0x29,0,0,0,0,-131071},{0x11,0,256,48,131120,49},{0xB7,0,0,257,257,-130814},{0x29,0,0,0,0,-131071},{0x11,0,256,45,131117,46},{0xB7,0,0,258,258,-130813},{0x29,0,0,0,0,-131071},{0x11,0,256,42,131114,43},{0xB7,0,0,259,259,-130812},{0x3E,0,0,260,260,-130811},{0x1F,1,0,2,2,-131069},{0x9A,0,2,2,1026,-130045},{0xB7,1,0,256,256,-130815},{0x3E,1,1,260,772,-130299},{0xAA,2,2,0,1024,-130047},{0xB7,3,0,257,257,-130814},{0x3E,3,3,260,1796,-129275},{0x1F,4,0,6,6,-131065},{0xB7,5,0,263,263,-130808},{0x3E,5,5,264,2824,-128247},{0x1F,6,0,9,9,-131062},{0x1F,7,0,10,10,-131061},{0x1F,8,0,11,11,-131060},{0x9A,5,4,0,2048,-129023},{0x9A,3,0,2,2,-131069},{0xB7,4,0,257,257,-130814},{0x3E,4,4,260,2308,-128763},{0x1F,5,0,12,12,-131059},{0xB7,6,0,263,263,-130808},{0x3E,6,6,264,3336,-127735},{0x1F,7,0,13,13,-131058},{0x1F,8,0,14,14,-131057},{0x1F,9,0,15,15,-131056},{0x9A,6,4,0,2048,-129023},{0x9A,4,0,2,2,-131069},{0xB7,5,0,257,257,-130814},{0x3E,5,5,260,2820,-128251},{0x1F,6,0,16,16,-131055},{0xB7,7,0,263,263,-130808},{0x3E,7,7,264,3848,-127223},{0x1F,8,0,17,17,-131054},{0x1F,9,0,18,18,-131053},{0x1F,10,0,19,19,-131052},{0x9A,7,4,0,2048,-129023},{0x9A,5,0,0,0,-131071},{0xC8,2,0,1,1,-131070},{0x9A,1,2,2,1026,-130045},{0x73,0,261,1,133633,2562},{0x73,0,276,277,141589,10518},{0x24,1,1,0,512,-130559},{0x73,0,278,1,142337,11266},{0x37,0,1,0,512,-130559} },
        k = { "ColorSequence","ColorSequenceKeypoint","UIGradient","Instance","new","Color",0,"Color3","fromRGB",250,205,110,0.5,225,160,60,1,180,115,35,"Rotation",45,"Parent" },
        p = {  },
        u = { {0,0},{1,8} },
        np = 0,
        va = 0
    },{
        c = { {0xB7,0,0,256,256,-130815},{0x14,1,0,0,0,-131071},{0x9A,0,2,1,1025,-130046},{0x37,0,1,0,512,-130559} },
        k = { "pcall" },
        p = { {
        c = { {0x24,0,0,0,0,-131071},{0x29,0,0,0,0,-131071},{0x11,0,256,18,131090,19},{0xB7,0,0,256,256,-130815},{0x29,0,0,0,0,-131071},{0x11,0,256,15,131087,16},{0x24,0,0,0,0,-131071},{0x16,0,0,256,256,-130815},{0x1F,2,0,1,1,-131070},{0xB7,3,1,258,770,-130301},{0x3E,3,3,259,1795,-129276},{0x3E,3,3,260,1796,-129275},{0xB7,4,1,258,770,-130301},{0x3E,4,4,261,2309,-128762},{0x3E,4,4,262,2310,-128761},{0x9A,0,5,2,2562,-128509},{0x29,0,0,0,0,-131071},{0x11,0,256,3,131075,4},{0xBD,1,0,0,0,-131071},{0x85,0,263,1,134657,3586},{0x11,0,256,0,131072,1},{0xC5,2,264,0,135168,4097},{0x37,0,1,0,512,-130559} },
        k = { "GetUserThumbnailAsync",10477883110,"Enum","ThumbnailType","HeadShot","ThumbnailSize","Size150x150",0,"Image" },
        p = {  },
        u = { {0,1},{0,0},{0,2} },
        np = 0,
        va = 0
    } },
        u = { {0,0},{0,2},{1,9} },
        np = 0,
        va = 0
    },{
        c = { {0x24,0,0,0,0,-131071},{0x16,0,0,256,256,-130815},{0x9A,0,2,1,1025,-130046},{0x37,0,1,0,512,-130559} },
        k = { "Destroy" },
        p = {  },
        u = { {1,2} },
        np = 0,
        va = 0
    },{
        c = { {0x24,0,0,0,0,-131071},{0x1F,1,0,0,0,-131071},{0x24,2,1,0,512,-130559},{0x16,2,2,257,1281,-129790},{0x24,4,2,0,1024,-130047},{0x9A,2,3,2,1538,-129533},{0x34,0,0,2,2,-131069},{0xB7,1,3,258,1794,-129277},{0x29,1,0,0,0,-131071},{0x11,0,256,11,131083,12},{0xB7,1,3,258,1794,-129277},{0x4A,2,0,0,0,-131071},{0x9A,1,2,1,1025,-130046},{0xC5,4,259,260,132868,1797},{0xB7,1,3,262,1798,-129273},{0x3E,1,1,263,775,-130296},{0x1F,2,0,8,8,-131063},{0x1F,3,0,9,9,-131062},{0x1F,4,0,10,10,-131061},{0x9A,1,4,2,2050,-129021},{0xC5,4,261,1,133633,2562},{0x11,0,256,3,131075,4},{0x1F,1,0,11,11,-131060},{0x4A,2,0,0,0,-131071},{0x34,1,1,2,514,-130557},{0xC5,4,259,1,132609,1538},{0x37,0,1,0,512,-130559} },
        k = { "/getkey?hwid=","UrlEncode","setclipboard","Text","GetKey link copied! Complete tasks in browser.","TextColor3","Color3","fromRGB",100,220,120,"URL: " },
        p = {  },
        u = { {0,3},{0,4},{0,5},{0,0},{1,19} },
        np = 0,
        va = 0
    },{
        c = { {0x24,0,0,0,0,-131071},{0x29,0,0,0,0,-131071},{0x11,0,256,68,131140,69},{0x24,0,1,0,512,-130559},{0x29,0,0,0,0,-131071},{0x11,0,256,65,131137,66},{0xB7,0,1,256,768,-130303},{0x29,0,0,0,0,-131071},{0x11,0,256,62,131134,63},{0xB7,0,2,257,1281,-129790},{0x3E,0,0,258,258,-130813},{0x1F,1,0,3,3,-131068},{0x9A,0,2,1,1025,-130046},{0x24,0,3,0,1536,-129535},{0x1F,1,0,4,4,-131067},{0x24,2,4,0,2048,-129023},{0x16,2,2,261,1285,-129786},{0x24,4,5,0,2560,-128511},{0x9A,2,3,2,1538,-129533},{0x34,0,0,2,2,-131069},{0x24,1,6,0,3072,-127999},{0xAA,2,0,2,2,-131069},{0x73,2,262,0,134144,3073},{0x73,2,263,264,134920,3849},{0x9A,1,2,2,1026,-130045},{0x29,1,0,0,0,-131071},{0x11,1,255,484,131044,-27},{0x3E,2,1,265,777,-130294},{0x4F,0,2,266,1290,-129781},{0x11,1,255,481,131041,-30},{0x3E,2,1,267,779,-130292},{0x29,2,0,0,0,-131071},{0x11,1,255,478,131038,-33},{0xB7,2,2,268,1292,-129779},{0x14,3,0,0,0,-131071},{0x9A,2,2,3,1027,-130044},{0x29,2,0,0,0,-131071},{0x11,1,255,473,131033,-38},{0x29,3,0,0,0,-131071},{0x11,1,255,471,131031,-40},{0x3E,4,3,269,1805,-129266},{0x4F,0,4,270,2318,-128753},{0x11,1,255,468,131028,-43},{0x3E,4,3,271,1807,-129264},{0x29,4,0,0,0,-131071},{0x11,1,255,465,131025,-46},{0x6D,4,0,0,0,-131071},{0x58,4,0,0,0,-131071},{0xC5,7,272,273,139537,8466},{0xB7,4,2,275,1299,-129772},{0x3E,4,4,276,2324,-128747},{0x1F,5,0,21,21,-131050},{0x1F,6,0,22,22,-131049},{0x1F,7,0,23,23,-131048},{0x9A,4,4,2,2050,-129021},{0xC5,7,274,4,140292,9221},{0xB7,4,2,280,1304,-129767},{0x3E,5,3,271,1807,-129264},{0x9A,4,2,1,1025,-130046},{0xB7,4,2,257,1281,-129790},{0x3E,4,4,258,2306,-128765},{0x1F,5,0,25,25,-131046},{0x9A,4,2,1,1025,-130046},{0x24,4,1,0,512,-130559},{0x16,4,4,282,2330,-128741},{0x9A,4,2,1,1025,-130046},{0x24,4,8,0,4096,-126975},{0x3E,5,3,271,1807,-129264},{0x9A,4,2,1,1025,-130046},{0x11,1,256,1,131073,2},{0x11,1,255,440,131000,-71},{0x11,0,255,439,130999,-72},{0x37,0,1,0,512,-130559} },
        k = { "Parent","task","wait",3.5,"/api/client/check-hwid?hwid=","UrlEncode","Url","Method","GET","StatusCode",200,"Body","pcall","active",true,"key","Text","Key verified online! Auto-unlocking...","TextColor3","Color3","fromRGB",100,220,120,"SaveKeyLocally",0.8,"Destroy" },
        p = { {
        c = { {0x24,0,0,0,0,-131071},{0x16,0,0,256,256,-130815},{0xB7,2,1,257,769,-130302},{0x71,0,3,0,1536,-129535},{0x37,0,0,0,0,-131071},{0x37,0,1,0,512,-130559} },
        k = { "JSONDecode","Body" },
        p = {  },
        u = { {0,4},{1,1} },
        np = 0,
        va = 0
    } },
        u = { {1,24},{1,2},{0,0},{0,3},{0,4},{0,5},{0,6},{1,19},{0,7} },
        np = 0,
        va = 0
    },{
        c = { {0x24,0,0,0,0,-131071},{0x29,0,0,0,0,-131071},{0x11,0,256,0,131072,1},{0x37,0,1,0,512,-130559},{0xB7,0,1,256,768,-130303},{0x16,0,0,257,257,-130814},{0x1F,2,0,2,2,-131069},{0x1F,3,0,3,3,-131068},{0x9A,0,4,2,2050,-129021},{0x16,0,0,260,260,-130811},{0x9A,0,2,2,1026,-130045},{0xBD,1,0,0,0,-131071},{0x85,0,1,261,773,-130298},{0x11,0,256,8,131080,9},{0xC5,2,256,262,131334,263},{0xB7,1,3,264,1800,-129271},{0x3E,1,1,265,777,-130294},{0x1F,2,0,10,10,-131061},{0x1F,3,0,11,11,-131060},{0x1F,4,0,11,11,-131060},{0x9A,1,4,2,2050,-129021},{0xC5,2,263,1,134657,3586},{0x37,0,1,0,512,-130559},{0x6D,1,1,0,512,-130559},{0x58,1,0,0,0,-131071},{0xC5,4,256,268,131340,269},{0xC5,2,256,269,131341,270},{0xB7,1,3,264,1800,-129271},{0x3E,1,1,265,777,-130294},{0x1F,2,0,14,14,-131057},{0x1F,3,0,14,14,-131057},{0x1F,4,0,15,15,-131056},{0x9A,1,4,2,2050,-129021},{0xC5,2,263,1,134657,3586},{0xB7,1,3,272,1808,-129263},{0x3E,1,1,273,785,-130286},{0x14,2,0,0,0,-131071},{0x9A,1,2,1,1025,-130046},{0x37,0,1,0,512,-130559} },
        k = { "Text","gsub","%s+","","upper",4,"Please enter a valid key code.","TextColor3","Color3","fromRGB",255,80,"VERIFYING...","Contacting authentication server...",200,210,"task","spawn" },
        p = { {
        c = { {0x24,0,0,0,0,-131071},{0x24,1,1,0,512,-130559},{0x9A,0,2,4,1028,-130043},{0x4F,0,0,256,256,-130815},{0x11,0,256,21,131093,22},{0xC5,2,257,258,131842,771},{0xB7,3,3,260,1796,-129275},{0x3E,3,3,261,1797,-129274},{0x1F,4,0,6,6,-131065},{0x1F,5,0,7,7,-131064},{0x1F,6,0,8,8,-131063},{0x9A,3,4,2,2050,-129021},{0xC5,2,259,3,132611,1540},{0xB7,3,3,265,1801,-129270},{0x14,4,0,0,0,-131071},{0x9A,3,2,1,1025,-130046},{0xB7,3,3,266,1802,-129269},{0x3E,3,3,267,1803,-129268},{0x1F,4,0,12,12,-131059},{0x9A,3,2,1,1025,-130046},{0x24,3,5,0,2560,-128511},{0x16,3,3,269,1805,-129266},{0x9A,3,2,1,1025,-130046},{0x24,3,6,0,3072,-127999},{0x24,4,1,0,512,-130559},{0x9A,3,2,1,1025,-130046},{0x11,0,256,101,131173,102},{0x6D,3,0,0,0,-131071},{0x58,3,7,0,3584,-127487},{0xC5,8,257,270,131854,783},{0x5C,3,1,1,513,-130558},{0x11,0,256,5,131077,6},{0x29,2,0,0,0,-131071},{0x11,0,256,2,131074,3},{0x3E,3,2,271,1295,-129776},{0x29,3,0,1,1,-131070},{0x11,0,256,0,131072,1},{0x1F,3,0,16,16,-131055},{0x1F,4,0,17,17,-131054},{0xB7,5,3,274,1810,-129261},{0x4A,6,3,0,1536,-129535},{0x9A,5,2,2,1026,-130045},{0x34,4,4,5,2053,-129018},{0xC5,2,257,4,131588,517},{0xB7,4,3,260,1796,-129275},{0x3E,4,4,261,2309,-128762},{0x1F,5,0,7,7,-131064},{0x1F,6,0,19,19,-131052},{0x1F,7,0,19,19,-131052},{0x9A,4,4,2,2050,-129021},{0xC5,2,259,4,132612,1541},{0xB7,4,9,276,4884,-126187},{0x24,5,10,0,5120,-125951},{0x16,5,5,277,2837,-128234},{0x24,7,9,0,4608,-126463},{0xB7,8,3,278,1814,-129257},{0x3E,8,8,279,4375,-126696},{0x1F,9,0,24,24,-131047},{0xB7,10,3,281,1817,-129254},{0x3E,10,10,282,5402,-125669},{0x3E,10,10,283,5403,-125668},{0x9A,8,3,2,1538,-129533},{0xAA,9,0,1,1,-131070},{0xB7,10,3,284,1820,-129251},{0x3E,10,10,279,5399,-125672},{0x3E,11,4,285,2333,-128738},{0x3E,11,11,286,5918,-125153},{0x3E,12,4,285,2333,-128738},{0x3E,12,12,287,6431,-124640},{0x61,12,12,288,6432,-124639},{0x3E,13,4,289,2337,-128734},{0x3E,13,13,286,6942,-124129},{0x3E,14,4,289,2337,-128734},{0x3E,14,14,287,7455,-123616},{0x9A,10,5,2,2562,-128509},{0x73,9,276,10,141322,10251},{0x9A,5,5,2,2562,-128509},{0x16,5,5,290,2850,-128221},{0x9A,5,2,1,1025,-130046},{0xB7,5,3,266,1802,-129269},{0x3E,5,5,267,2827,-128244},{0x1F,6,0,24,24,-131047},{0x9A,5,2,1,1025,-130046},{0x24,5,10,0,5120,-125951},{0x16,5,5,277,2837,-128234},{0x24,7,9,0,4608,-126463},{0xB7,8,3,278,1814,-129257},{0x3E,8,8,279,4375,-126696},{0x1F,9,0,24,24,-131047},{0xB7,10,3,281,1817,-129254},{0x3E,10,10,282,5402,-125669},{0x3E,10,10,283,5403,-125668},{0x9A,8,3,2,1538,-129533},{0xAA,9,0,1,1,-131070},{0xB7,10,3,284,1820,-129251},{0x3E,10,10,279,5399,-125672},{0x3E,11,4,285,2333,-128738},{0x3E,11,11,286,5918,-125153},{0x3E,12,4,285,2333,-128738},{0x3E,12,12,287,6431,-124640},{0x2D,12,12,288,6432,-124639},{0x3E,13,4,289,2337,-128734},{0x3E,13,13,286,6942,-124129},{0x3E,14,4,289,2337,-128734},{0x3E,14,14,287,7455,-123616},{0x9A,10,5,2,2562,-128509},{0x73,9,276,10,141322,10251},{0x9A,5,5,2,2562,-128509},{0x16,5,5,290,2850,-128221},{0x9A,5,2,1,1025,-130046},{0xB7,5,3,266,1802,-129269},{0x3E,5,5,267,2827,-128244},{0x1F,6,0,24,24,-131047},{0x9A,5,2,1,1025,-130046},{0x24,5,10,0,5120,-125951},{0x16,5,5,277,2837,-128234},{0x24,7,9,0,4608,-126463},{0xB7,8,3,278,1814,-129257},{0x3E,8,8,279,4375,-126696},{0x1F,9,0,24,24,-131047},{0xB7,10,3,281,1817,-129254},{0x3E,10,10,282,5402,-125669},{0x3E,10,10,283,5403,-125668},{0x9A,8,3,2,1538,-129533},{0xAA,9,0,1,1,-131070},{0x73,9,276,4,141316,10245},{0x9A,5,5,2,2562,-128509},{0x16,5,5,290,2850,-128221},{0x9A,5,2,1,1025,-130046},{0x37,0,1,0,512,-130559} },
        k = { true,"Text","Key Approved! Loading Hub...","TextColor3","Color3","fromRGB",100,255,120,"pcall","task","wait",0.6,"Destroy","VERIFY KEY","message","Invalid key. Check website.","Rejected: ","tostring",80,"Position","Create","TweenInfo","new",0.08,"Enum","EasingStyle","Linear","UDim2","X","Scale","Offset",10,"Y","Play" },
        p = { {
        c = { {0xB7,0,0,256,256,-130815},{0x29,0,0,0,0,-131071},{0x11,0,256,19,131091,20},{0xB7,0,0,257,257,-130814},{0x1F,1,0,2,2,-131069},{0x9A,0,2,2,1026,-130045},{0x29,0,0,1,1,-131070},{0x11,0,256,3,131075,4},{0xB7,0,0,259,259,-130812},{0xB7,1,0,260,260,-130811},{0x1F,2,0,2,2,-131069},{0x9A,0,3,1,1537,-129534},{0xB7,0,0,256,256,-130815},{0x1F,1,0,5,5,-131066},{0x24,2,1,0,512,-130559},{0x1F,3,0,6,6,-131065},{0x34,1,1,3,515,-130556},{0x24,2,2,0,1024,-130047},{0x9A,0,3,1,1537,-129534},{0xB7,0,0,256,256,-130815},{0x1F,1,0,7,7,-131064},{0x24,2,2,0,1024,-130047},{0x9A,0,3,1,1537,-129534},{0x37,0,1,0,512,-130559} },
        k = { "writefile","isfolder","Rayfield/Key System","pcall","makefolder","Rayfield/Key System/",".rfld","mintrazerx_key.txt" },
        p = {  },
        u = { {0,3},{0,4},{0,1} },
        np = 0,
        va = 0
    } },
        u = { {0,5},{1,0},{0,2},{0,3},{0,6},{0,7},{0,8},{0,0},{0,4},{0,9},{0,10} },
        np = 0,
        va = 0
    } },
        u = { {1,25},{1,18},{1,19},{0,0},{1,20},{0,8},{0,9},{1,2},{0,7},{1,3},{0,10} },
        np = 0,
        va = 0
    },{
        c = { {0x29,0,0,0,0,-131071},{0x11,0,256,1,131073,2},{0x24,1,0,0,0,-131071},{0x9A,1,1,1,513,-130558},{0x37,0,1,0,512,-130559} },
        k = {  },
        p = {  },
        u = { {1,26} },
        np = 1,
        va = 0
    } },
        u = { {0,0},{1,8},{1,3},{1,0},{1,4},{1,15},{1,13},{1,25},{1,16},{1,2},{1,7} },
        np = 0,
        va = 0
    },{
        c = { {0x91,0,0,0,0,-131071},{0xB7,1,0,256,256,-130815},{0x14,2,0,0,0,-131071},{0x9A,1,2,1,1025,-130046},{0x29,0,0,0,0,-131071},{0x11,0,256,30,131102,31},{0xB7,1,0,257,257,-130814},{0x1F,2,0,2,2,-131069},{0xB7,3,0,259,259,-130812},{0x4A,4,0,0,0,-131071},{0x9A,3,2,2,1026,-130045},{0x34,2,2,3,1027,-130044},{0x9A,1,2,1,1025,-130046},{0x24,1,2,0,1024,-130047},{0x4A,2,0,0,0,-131071},{0x9A,1,2,4,1028,-130043},{0x4F,0,1,260,772,-130299},{0x11,0,256,7,131079,8},{0xB7,4,0,257,257,-130814},{0x1F,5,0,5,5,-131066},{0x9A,4,2,1,1025,-130046},{0x24,4,3,0,1536,-129535},{0x4A,5,0,0,0,-131071},{0x9A,4,2,1,1025,-130046},{0x37,0,1,0,512,-130559},{0x11,0,256,10,131082,11},{0xB7,4,0,262,262,-130809},{0x1F,5,0,7,7,-131064},{0xB7,6,0,259,259,-130812},{0x4A,7,2,0,1024,-130047},{0x9A,6,2,2,1026,-130045},{0x1F,7,0,8,8,-131063},{0x34,5,5,7,2567,-128504},{0x9A,4,2,1,1025,-130046},{0xB7,4,0,256,256,-130815},{0x14,5,0,1,1,-131070},{0x9A,4,2,1,1025,-130046},{0x24,1,4,0,2048,-129023},{0x9A,1,1,1,513,-130558},{0x37,0,1,0,512,-130559} },
        k = { "pcall","print","[MintraZERX] Verifying cached license key: ","tostring",true,"[MintraZERX] License verified. Opening Hub...","warn","[MintraZERX] Cached key invalid: ",". Purging cache..." },
        p = { {
        c = { {0x1F,0,0,0,0,-131071},{0x24,1,0,0,0,-131071},{0x1F,2,0,1,1,-131070},{0x34,0,0,2,2,-131069},{0xB7,1,1,258,770,-130301},{0x29,1,0,0,0,-131071},{0x11,0,256,22,131094,23},{0xB7,1,1,258,770,-130301},{0x4A,2,0,0,0,-131071},{0x9A,1,2,2,1026,-130045},{0x29,1,0,0,0,-131071},{0x11,0,256,17,131089,18},{0xB7,1,1,259,771,-130300},{0x29,1,0,0,0,-131071},{0x11,0,256,14,131086,15},{0xB7,1,1,259,771,-130300},{0x4A,2,0,0,0,-131071},{0x9A,1,2,2,1026,-130045},{0x29,1,0,0,0,-131071},{0x11,0,256,9,131081,10},{0xBD,2,1,0,512,-130559},{0xBA,0,260,2,133122,2051},{0x11,0,256,6,131078,7},{0x16,2,1,261,773,-130298},{0x1F,4,0,6,6,-131065},{0x1F,5,0,7,7,-131064},{0x9A,2,4,2,2050,-129021},{0x16,2,2,264,1288,-129783},{0x9A,2,2,2,1026,-130045},{0x58,2,2,0,1024,-130047},{0x24,1,2,0,1024,-130047},{0x29,1,0,1,1,-131070},{0x11,0,256,25,131097,26},{0xB7,1,1,258,770,-130301},{0x29,1,0,0,0,-131071},{0x11,0,256,22,131094,23},{0xB7,1,1,258,770,-130301},{0x1F,2,0,9,9,-131062},{0x9A,1,2,2,1026,-130045},{0x29,1,0,0,0,-131071},{0x11,0,256,17,131089,18},{0xB7,1,1,259,771,-130300},{0x29,1,0,0,0,-131071},{0x11,0,256,14,131086,15},{0xB7,1,1,259,771,-130300},{0x1F,2,0,9,9,-131062},{0x9A,1,2,2,1026,-130045},{0x29,1,0,0,0,-131071},{0x11,0,256,9,131081,10},{0xBD,2,1,0,512,-130559},{0xBA,0,260,2,133122,2051},{0x11,0,256,6,131078,7},{0x16,2,1,261,773,-130298},{0x1F,4,0,6,6,-131065},{0x1F,5,0,7,7,-131064},{0x9A,2,4,2,2050,-129021},{0x16,2,2,264,1288,-129783},{0x9A,2,2,2,1026,-130045},{0x58,2,2,0,1024,-130047},{0x37,0,1,0,512,-130559} },
        k = { "Rayfield/Key System/",".rfld","isfile","readfile",4,"gsub","%s+","","upper","mintrazerx_key.txt" },
        p = {  },
        u = { {0,1},{0,0},{1,0} },
        np = 0,
        va = 0
    },{
        c = { {0x1F,0,0,0,0,-131071},{0x24,1,0,0,0,-131071},{0x1F,2,0,1,1,-131070},{0x34,0,0,2,2,-131069},{0xB7,1,1,258,770,-130301},{0x29,1,0,0,0,-131071},{0x11,0,256,8,131080,9},{0xB7,1,1,259,771,-130300},{0xB7,2,1,258,770,-130301},{0x4A,3,0,0,0,-131071},{0x9A,1,3,1,1537,-129534},{0xB7,1,1,259,771,-130300},{0xB7,2,1,258,770,-130301},{0x1F,3,0,4,4,-131067},{0x9A,1,3,1,1537,-129534},{0x11,0,256,12,131084,13},{0xB7,1,1,261,773,-130298},{0x29,1,0,0,0,-131071},{0x11,0,256,9,131081,10},{0xB7,1,1,259,771,-130300},{0xB7,2,1,261,773,-130298},{0x4A,3,0,0,0,-131071},{0x1F,4,0,6,6,-131065},{0x9A,1,4,1,2049,-129022},{0xB7,1,1,259,771,-130300},{0xB7,2,1,261,773,-130298},{0x1F,3,0,4,4,-131067},{0x1F,4,0,6,6,-131065},{0x9A,1,4,1,2049,-129022},{0x37,0,1,0,512,-130559} },
        k = { "Rayfield/Key System/",".rfld","delfile","pcall","mintrazerx_key.txt","writefile","" },
        p = {  },
        u = { {0,1},{0,0} },
        np = 0,
        va = 0
    } },
        u = { {0,0},{1,2},{1,16},{1,25},{1,26} },
        np = 0,
        va = 0
    } },
        u = { {1,0} },
        np = 0,
        va = 1
    }

    local _topEnv = getfenv and getfenv() or _G
    local _envUpval = { { _topEnv } }

    local function _ExecuteRoot(...)
        local res = _RunProto(_MZ_ROOT_PROTO, _topEnv, _envUpval, ...)
        _MZ_ROOT_PROTO = nil
        if collectgarbage then pcall(collectgarbage, "collect") end
        return res
    end

    return _ExecuteRoot(...)
end)(...)
