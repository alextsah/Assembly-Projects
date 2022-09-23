#include <stdio.h>

void insertionSort(int arr[], int n)
{
	for (int i = 1; i < n; i++) {
		int value = arr[i];
		int j = i - 1;

		while (j >= 0 && arr[j] > value) {
			arr[j + 1] = arr[j];
			j = j - 1;
		}
		arr[j + 1] = value;
	}
}

int main()
{
	return 0;
}

