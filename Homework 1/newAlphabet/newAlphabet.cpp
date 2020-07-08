#include <iostream>
#include <map>
std::map<char,unsigned int> newAlphabet(){
    std::map<char, unsigned int> alphabet{};
    for (int i = 0; i < 26; ++i) {
        unsigned int bin{0};
        bin |= 1 << i;
        alphabet.insert(std::make_pair('a'+i, bin));
        bin |= 1 << 26;
        alphabet.insert(std::make_pair('A'+i, bin));
    }
    return alphabet;
}


char findChar(const std::map<char, unsigned int>& alphabet, unsigned int& num){
    for (auto it = alphabet.begin(); it != alphabet.end(); ++it) {
        if (it->second == num)
            return it->first;
    }
    return '.';//in case of error

}

//argc is the number of arguments in the command line
//argv is the input itself
int main(int argc, char* argv[]) {
    std::map<char, unsigned int> myAlphabet = newAlphabet();
    std::string wordRepresentation;
    unsigned int num;
//Note argv[0] represent the file location;
    for (int i = 1; i < argc ; ++i) {
        sscanf(argv[i], "%u", &num);
        wordRepresentation+= findChar(myAlphabet, num);
    }
    std::cout << "You entered the word: " << wordRepresentation << std::endl;
}