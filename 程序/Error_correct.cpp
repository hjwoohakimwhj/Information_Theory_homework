#include "string.h"
#include "Error_correct.h"
#include "Code_Decryption.h"
#define DEFAULT_LENGTH_ROOT 4

Error_correct::Error_correct(unsigned char* key)
{
	unsigned char sbox[256] =
	{ /*  0    1    2    3    4    5    6    7    8    9    a    b    c    d    e    f */ 
		0x63,0x7c,0x77,0x7b,0xf2,0x6b,0x6f,0xc5,0x30,0x01,0x67,0x2b,0xfe,0xd7,0xab,0x76, /*0*/  
		0xca,0x82,0xc9,0x7d,0xfa,0x59,0x47,0xf0,0xad,0xd4,0xa2,0xaf,0x9c,0xa4,0x72,0xc0, /*1*/
		0xb7,0xfd,0x93,0x26,0x36,0x3f,0xf7,0xcc,0x34,0xa5,0xe5,0xf1,0x71,0xd8,0x31,0x15, /*2*/ 
		0x04,0xc7,0x23,0xc3,0x18,0x96,0x05,0x9a,0x07,0x12,0x80,0xe2,0xeb,0x27,0xb2,0x75, /*3*/ 
		0x09,0x83,0x2c,0x1a,0x1b,0x6e,0x5a,0xa0,0x52,0x3b,0xd6,0xb3,0x29,0xe3,0x2f,0x84, /*4*/ 
		0x53,0xd1,0x00,0xed,0x20,0xfc,0xb1,0x5b,0x6a,0xcb,0xbe,0x39,0x4a,0x4c,0x58,0xcf, /*5*/
		0xd0,0xef,0xaa,0xfb,0x43,0x4d,0x33,0x85,0x45,0xf9,0x02,0x7f,0x50,0x3c,0x9f,0xa8, /*6*/  
		0x51,0xa3,0x40,0x8f,0x92,0x9d,0x38,0xf5,0xbc,0xb6,0xda,0x21,0x10,0xff,0xf3,0xd2, /*7*/ 
		0xcd,0x0c,0x13,0xec,0x5f,0x97,0x44,0x17,0xc4,0xa7,0x7e,0x3d,0x64,0x5d,0x19,0x73, /*8*/ 
		0x60,0x81,0x4f,0xdc,0x22,0x2a,0x90,0x88,0x46,0xee,0xb8,0x14,0xde,0x5e,0x0b,0xdb, /*9*/ 
		0xe0,0x32,0x3a,0x0a,0x49,0x06,0x24,0x5c,0xc2,0xd3,0xac,0x62,0x91,0x95,0xe4,0x79, /*a*/
		0xe7,0xc8,0x37,0x6d,0x8d,0xd5,0x4e,0xa9,0x6c,0x56,0xf4,0xea,0x65,0x7a,0xae,0x08, /*b*/
		0xba,0x78,0x25,0x2e,0x1c,0xa6,0xb4,0xc6,0xe8,0xdd,0x74,0x1f,0x4b,0xbd,0x8b,0x8a, /*c*/ 
		0x70,0x3e,0xb5,0x66,0x48,0x03,0xf6,0x0e,0x61,0x35,0x57,0xb9,0x86,0xc1,0x1d,0x9e, /*d*/
		0xe1,0xf8,0x98,0x11,0x69,0xd9,0x8e,0x94,0x9b,0x1e,0x87,0xe9,0xce,0x55,0x28,0xdf, /*e*/ 
		0x8c,0xa1,0x89,0x0d,0xbf,0xe6,0x42,0x68,0x41,0x99,0x2d,0x0f,0xb0,0x54,0xbb,0x16  /*f*/
	};
	memcpy(s_box, sbox, 256);
	memset(state,0x00,sizeof(state));
	//printf("firest %02x",state[3][4]);
	keyExpansion(key);
}

Error_correct::~Error_correct()
{
	//
}

void Error_correct::nonlinear_trans(int round)
{
	int r,c,r_max,c_max;
	int length=DEFAULT_LENGTH_ROOT;
	if(round>=9)
	{
		c_max=length+2;
		if(round==9)
		{
			r_max=length;
		}else{
			r_max=length+2;
		}
	}else{
		c_max=length;
		r_max=length;
	}
	for(c=0; c<c_max; c++)
	{
		for(r=0; r<r_max; r++)
		{
			state[r][c] = s_box[state[r][c]];
		}
	}
	for(r=0; r<r_max; r++)
	{
		for(c=0; c<c_max; c++)
		{
			printf("%02x\t",state[r][c]);
		}
		printf("\n");
	}
	printf("***********%d fininsh_nonline_trans***********\n",round);
}

void Error_correct::transpose(unsigned char* m)//state[0]
{
    int index1=0;
    int index2=0;
    int tmp=0;
    for(int i=0;i<6;i++)
    {
        for(int j=i;j<6;j++)
        {
            index1=i*6+j;
            tmp=*(m+index1);
            index2=j*6+i;
            *(m+index1)=*(m+index2);
            *(m+index2)=tmp;
        }
    }
}

void Error_correct::keyExpansion(unsigned char *key)
{
	//
	int i,j,r,c;
	unsigned char rc[] = {0x01, 0x02, 0x04, 0x08, 0x10, 0x20, 0x40, 0x80, 0x1b, 0x36};
	for(r=0; r<6; r++)
	{
		for(c=0; c<6; c++)
		{
			w[0][r][c] = key[r+c*6];
			//printf("%02x\t",w[0][r][c]);
		}
		//printf("\n");
	}
	//printf("====================================================\n");
	for(i=1; i<=10; i++)
	{
		for(j=0; j<6; j++)
		{
			unsigned char t[6];
			for(r=0; r<6; r++)
			{
				t[r] = j ? w[i][r][j-1] : w[i-1][r][5];
			}
			if(j == 0)
			{
				unsigned char temp = t[0];
				for(r=0; r<5; r++)
				{
					t[r] =  s_box[t[(r+1)%6]];
				}
				t[5] =  s_box[temp];
				t[0] ^= rc[i-1];
			}
			for(r=0; r<6; r++)
			{
				w[i][r][j] = w[i-1][r][j] ^ t[r];
			}
		}
#if 1
		
		if(i==10)
		{
			printf("=======================*********10=============================\n");
			for(r=0; r<6; r++)
			{
				for(c=0; c<6; c++)
				{
				
					printf("%02x\t",w[i][r][c]);
				}
				printf("\n");
			}
			printf("====================****************10================================\n");
		}
#endif
		for(r=0; r<6; r++)
		{
			for(c=0; c<6; c++)
			{
				
				//printf("%02x\t",w[i][r][c]);
			}
			//printf("\n");
		}
		//printf("====================================================\n");
	}
}

void Error_correct::addRoundkey(int round)
{
	int r,c;
	int length=DEFAULT_LENGTH_ROOT;
	switch (round)
	{
		case 8:
		{
			for(c=0; c<length+2; c++)
			{
				for(r=0; r<length; r++)
				{
					state[r][c] ^= w[round][r][c];
				}
			}
			break;
		}
		case 9:
		case 10:
		{	
			for(c=0; c<length+2; c++)
			{
				for(r=0; r<length+2; r++)
				{
					state[r][c] ^= w[round][r][c];
				}
			}
			
			break;
		}
		default:
		{
			for(c=0; c<length; c++)
			{
				for(r=0; r<length; r++)
				{
					state[r][c] ^= w[round][r][c];
				}
			}
			break;
		}
	}
}

unsigned char Error_correct::XTIME(unsigned char x) 
{
    return ((x << 1) ^ ((x & 0x80) ? 0x1b : 0x00));
}
unsigned char Error_correct::multiply(unsigned char a, unsigned char b) 
{
    unsigned char temp[8] = { a };
    unsigned char tempmultiply = 0x00;
    int i = 0;
    for (i = 1; i < 8; i++) 
    {
        temp[i] = XTIME(temp[i - 1]);
    }
    tempmultiply = (b & 0x01) * a;
    for (i = 1; i <= 7; i++) 
    {
        tempmultiply ^= (((b >> i) & 0x01) * temp[i]);
    }
    return tempmultiply;
}


void Error_correct::mulMatri(int m,int n)

{

   int i,j,k;
   unsigned char s[4][4]={0x01,0x01,0x03,0x02,
					  0x02,0x01,0x01,0x03,
					  0x03,0x02,0x01,0x01,
					  0x01,0x03,0x02,0x01};
   unsigned char z[4][4];
   for(i=0;i<4;i++)
   {

     for(j=0;j<4;j++)
     {

         z[i][j]=0;

         for(k=0;k<4;k++)
	 {       
	    	z[i][j]^=multiply(s[i][k],state[k][j]); 
	 }

      } 
   }   

   for(i=0;i<4;i++)
   {

     for(j=0;j<4;j++)
     {
	state[i][j]=z[i][j];
      } 
   } 
}


unsigned char* Error_correct::cipher(unsigned char *input,int length)
{
	int i,r,c;
	unsigned char* output=(unsigned char*)malloc(sizeof(unsigned char)*36);
	for(r=0; r<length; r++)//initial
	{
		for(c=0; c<length ;c++)
		{
			state[r][c] = input[c*length+r];
		}
	}
	addRoundkey(0);
	for(r=0; r<6; r++)
	{
		for(c=0; c<6 ;c++)
		{
			printf("%02x\t",state[r][c]);
		}
		printf("\n");
	}
	//printf("============0==============\n");
	for(i=1; i<=10; i++)
	{
		nonlinear_trans(i);
		transpose(state[0]);
		if(i<10)
		{
			if(i<=4)
			{	
				mulMatri(4,4);
			}
		}		
		addRoundkey(i);
			for(r=0; r<6; r++)
			{
				for(c=0; c<6 ;c++)
				{
					printf("%02x\t",state[r][c]);
				}
			printf("\n");
			}
		//printf("=============%d finish_addroundkey===========\n",i);

	}
	for(r=0; r<6; r++)
	{
		for(c=0; c<6 ;c++)
		{
			output[c*6+r] = state[r][c];
		}
	}
	return output;
	//	
}

int main()
{
	int r,c;
	unsigned char key[36] = {0x17,0x2b,0x04,0x7e,0xba,0x77,0xd6,0x26,0xe1,0x69,0x14,0x63,0x55,0x21,0x0c,0x7d  /*f*/
	,0x86,0xc1,0x1d,0x9e, /*d*/
		0xe1,0xf8,0x98,0x11,0x69,0xd9,0x8e,0x94,0x9b,0x1e,0x87,0xe9,0xce,0x55,0x28,0xdf};
	Error_correct a(key);
	unsigned char input[16]={0x52,0x09,0x6a,0xd5,0x30,0x36,0xa5,0x38,0xbf,0x40,0xa3,0x9e,0x81,0xf3,0xd7,0xfb};
	unsigned char* output=a.cipher(input,4);
	printf("\n");
	//printf("%02x",output[0]);
	Code_Decryption b(key);
	unsigned char* input_cover=b.Invcipher(output,6);
#if 1
	printf("happy end!!!!!!!\n");
	for(r=0; r<4; r++)
	{
		for(c=0; c<4 ;c++)
		{
			printf("%02x\t",input_cover[r*4+c]);
		}
		printf("\n");
	}
#endif
}
	

