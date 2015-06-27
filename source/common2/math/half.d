module math.half;

import std.string: format;

/* Code derived from MIT-licensed code: http://code.google.com/p/nvidia-texture-tools/source/browse/trunk/src/nvmath/Half.cpp */


struct half
{
    private
    {
        ushort value;

        union float_uint {
            uint ui32;
            float f32;
        }

        static half createFromValue(ushort v)
        {
            half res = void;
            res.value = v;
            return res;
        }
    }

    public
    {
        static half opCall()
        {
            half res = void;
            res.value = 0;
            return res;
        }

        static half opCall(float x)
        {
            half res = void;
            res.value = floatToHalf(x);
            return res;
        }

        float opCast()
        {
            return halfToFloat(value);
        }

        float toFloat()
        {
            return halfToFloat(value);
        }


        half opAdd(half x)
        {
            return half(toFloat() + x.toFloat());
        }

        half opSub(half x)
        {
            return half(toFloat() - x.toFloat());
        }

        half opMul(half x)
        {
            return half(toFloat() * x.toFloat());
        }

        half opDiv(half x)
        {
            return half(toFloat() / x.toFloat());
        }

        float opAdd(float x)
        {
            return toFloat() + x;
        }

        float opSub(float x)
        {
            return toFloat() - x;
        }

        float opSub_r(float x)
        {
            return x - toFloat();
        }

        float opMul(float x)
        {
            return toFloat() * x;
        }

        float opDiv(float x)
        {
            return toFloat() / x;
        }

        void opAddAssign(half x)
        {
            value = floatToHalf(toFloat() + x.toFloat());
        }

        void opSubAssign(half x)
        {
            value = floatToHalf(toFloat() - x.toFloat());
        }

        void opMulAssign(half x)
        {
            value = floatToHalf(toFloat() * x.toFloat());
        }

        void opDivAssign(half x)
        {
            value = floatToHalf(toFloat() / x.toFloat());
        }

        void opAddAssign(float x)
        {
            value = floatToHalf(toFloat() + x);
        }

        void opSubAssign(float x)
        {
            value = floatToHalf(toFloat() - x);
        }

        void opMulAssign(float x)
        {
            value = floatToHalf(toFloat() * x);
        }

        void opDivAssign(float x)
        {
            value = floatToHalf(toFloat() / x);
        }

        half opNeg()
        {
            return createFromValue(cast(ushort)(0x8000 ^ value));
        }

        string toString()
        {
            return format("%s, %s", toFloat(), value);
        }
    }

    static private
    {
        // Select on Sign bit
        uint _unsigned_sels(uint test, uint a, uint b)
        {
            uint mask = (cast(int)test) >> 31; // sign-extend
            uint sel_a  = a & mask;
            uint sel_b  = b & (~mask);
            uint result =  sel_a | sel_b;
            return result;
        }

        // Count Leading Zeros
        uint _unsigned_cntlz(uint x)
        {
            uint x0  = x >> 1;
            uint x1  = x | x0;
            uint x2  = x1 >> 2;
            uint x3  = x1 | x2;
            uint x4  = x3 >> 4;
            uint x5  = x3 | x4;
            uint x6  = x5 >> 8;
            uint x7  = x5 | x6;
            uint x8  = x7 >> 16;
            uint x9  = x7 | x8;
            uint xA  = ~x9;
            uint xB  = xA >> 1;
            uint xC  = xB & 0x55555555u;
            uint xD  = xA - xC;
            uint xE  = xD & 0x33333333u;
            uint xF  = xD >> 2;
            uint x10 = xF & 0x33333333u;
            uint x11 = xE + x10;
            uint x12 = x11 >> 4;
            uint x13 = x11 + x12;
            uint x14 = x13 & 0x0f0f0f0fu;
            uint x15 = x14 >> 8;
            uint x16 = x14 + x15;
            uint x17 = x16 >> 16;
            uint x18 = x16 + x17;
            uint x19 = x18 & 0x0000003fu;
            return x19;
        }

        float halfToFloat(ushort h)
        {
            uint h_e_mask              = 0x00007c00u;
            uint h_m_mask              = 0x000003ffu;
            uint h_s_mask              = 0x00008000u;
            uint h_f_s_pos_offset      = 0x00000010u;
            uint h_f_e_pos_offset      = 0x0000000du;
            uint h_f_bias_offset       = 0x0001c000u;
            uint f_e_mask              = 0x7f800000u;
            uint f_m_mask              = 0x007fffffu;
            uint h_f_e_denorm_bias     = 0x0000007eu;
            uint h_f_m_denorm_sa_bias  = 0x00000008u;
            uint f_e_pos               = 0x00000017u;
            uint h_e_mask_minus_one    = 0x00007bffu;
            uint h_e                   = h & h_e_mask;
            uint h_m                   = h & h_m_mask;
            uint h_s                   = h & h_s_mask;
            uint h_e_f_bias            = h_e + h_f_bias_offset;
            uint h_m_nlz               = _unsigned_cntlz(h_m);
            uint f_s                   = h_s << h_f_s_pos_offset;
            uint f_e                   = h_e_f_bias << h_f_e_pos_offset;
            uint f_m                   = h_m << h_f_e_pos_offset;
            uint f_em                  = f_e | f_m;
            uint h_f_m_sa              = h_m_nlz - h_f_m_denorm_sa_bias;
            uint f_e_denorm_unpacked   = h_f_e_denorm_bias - h_f_m_sa;
            uint h_f_m                 = h_m << h_f_m_sa;
            uint f_m_denorm            = h_f_m & f_m_mask;
            uint f_e_denorm            = f_e_denorm_unpacked << f_e_pos;
            uint f_em_denorm           = f_e_denorm | f_m_denorm;
            uint f_em_nan              = f_e_mask | f_m;
            uint is_e_eqz_msb          = h_e - 1;
            uint is_m_nez_msb          = -h_m;
            uint is_e_flagged_msb      = h_e_mask_minus_one - h_e;
            uint is_zero_msb           = is_e_eqz_msb & (~is_m_nez_msb);
            uint is_inf_msb            = is_e_flagged_msb & (~is_m_nez_msb);
            uint is_denorm_msb         = is_m_nez_msb & is_e_eqz_msb;
            uint is_nan_msb            = is_e_flagged_msb & is_m_nez_msb;
            uint is_zero               = (cast(int)is_zero_msb) >> 31; // sign-extend
            uint f_zero_result         = f_em & (~is_zero);
            uint f_denorm_result       = _unsigned_sels(is_denorm_msb, f_em_denorm, f_zero_result);
            uint f_inf_result          = _unsigned_sels(is_inf_msb, f_e_mask, f_denorm_result);
            uint f_nan_result          = _unsigned_sels(is_nan_msb, f_em_nan, f_inf_result);
            uint f_result              = f_s | f_nan_result;

            float_uint u;
            u.ui32 = f_result;
            return u.f32;
        }

        private ushort floatToHalf(float x)
        {
            float_uint u;

            u.f32 = x;
            uint f = u.ui32;

            uint one                        = 0x00000001u;
            uint f_e_mask                   = 0x7f800000u;
            uint f_m_mask                   = 0x007fffffu;
            uint f_s_mask                   = 0x80000000u;
            uint h_e_mask                   = 0x00007c00u;
            uint f_e_pos                    = 0x00000017u;
            uint f_m_round_bit              = 0x00001000u;
            uint h_nan_em_min               = 0x00007c01u;
            uint f_h_s_pos_offset           = 0x00000010u;
            uint f_m_hidden_bit             = 0x00800000u;
            uint f_h_m_pos_offset           = 0x0000000du;
            uint f_h_bias_offset            = 0x38000000u;
            uint f_m_snan_mask              = 0x003fffffu;
            uint h_snan_mask                = 0x00007e00u;
            uint f_e                        = f & f_e_mask;
            uint f_m                        = f & f_m_mask;
            uint f_s                        = f & f_s_mask;
            uint f_e_h_bias                 = f_e - f_h_bias_offset;
            uint f_e_h_bias_amount          = f_e_h_bias >> cast(int)f_e_pos;
            uint f_m_round_mask             = f_m & f_m_round_bit;
            uint f_m_round_offset           = f_m_round_mask << 1;
            uint f_m_rounded                = f_m + f_m_round_offset;
            uint f_m_rounded_overflow       = f_m_rounded & f_m_hidden_bit;
            uint f_m_denorm_sa              = one - f_e_h_bias_amount;
            uint f_m_with_hidden            = f_m_rounded | f_m_hidden_bit;
            uint f_m_denorm                 = f_m_with_hidden >> cast(int)f_m_denorm_sa;
            uint f_em_norm_packed           = f_e_h_bias | f_m_rounded;
            uint f_e_overflow               = f_e_h_bias + f_m_hidden_bit;
            uint h_s                        = f_s >> cast(int)f_h_s_pos_offset;
            uint h_m_nan                    = f_m >> cast(int)f_h_m_pos_offset;
            uint h_m_denorm                 = f_m_denorm >> cast(int)f_h_m_pos_offset;
            uint h_em_norm                  = f_em_norm_packed >> cast(int)f_h_m_pos_offset;
            uint h_em_overflow              = f_e_overflow >> cast(int)f_h_m_pos_offset;
            uint is_e_eqz_msb               = f_e - 1;
            uint is_m_nez_msb               = -f_m;
            uint is_h_m_nan_nez_msb         = -h_m_nan;
            uint is_e_nflagged_msb          = f_e - f_e_mask;
            uint is_ninf_msb                = is_e_nflagged_msb | is_m_nez_msb;
            uint is_underflow_msb           = is_e_eqz_msb - f_h_bias_offset;
            uint is_nan_nunderflow_msb      = is_h_m_nan_nez_msb | is_e_nflagged_msb;
            uint is_m_snan_msb              = f_m_snan_mask - f_m;
            uint is_snan_msb                = is_m_snan_msb & (~is_e_nflagged_msb);
            uint is_overflow_msb            = -f_m_rounded_overflow;
            uint h_nan_underflow_result     = _unsigned_sels(is_nan_nunderflow_msb, h_em_norm, h_nan_em_min);
            uint h_inf_result               = _unsigned_sels(is_ninf_msb, h_nan_underflow_result, h_e_mask);
            uint h_underflow_result         = _unsigned_sels(is_underflow_msb, h_m_denorm, h_inf_result);
            uint h_overflow_result          = _unsigned_sels(is_overflow_msb, h_em_overflow, h_underflow_result);
            uint h_em_result                = _unsigned_sels(is_snan_msb, h_snan_mask, h_overflow_result);
            uint h_result                   = h_em_result | h_s;
            return cast(ushort)h_result;
        }
    }
}

static assert(half.sizeof == 2);

