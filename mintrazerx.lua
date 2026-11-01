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
    local _0xdict = "Xpwt0JVGEoSZUa+MQWsTYuHRIO2nbm1KrfPvkiqdlj96DB5exFLhcNgy7A/C483z"
    local _0xchunks = {
        "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"
    }
    local _0xraw = table.concat(_0xchunks)
    local _0xchk = 3375892558
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
