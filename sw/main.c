int main() {
    volatile int a = 15;
    volatile int b = 4;
    volatile int add_res;
    volatile int sub_res;
    volatile int mul_res;

    add_res = a + b;       // Should be 19
    sub_res = a - b;       // Should be 11
    mul_res = a * b;       // Should be 60

    return 0;
}