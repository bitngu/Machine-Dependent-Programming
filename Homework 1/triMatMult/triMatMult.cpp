#include <iostream>
#include <fstream>
#include <vector>


int conversion(int i, int j, int dim){
    return i * dim + j - (i * (i + 1))/2;
}

int main(int argc, char** argv) {
    int dim;
    std::ifstream file1(argv[1]);
    std::ifstream file2(argv[2]);

    file1 >> dim;
    file2 >> dim;
    int size = dim * (dim + 1) / 2;
    int mat1[size];
    int mat2[size];
    int mat3[size];

    //read in Matrix A
    for(int i = 0; i < size; ++i){
        int tmp;
        file1 >> tmp;
        mat1[i] = tmp;
    }

    //read in Matrix B
    for(int i = 0; i < size; ++i){
        int tmp;
        file2 >> tmp;
        mat2[i] = tmp;
    }

    //initialize Matrix result as 0
    for(int i = 0; i < size; ++i){
        mat3[i] = 0;
    }

    for(int i = 0; i < dim; ++i){
        for(int j = 0; j < dim; ++j){
            if(i > j){
                continue;
            }else if(i == j){
                int index = conversion(i, j, dim);
                mat3[index] = mat1[index] * mat2[index];
            }else{
                for(int k = 0; k < dim; ++k){
                    if(i > k || k > j){ continue;}
                    mat3[conversion(i, j, dim)] += mat1[conversion(i, k, dim)] * mat2[conversion(k, j, dim)];
                }
            }
        }
    }

    for(int i = 0; i < size; ++i){
        std::cout << mat3[i] << " ";
    }

    return 0;
}

