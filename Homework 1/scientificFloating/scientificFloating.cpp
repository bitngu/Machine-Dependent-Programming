#include <iostream>
#include <vector>



std::string removeTrailingZeros(std::string &mantissa){
    return mantissa.erase (mantissa.find_last_not_of('0') + 1, std::string::npos );
}

void scientificFloat(float &num){
    //float_int is the base 10 number. So now I need to convert it to binary

    unsigned int float_int = *((unsigned int*)&num);
    //Since my number is in base 10 already, I can just divide the quotient
    std::vector<int> remainder{};
    while(float_int !=0){
        remainder.emplace_back(float_int % 2);
        float_int/=2;
    }


    //So we know the most significant is the sign field
    //The next 8 values are the exponent field
    //and the next 23 is the mantissa field

    int e{0b0};
    std::string mantissa{};
    int sign = 1;
    for (int i = remainder.size() - 1 ; i >= 0; --i) {
        if (i == 31){
            if (remainder[i] & 1)
                sign = -1;
        }
        else if (i>22)
            e |= remainder[i] << (i-23);
        else
            mantissa += std::to_string(remainder[i]);
    }
    e -= 127;
    std::cout<< sign << "." << removeTrailingZeros(mantissa) << "E"<<e << std::endl;


}


int main() {
    float num{};
    std::cout << "Please enter a float: ";
    std::cin >> num;
    if (num == 0)
        std::cout << "0E0"<<std::endl;
    else
        scientificFloat(num);
    return 0;
}