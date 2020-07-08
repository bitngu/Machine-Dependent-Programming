#include <stdio.h>
#include <stdint.h>
#include <math.h>

unsigned int numBits(unsigned int value){
    //den is just a copy

    //shift each bit until the value becomes 0
    unsigned int numBits = 0;
    while (value != 0){
        value >>= 1;
        ++numBits;
    }
    //another approach is do take int(log2(den))+1
    return numBits;

}



int main(int argc, char* argv []) {
    //Recall argc is the number of arguments that are passed in
    //and argv[0] is the name of the program
    //and argv is the array of character pointer pointing to all arguments
    //
    uint32_t num;
    uint32_t den;
    sscanf(argv[1], "%u", &num);
    sscanf(argv[2], "%u", &den);
    unsigned int numBitsDivisor =  numBits(den);
    unsigned int numBitsDividend = numBits(num);
    uint32_t ans = 0;
    uint32_t temp;

    printf("%u / %u = ", num, den);

    for (unsigned int i = numBitsDivisor; i <= numBitsDividend  ; ++i) {
        if (den > num >> (numBitsDividend-i)){
            //set bit to 0
            ans = ans << 1;
        }else{
            //set 1
            ans = ans << 1;
            ans |= 1;

            //subtract
            temp = (num >> (numBitsDividend-i)) - den;
            temp  = temp << (numBitsDividend-i);
            temp |= num & (((uint32_t) pow(2,numBitsDividend-i))-1); // num & 0b1111....
            num = temp;


        }

    }

    printf("%u R %u", ans, num);


    return 0;
}


