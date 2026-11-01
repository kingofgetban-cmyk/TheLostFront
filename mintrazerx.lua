--[[
    MINTRAZERX SECURE LOADER CONTAINER
    Engine: ChaCha20-PolyXOR-VM Bytecode Architecture
    Integrity: FNV-1a Hash Verified
    Made by valexcryzer
]]
return (function(...)
    local _0xfloor = math.floor
    local _0xbyte = string.byte
    local _0xchar = string.char
    local _0xsub = string.sub
    local _0xmod = 4294967296

    local _0xbx = (bit and bit.bxor) or (bit32 and bit32.bxor) or function(a, b)
        local r, m = 0, 1
        while a > 0 or b > 0 do
            local ra, rb = a % 2, b % 2
            if ra ~= rb then r = r + m end
            a = (a - ra) / 2
            b = (b - rb) / 2
            m = m * 2
        end
        return r
    end

    local _0xba = (bit and bit.band) or (bit32 and bit32.band) or function(a, b)
        local r, m = 0, 1
        while a > 0 and b > 0 do
            local ra, rb = a % 2, b % 2
            if ra == 1 and rb == 1 then r = r + m end
            a = (a - ra) / 2
            b = (b - rb) / 2
            m = m * 2
        end
        return r
    end

    local _0xrs = (bit and bit.rshift) or (bit32 and bit32.rshift) or function(a, n)
        return _0xfloor(a / (2 ^ n))
    end

    local _0xls = (bit and bit.lshift) or (bit32 and bit32.lshift) or function(a, n)
        return (a * (2 ^ n)) % _0xmod
    end

    local _0xrl = (bit and bit.rol) or (bit32 and bit32.rol) or function(v, n)
        return (_0xls(v, n) + _0xrs(v, 32 - n)) % _0xmod
    end

    local function _0xmul32(a, b)
        local a_hi = _0xfloor(a / 65536)
        local a_lo = a % 65536
        local b_hi = _0xfloor(b / 65536)
        local b_lo = b % 65536
        local lo = a_lo * b_lo
        local mid = (a_hi * b_lo + a_lo * b_hi) % 65536
        return (lo + mid * 65536) % _0xmod
    end

    -- Control Flow Flattening (CFF) state machine
    local _0xcff_state = 0x51
    local _0xdict = "YdSXOKyC2BIGEhF95nPsMqoLZecg6TU3pwArJb4DNfkWjml/710QzVt+iHvR8xua"
    local _0xchunks = {
        "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"
    }
    local _0xraw = table.concat(_0xchunks)
    local _0xchk = 841118459
    local _0xdec = {}
    local _0xsrc = ""

    local _0xmap = {}
    for i = 1, #_0xdict do
        _0xmap[_0xbyte(_0xdict, i)] = i - 1
    end

    local _0xkey = { 0x5a1f8b2c, 0x3d7e9f01, 0x84b2c1e0, 0x93f4a5b6, 0xc7d8e9fa, 0x12345678, 0xaabbccdd, 0xeeff0011 }
    local _0xnon = { 0x7890abcd, 0xef123456, 0x9a8b7c6d }

    local function _0xqr(st, a, b, c, d)
        st[a] = (st[a] + st[b]) % _0xmod
        st[d] = _0xrl(_0xbx(st[d], st[a]), 16)
        st[c] = (st[c] + st[d]) % _0xmod
        st[b] = _0xrl(_0xbx(st[b], st[c]), 12)
        st[a] = (st[a] + st[b]) % _0xmod
        st[d] = _0xrl(_0xbx(st[d], st[a]), 8)
        st[c] = (st[c] + st[d]) % _0xmod
        st[b] = _0xrl(_0xbx(st[b], st[c]), 7)
    end

    local function _0xblock(k, cnt, non)
        local st = {
            0x61707865, 0x3320646e, 0x79622d32, 0x6b206574,
            k[1], k[2], k[3], k[4], k[5], k[6], k[7], k[8],
            cnt, non[1], non[2], non[3]
        }
        local wk = {}
        for i = 1, 16 do wk[i] = st[i] end
        for i = 1, 10 do
            _0xqr(wk, 1, 5, 9, 13)
            _0xqr(wk, 2, 6, 10, 14)
            _0xqr(wk, 3, 7, 11, 15)
            _0xqr(wk, 4, 8, 12, 16)
            _0xqr(wk, 1, 6, 11, 16)
            _0xqr(wk, 2, 7, 12, 13)
            _0xqr(wk, 3, 8, 9, 14)
            _0xqr(wk, 4, 5, 10, 15)
        end
        local out = {}
        for i = 1, 16 do
            local val = (wk[i] + st[i]) % _0xmod
            out[(i - 1) * 4 + 1] = _0xba(val, 255)
            out[(i - 1) * 4 + 2] = _0xba(_0xrs(val, 8), 255)
            out[(i - 1) * 4 + 3] = _0xba(_0xrs(val, 16), 255)
            out[(i - 1) * 4 + 4] = _0xba(_0xrs(val, 24), 255)
        end
        return out
    end

    while _0xcff_state ~= 0x00 do
        if _0xcff_state == 0x51 then
            -- Integrity Check: 32-bit FNV-1a Hash Verification
            local h = 2166136261
            for i = 1, #_0xraw do
                h = _0xbx(h, _0xbyte(_0xraw, i))
                h = _0xmul32(h, 16777619)
            end
            if h ~= _0xchk then
                return nil
            end
            _0xcff_state = 0x62

        elseif _0xcff_state == 0x62 then
            -- Custom Alphabet Base64 Poly-decoding
            local clean = _0xraw:gsub("=", "")
            local len = #clean
            local i = 1
            while i <= len do
                local c1 = _0xmap[_0xbyte(clean, i)] or 0
                local c2 = _0xmap[_0xbyte(clean, i + 1)] or 0
                local c3 = _0xmap[_0xbyte(clean, i + 2)] or 0
                local c4 = _0xmap[_0xbyte(clean, i + 3)] or 0

                local b1 = _0xba(_0xls(c1, 2) + _0xrs(c2, 4), 255)
                table.insert(_0xdec, b1)

                if i + 2 <= len then
                    local b2 = _0xba(_0xls(c2, 4) + _0xrs(c3, 2), 255)
                    table.insert(_0xdec, b2)
                end
                if i + 3 <= len then
                    local b3 = _0xba(_0xls(c3, 6) + c4, 255)
                    table.insert(_0xdec, b3)
                end
                i = i + 4
            end
            _0xcff_state = 0x73

        elseif _0xcff_state == 0x73 then
            -- ChaCha20 + Polynomial Rolling XOR Keystream Unpacking
            local cnt = 1
            local ks = _0xblock(_0xkey, cnt, _0xnon)
            local ks_idx = 1
            local rolling = 0x6C
            local out_chars = {}

            for idx = 1, #_0xdec do
                if ks_idx > 64 then
                    cnt = cnt + 1
                    ks = _0xblock(_0xkey, cnt, _0xnon)
                    ks_idx = 1
                end
                local enc_b = _0xdec[idx]
                local k_b = ks[ks_idx]
                ks_idx = ks_idx + 1

                local orig_b = _0xbx(_0xbx(enc_b, k_b), rolling)
                table.insert(out_chars, _0xchar(orig_b))
                rolling = (rolling * 37 + enc_b) % 256
            end
            _0xsrc = table.concat(out_chars)
            _0xcff_state = 0x84

        elseif _0xcff_state == 0x84 then
            -- Protected Virtual Machine Execution Layer
            local fn, err = loadstring(_0xsrc)
            if not fn then
                error("[MINTRAZERX_SECURE_VM]: " .. tostring(err))
            end

            -- Anti-Dump Memory Sanitation
            _0xdec = nil
            _0xsrc = nil
            _0xraw = nil
            _0xchunks = nil
            if collectgarbage then
                pcall(collectgarbage, "collect")
            end

            _0xcff_state = 0x00
            return fn(...)
        else
            _0xcff_state = 0x00
        end
    end
end)(...)
