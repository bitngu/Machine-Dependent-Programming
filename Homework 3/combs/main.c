#include <stdio.h>
#include <stdlib.h>
#include "combs.h"

void print_mat(int** mat, int num_rows, int num_cols);
void free_mat(int** mat, int num_rows, int num_cols);

int max(int a, int b){
    return a > b ? a : b;
}

int min(int a, int b){
    return a < b ? a : b;
}

void find_combs(int* items, int k , int len, int** arr) {
    if (k == 0) {
        return;
    } else if (k > len) {
        return;
    } else {
        for (int i = 0; i < len; ++i) {
            find_combs(items + i, k, len - 1, arr);
        }
    }
}


int** get_combs(int* items, int k, int len) {
    //I think this function just stores the array
    int rows = num_combs(len,k);
    int** comb_array = (int**)malloc(rows * sizeof(int*));

    for (int i = 0; i < rows ; ++i) {
        comb_array[i] = (int*)malloc(k * sizeof(int));
    }

    find_combs(items, k, len, comb_array);




    return comb_array;

}





int num_combs(int n, int k){
    int combs = 1;
    int i;

    for(i = n; i > max(k, n-k); i--){
        combs *= i;
    }

    for(i = 2; i <= min(k, n - k); i++){
        combs /= i;
    }

    return combs;

}

void print_mat(int** mat, int num_rows, int num_cols){
    int i,j;

    for(i = 0; i < num_rows; i++){
        for( j = 0; j < num_cols; j++){
            printf("%d ", mat[i][j]);
        }
        printf("\n");
    }
}

void free_mat(int** mat, int num_rows, int num_cols){
    int i;

    for(i = 0; i < num_rows; i++){
        free(mat[i]);
    }
    free(mat);
}


int main(){
    int num_items;
    int* items;
    int i,k;
    int** combs;

    printf("How many items do you have: ");
    scanf("%d", &num_items);

    items = (int*) malloc(num_items * sizeof(int));

    printf("Enter your items: ");
    for(i = 0; i < num_items; i++){
        scanf("%d", &items[i]);
    }

    printf("Enter k: ");
    scanf("%d", &k);




    combs = get_combs(items, k, num_items);
    print_mat(combs,num_combs(num_items, k) ,k);
    free(items);
    free_mat(combs,num_combs(num_items, k), k);

    return 0;
}
