#include <stdio.h>
#include <stdlib.h>
#include <cstring>

class Code_Decryption
{
public:
	Code_Decryption(unsigned char * key);
	~Code_Decryption();
	unsigned char* Invcipher(unsigned char *input,int length);
	
private:
	unsigned char Invs_box[256];
	unsigned char s_box[256];
	unsigned char state[6][6];
	unsigned char w[11][6][6];//0-8:4*4;9:4*6;10:6*6
	void Invnonlinear_trans(int round);//1-8:4*4;9:4*6;10:6*6
	void Invtranspose(unsigned char* state);//1-8:4*4;9:4*6;10:6*6
	void keyExpansion(unsigned char *key);
	void addRoundkey(int round);
};
