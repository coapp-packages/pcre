// pcre_pkgtest.cpp : Defines the entry point for the console application.
//

#include "stdafx.h"
#include "Win32\v110\static\Release\pcre.h"
#include <string.h>

void test(char *input)
{
	pcre *myregexp;
	const char *error;
	int erroroffset;
	int offsetcount;
	int offsets[30]; // (max_capturing_groups+1)*3
	char *result;
	myregexp = pcre_compile("^(.*?)hello.*?(\\d+)", 0, &error, &erroroffset, NULL);
	if (myregexp != NULL) {
		offsetcount = pcre_exec(myregexp, NULL, input, strlen(input), 0, 0, offsets, 30);
		if (offsetcount > 0) {
			pcre_get_substring(input, (int*) &offsets, offsetcount, 1, (const char**) &result);
			// offset = offsets[1*2];
			// length = offsets[1*2+1] - offsets[1*2];
		} else {
			result = NULL;
		} 
	}
}

int _tmain(int argc, _TCHAR* argv[])
{
	char* test1 = "This is a test of the hello world application. 123456789.";
	char* test2 = "This string doesn't match the desired regex.";

	test(test1);
	test(test2);

	return 0;
}

