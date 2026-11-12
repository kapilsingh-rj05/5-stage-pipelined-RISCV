import math

N = 8
print(f"// Twiddle factors for N={N} in Q15 format")
w_real = []
w_imag = []

for k in range(N // 2):
    angle = -2 * math.pi * k / N
    # Multiply by 32767 to convert to Q15 integer
    w_real.append(int(math.cos(angle) * 32767))
    w_imag.append(int(math.sin(angle) * 32767))

print(f"int W_real[{N//2}] = {{{', '.join(map(str, w_real))}}};")
print(f"int W_imag[{N//2}] = {{{', '.join(map(str, w_imag))}}};")