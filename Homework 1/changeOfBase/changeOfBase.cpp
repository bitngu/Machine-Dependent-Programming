#include <iostream>
#include <string>
#include <vector>
#include <cmath>


std::vector<int> changeValue(const std::string& value){
    std::vector<int> new_value{};
    for (const auto &val : value) {
        if(isalpha(val)){
            new_value.emplace_back(val-55);
        }else{
            new_value.emplace_back(val-'0');
        }
    }

    return new_value;

}

void changeOfBase(int oldBase,  const std::string& value, int newBase) {

    //Convert the value to integer base
    auto new_value = changeValue(value);
    int base_10_value{0};

    //Convert new value to base 10;
    for (size_t i = 0, exp = new_value.size() - 1; i < new_value.size(); ++i, --exp) {
        base_10_value += new_value[i] * pow(double(oldBase), double(exp));

    }

    //Divide the base 10 value by the new base
    std::vector<int> remainder{};
    while(base_10_value !=0){
        remainder.emplace_back(base_10_value %newBase);
        base_10_value/=newBase;
    }


    //converting values 10-35 to ascii keys and printing result
    std::cout << value << " base " << oldBase << " is ";
    for (auto wrapIter = remainder.rbegin(); wrapIter != remainder.rend(); ++wrapIter){
        if (*wrapIter >= 10){
            std::cout << char('A' + *wrapIter - 10);
        }else{
            std::cout<< *wrapIter;
        }
    }
    std::cout << " base "<< newBase <<std::endl;

}

int main() {
    int oldBase{};
    int newBase{};
    std::string val;
    std::cout << "Please enter the number's base: ";
    std::cin >> oldBase;
    std::cout << "Please enter the number: ";
    std::cin >> val;
    std::cout << "Please enter the new base: ";
    std::cin >> newBase;
    changeOfBase(oldBase,val, newBase);


    return 0;
}