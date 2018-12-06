#include <stdio.h>
#include <cstring>//memeset
#include <stdlib.h>//malloc
class Error_correct
{
public:
	Error_correct(unsigned char * key);
	~Error_correct();
	unsigned char* cipher(unsigned char *input,int length);
	
private:
	unsigned char s_box[256];
	unsigned char state[6][6];
	unsigned char w[11][6][6];//0-8:4*4;9:4*6;10:6*6
	void nonlinear_trans(int round);//1-8:4*4;9:4*6;10:6*6
	void transpose(unsigned char* state);//1-8:4*4;9:4*6;10:6*6
	void keyExpansion(unsigned char *key);
	void addRoundkey(int round);
	void mulMatri(int m,int n);
	unsigned char XTIME(unsigned char x);
	unsigned char multiply(unsigned char a, unsigned char b);
};

