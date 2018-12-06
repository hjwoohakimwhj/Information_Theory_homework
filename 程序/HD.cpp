#include <stdio.h>
#include <cstring>//memeset
#include <stdlib.h>//malloc

using namespace std;
#define M 4

#define N 4

void mulMatri(unsigned char x[M][N],unsigned char y[N][M],unsigned char z[M][M],int m,int n);
unsigned char XTIME(unsigned char x) ;
unsigned char multiply(unsigned char a, unsigned char b) ;




int main()

{

    int i,j;

    unsigned char z[M][M];

    unsigned char x[4][4]={0x52,0x09,0x6a,0xd5,
			   0x30,0x36,0xa5,0x38,
			   0xbf,0x40,0xa3,0x9e,
			   0x81,0xf3,0xd7,0xfb};
    unsigned char y[4][4]={0x01,0x01,0x03,0x02,
					  0x02,0x01,0x01,0x03,
					  0x03,0x02,0x01,0x01,
					  0x01,0x03,0x02,0x01};
    mulMatri(y,x,z,M,N);

    for(i=0;i<M;i++){

       for(j=0;j<M;j++)
	{
	printf("%02x\t",z[i][j]);
	}
	printf("\n");

    }


    return 0;    

}

void mulMatri(unsigned char x[M][N],unsigned char y[N][M],unsigned char z[M][M],int m,int n)

{

   int i,j,k;

   for(i=0;i<m;i++)
   {

     for(j=0;j<m;j++)
     {

         z[i][j]=0;

         for(k=0;k<n;k++)
	 {       
	    	z[i][j]^=multiply(x[i][k],y[k][j]); 
	 }

      } 
   }   

}

unsigned char XTIME(unsigned char x) 
{
    return ((x << 1) ^ ((x & 0x80) ? 0x1b : 0x00));
}
unsigned char multiply(unsigned char a, unsigned char b) 
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
