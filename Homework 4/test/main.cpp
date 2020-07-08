#include <iostream>

int main() {

    int a = -113;

    //How to unpack float?
    //shift 31 bit to the right to get the sign bit
    //shift 23 bit to the right to get exp field

    //shift to get sign field
    auto sign = (a>>(31) &1);

    //shift to get exponent field
   auto exp = (a >> (23)& ((1<<8)-1));

   //shift to get mantissa field
   auto mantissa = (a & ((1<<22)-1));


   //if this is correct then packing them should give me -113
   int pack = 1;
   pack = pack | sign;
   pack = (pack << (8)| exp);
   pack = (pack << (22)| mantissa);
   std::cout << pack;








    return 0;
}