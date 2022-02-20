#include<bits/stdc++.h>
#define int long long int

using namespace std;

const int tests = 15, maxn = 40;
int fib[maxn];
int N;

string form(int n, int x)
{
	string ret;
	for (int i = n - 1; i >= 61; i--)
		ret += '0';
	for (int i = min(n - 1, 60LL); i >= 0; i--)
		ret += '0' + ((x &(1LL << i)) != 0);
	return ret;
}

int fib_cal(int n)
{
	if (n <= 1)
		return fib[n] = 1;
	else if (fib[n])
		return fib[n];
	else if (n > N / 2)
		return fib[n] = (n - 1) * fib_cal(n - 1) + (n - 2) * fib_cal(n - 2);
	else
		return fib[n] = (n - 2) * fib_cal(n - 1) + (n - 1) * fib_cal(n - 2);
}

int32_t main()
{
	ofstream file;
	file.open("../file/fib.tv");
	for (int i = 0; i < tests; i++)
	{
		for (int j = 0; j < maxn; j++)
			fib[j] = 0;
		N = i;
		file << form(5, i) << "_" << form(121, fib_cal(i)) << endl;
	}
	file.close();
}