int main() {
    volatile int sum = 0;
    
    // The compiler will use JAL to skip to the condition, and branches to loop
    for(volatile int i = 1; i <= 10; i++) {
        sum = sum + i;
    }
    
    // 1 + 2 + 3 + ... + 10 = 55
    // The RISC-V ABI places this return value in x10 (a0)
    return sum; 
}