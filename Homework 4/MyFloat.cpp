#include "MyFloat.h"

MyFloat::MyFloat(){
  sign = 0;
  exponent = 0;
  mantissa = 0;
}

MyFloat::MyFloat(float f){
  unpackFloat(f);
}

MyFloat::MyFloat(const MyFloat & rhs){
	sign = rhs.sign;
	exponent = rhs.exponent;
	mantissa = rhs.mantissa;
}

ostream& operator<<(std::ostream &strm, const MyFloat &f){
	//this function is complete. No need to modify it.
	strm << f.packFloat();
	return strm;
}


MyFloat MyFloat::operator+(const MyFloat& rhs) const{



	return *this; //you don't have to return *this. it's just here right now so it will compile
}

MyFloat MyFloat::operator-(const MyFloat& rhs) const{
	
	return *this; //you don't have to return *this. it's just here right now so it will compile
}

bool MyFloat::operator==(const float rhs) const{
	return false; //this is just a stub so your code will compile
}



void MyFloat::unpackFloat(float f) {
	//this function must be written in inline assembly
	//extracts the fields of f into sign, exponent, and mantissa
	/*
	 *
	shift to get sign field
    auto sign = (a>>(31) &1);

    shift to get exponent field
    auto exp = (a >> (23)& ((1<<8)-1));

   shift to get mantissa field
   auto mantissa = (a & ((1<<22)-1));
	 */
    __asm__(
    //assembly

    //sign field
    "movl %%edx, %%edi;" //because when i shift, the float will change
    "shr $31,  %%edx;" // a>>31
    "movl %%edx, %%eax;" // eax = a >> 31
    "movl %%edi, %%edx;" // edx = back to my original float

    //exponent field
    "shr $23, %%edx;" // a >> 23
    "movl $1, %%ebx;" //ebx = 1
    "shl $8, %%ebx;" // ebx = 1 << 8
    "subl $1, %%ebx;" //ebx = (1 << 8)-1
    "and %%edx, %%ebx;" // ebx = (a>>(23)) & ((1<<8)-1));
    "movl %%edi, %%edx;"

    //mantissa field
    "movl $1, %%ecx;" //ecx = 1
    "shl $22, %%ecx;"// ecx = 1 << 22
    "subl $1, %%ecx;" // ecx = (1 << 22)-1
    "and %%edi, %%ecx" // ecx =  (a & ((1<<22)-1))
    :
    //output
    "=a" (sign), "=b" (exponent), "=c" (mantissa):
    //input
    "d" (f):
    //clobber
    "cc", "%edi"
    );


}//unpackFloat

float MyFloat::packFloat() const{
	//this function must be written in inline assembly
  //returns the floating point number represented by this
  //Remeber that this consts means i can't chagen the value of output

  /*
   int pack = 1;
   pack = pack | sign;
   pack = (pack << (8)| exp);
   pack = (pack << (22)| mantissa);
   */
  float f = 0;
    __asm__(
    //assembly
    "or %%ebx, %%eax;" // pack || sign
    "shl $8, %%eax;" // pack << 8
    "or %%ecx, %%eax;" //(pack <<(8))|exponent
    "shl $22, %%eax;"
    "or %%edx, %%eax"
    :
    //output
    :
    //input
    "a" (f), "b" (sign), "c" (exponent), "d" (mantissa) :
    //clobber
    "cc"
    );

  return f;
}
//packFloat
//



int clobberAdd(int a, int b){
    int result;
    __asm__(
    "movl $0, %[result];"
    "movl %[b], %[result];" //note that registers have double % signs in front of them
    "addl %[a], %[result]"
    : //and that if you are not the last line you have to end with a ;
    [result] "=&r" (result) : //the = sign means that result will be overwritten with whatever value is
    //in the associated register. In this case it is a
    [b] "r" (b), [a] "r" (a) : //b will be stored in EBX and a in ECX
    "cc" //the condition codes will be changed
    );
    return result;

}

