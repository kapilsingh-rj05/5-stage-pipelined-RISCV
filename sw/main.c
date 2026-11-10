int main() {
    volatile int counter = 5;
    volatile int sum = 0;

    // do-while forces a pure backwards branch (BNE or BGE) at the bottom
    do {
        sum = sum + counter; // 5 + 4 + 3 + 2 + 1 = 15
        counter = counter - 1;
    } while (counter != 0);

    // Should return 15 in register x10 (a0)
    return sum; 
}