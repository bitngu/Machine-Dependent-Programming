#include <stdio.h>
#include <stdlib.h>
#include <string.h>

int editDist(char* word1, char* word2);
int min(int a, int b);
void swap(int** a, int** b);

int min(int a, int b){
  return a < b ? a:b;
}
/*
 *int min(int a, int b){
  if (a<b){
  return a
} else{
 return b
 *
 *
 */


//Not sure what the swap function is swapping for
void swap(int** a, int** b){
  int* temp = *a;
  *a = *b;
  *b = temp;
}

/*
 * int strlen(char* str){
 *
 * for (len = 0; str[len] != '\0'; ++len);
 *
 * return len;
 */

//Goal is check how many edits to make word1 to word2
//For example, word1 = cat and word2 = dog
//c -> d, a -> o, t -> g so 3 edits
//Another example, word1 = soda, word2 = sodium
//s, o,d stay the same
//a -> i, and then I need to add u, m, so a total of 3 edits
//Another example, word1 = alligator, word2 = shark
//a->s, l -> h, l->a, i -> r, g ->k, the rest are additional so add the rest because i have to remove them which is consider an edit



int editDist(char* word1, char* word2){

  int word1_len = strlen(word1);
  int word2_len = strlen(word2);
  int* oldDist = (int*)malloc((word2_len + 1) * sizeof(int));
  int* curDist = (int*)malloc((word2_len + 1) * sizeof(int));

  int i,j,dist;


  //intialize distances to length of the substrings
  for(i = 0; i < word2_len + 1; i++){
    oldDist[i] = i;
    curDist[i] = i;
  }

  for(i = 1; i < word1_len + 1; i++){
    curDist[0] = i;
    for(j = 1; j < word2_len + 1; j++){
      if(word1[i-1] == word2[j-1]){
        curDist[j] = oldDist[j - 1];
      }//the characters in the words are the same
      else{
        curDist[j] = min(min(oldDist[j], //deletion
                          curDist[j-1]), //insertion
                          oldDist[j-1]) + 1; //subtitution
      }
    }//for each character in the second word
    swap(&oldDist, &curDist);
  }//for each character in the first word

  dist = oldDist[word2_len];//using oldDist instead of curDist because of the last swap
  free(oldDist);
  free(curDist);
  return dist;

}

int main(int argc, char** argv){
  if(argc < 3){
    printf("Usage: %s word1 word 2\n", argv[0]);
    exit(1);
  }
  printf("The distance between %s and %s is %d.\n", argv[1], argv[2], editDist(argv[1], argv[2]));

  return 0;
}
