#include <stdio.h>

void insertionSortRecursive(int arr[], int n)
{
	if (n <= 1)
		return;

	insertionSortRecursive(arr, n - 1);

	int value = arr[n - 1];
	int j = n - 2;

	while (j >= 0 && arr[j] > value) {
		arr[j + 1] = arr[j];
		j--;
	}
	arr[j + 1] = value;
}

int main()
{
	int arr[] = { -13, 8, 2, -1 };
	int n = 4;

	insertionSortRecursive(arr, n);
    
	return 0;
}

