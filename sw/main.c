#define N 8
#define Q_SHIFT 15

// Define your custom opcode here (replace 0x0B with your actual opcode)
#define CUSTOM_OPCODE 0x0B 

// Custom instruction macros using .insn R-type directives
// Format: .insn r opcode, func3, func7, rd, rs1, rs2

// CLRACC: Assuming rd=x0, rs1=x0, rs2=x0, func3=0x0, func7=0x00
#define CLRACC() \
    __asm__ volatile(".insn r %0, 0x0, 0x00, x0, x0, x0" : : "i"(CUSTOM_OPCODE))

// MAC rs1, rs2: Assuming rd=x0, func3=0x0, func7=0x01
#define MAC(rs1, rs2) \
    __asm__ volatile(".insn r %0, 0x0, 0x01, x0, %1, %2" \
                     : /* no outputs */ \
                     : "i"(CUSTOM_OPCODE), "r"(rs1), "r"(rs2))

// MVACC rd: Assuming rs1=x0, rs2=x0, func3=0x0, func7=0x02
#define MVACC(rd) \
    __asm__ volatile(".insn r %1, 0x0, 0x02, %0, x0, x0" \
                     : "=r"(rd) \
                     : "i"(CUSTOM_OPCODE))

// Precomputed Q15 Twiddle Factors for N=8
const int W_re[4] = {32767, 23170, 0, -23170};
const int W_im[4] = {0, -23170, -32767, -23170};

// Bit-reversal indices for N=8
const int bit_rev[8] = {0, 4, 2, 6, 1, 5, 3, 7};

// Global arrays to map to data memory
int data_re[N] = {300, 0, 0, 0, 0, 0, 0, 0}; // Impulse input yielding DC = 300
int data_im[N] = {0, 0, 0, 0, 0, 0, 0, 0};

void bit_reversal(int *re, int *im) {
    int temp_re[N], temp_im[N];
    for (int i = 0; i < N; i++) {
        temp_re[i] = re[bit_rev[i]];
        temp_im[i] = im[bit_rev[i]];
    }
    for (int i = 0; i < N; i++) {
        re[i] = temp_re[i];
        im[i] = temp_im[i];
    }
}

void radix2_fft(int *re, int *im) {
    bit_reversal(re, im);

    for (int step = 1; step < N; step <<= 1) {
        int jump = step << 1;
        int twiddle_step = (N / 2) / step;

        for (int group = 0; group < step; group++) {
            int w_r = W_re[group * twiddle_step];
            int w_i = W_im[group * twiddle_step];

            for (int pair = group; pair < N; pair += jump) {
                int match = pair + step;
                
                int t_re, t_im;
                int neg_im_match = -im[match];
                
                // Real part of butterfly: (re*w_r) - (im*w_i)
                CLRACC();
                MAC(re[match], w_r);
                MAC(neg_im_match, w_i);
                MVACC(t_re);
                t_re >>= Q_SHIFT;

                // Imaginary part of butterfly: (re*w_i) + (im*w_r)
                CLRACC();
                MAC(re[match], w_i);
                MAC(im[match], w_r);
                MVACC(t_im);
                t_im >>= Q_SHIFT;

                // Update butterfly pairs
                re[match] = re[pair] - t_re;
                im[match] = im[pair] - t_im;
                re[pair]  = re[pair] + t_re;
                im[pair]  = im[pair] + t_im;
            }
        }
    }
}

int main() {
    // Execute FFT
    radix2_fft(data_re, data_im);

    // Extract Bin 0 (DC component)
    int bin0_result = data_re[0];

    // Force the result into register x10 (a0) for the testbench to verify
    __asm__ volatile("mv a0, %0" : : "r"(bin0_result));

    // Infinite loop to halt execution
    while(1);
    
    return 0;
}