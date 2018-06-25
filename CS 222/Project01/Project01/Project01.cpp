// Project01.cpp : Defines the entry point for the console application.
//

#include "stdafx.h"
#include "stdio.h"
#include "stdlib.h"

#define MAX_NUM 100
#define MAX_NUM_OF_DIGIT 20
#define FILE_PATH_LENGTH 100

/*
Purpose:
	- Reset an array. All it does is resetting all values in the array to 0 (zero).
Input:
	- appearances[]: a pointer to an array need to be reset.
Output:
	- nothing.
*/
void ResetCounting(int appearances[]) {
	// reset the counting for all to 0
	for(int i=0; i<=MAX_NUM; i++) {
		appearances[i] = 0;
	}
}

/*
Purpose:
	- Using scanf() function to get a path to a file or just a file name.
Input:
	- file[]: a pointer to an array of char which will be used to save the path/file name to.
Output:
	- nothing.
*/
void GetDataFileName(char file[]) {
	printf("Enter file name: ");
	// get file name via keyboard
	scanf("%s", file);
}

/*
Purpose:
	- Open the data file using fopen() function.
Input:
	- file[]: A pointer to an array of char (string) which contains a path/file name needed to be opened.
Output:
	- A file pointer.
*/
FILE* OpenDataFile(char file[]) {
	// open file and save its pointer to fp
	FILE* fp = fopen(file, "r");
	// open failed, print the message and terminate program
	if(!fp) {
		printf("Unable to open \"%s\"\nProgram terminated.\n", file);
		exit(1);
	}
	return fp;
}

/*
Purpose:
	- Read the data file which contains numbers in range 0->MAX_NUM.
	- Counting the appearances of each number.
	- Save the counting to an array variable appearances[].
	- This function also check for the correct data input (0<= number <= MAX_NUM)
Input:
	- FILE* fp: a pointer to data file.
	- appearances[]: an array which will be used to save the counting.
Output:
	- nothing.
*/
void ReadDataFileAndCountNumberAppearances(FILE* fp, int appearances[]) {
	char sNum[MAX_NUM_OF_DIGIT];
	int index;
	// read file, get data line by line 'til the end of file
	while(fgets(sNum, MAX_NUM_OF_DIGIT, fp) != NULL) {
		// convert string number into integer number
		index = atoi(sNum);
		// only count the appearances of number which is in range of 0->MAX_NUM
		if((index >= 0)&&(index <= MAX_NUM)) {
			// counting its appearance
			appearances[index]++;
		} else {
			printf("Incorrect data input: %i \n", index);
			printf("Data file should contain only numbers in range of 0...%i \n", MAX_NUM);
			exit(1);
		}
	}
}

/*
Purpose:
	- Print out the array which contains our counting.
	- With each time a number appear, we will print out a letter 'o'.
Input:
	- a pointer to an array which contains the counting.
Output:
	- nothing.
*/
void PrintResult(int appearances[]) {
	int IdxFound = 0;
	int startIdx = 0;
	int endIdx = MAX_NUM;
	int idx = 0;

	while(!IdxFound) {
		if(appearances[idx] != 0) {
			startIdx = idx;
			IdxFound = 1;
		}
		idx++;
	}
	
	IdxFound = 0;
	idx = MAX_NUM;

	while(!IdxFound) {
		if(appearances[idx] != 0) {
			endIdx = idx;
			IdxFound = 1;
		}
		idx--;
	}

	// print out the result
	for(int i=startIdx; i<=endIdx; i++) {
		printf("%3i: ", i);
		// if a number appears X times, print char 'o' X times next to it.
		if(appearances[i] > 0) {
			for(int j=0; j<appearances[i]; j++) {
				printf("o");
			}
		}
		printf("\n");
	}
}

/*
Purpose:
	- Close a file which we opened.
Input:
	- a pointer to a file which we opened.
Output:
	- nothing.
*/
void CloseDataFile(FILE* fp) {
	// close file
	fclose(fp);
}

int _tmain(int argc, _TCHAR* argv[])
{
	// path/file name limit to FILE_PATH_LENGTH-1 characters + end of string character
	char file_name[FILE_PATH_LENGTH];
	// array contain the counting for number from 0->MAX_NUM
	int count[(MAX_NUM+1)];
	// file pointer
	FILE *fpointer;

	ResetCounting(count); // reset the counting to 0
	GetDataFileName(file_name); // prompt user to input a file name which contains random numbers from 0-100.
	fpointer = OpenDataFile(file_name);
	ReadDataFileAndCountNumberAppearances(fpointer, count);
	PrintResult(count);
	CloseDataFile(fpointer);

	return 0;
}

