#include <stdio.h>

void tranMatrix(unsigned char* m,int width,int height )
{
    int index1=0;
    int index2=0;
    int tmp=0;
    for(int i=0;i<height;i++)
    {
        for(int j=i;j<width;j++)
        {
            index1=i*width+j;
            tmp=*(m+index1);
            index2=j*width+i;
            *(m+index1)=*(m+index2);
            *(m+index2)=tmp;
        }
    }
}
int main()
{
	unsigned char a[4][4]={0x52,0x09,0x6a,0xd5
			      ,0x30,0x36,0xa5,0x38
			      ,0xbf,0x40,0xa3,0x9e
			      ,0x81,0xf3,0xd7,0xfb};
	tranMatrix(a[0],4,4);
	printf("\n");
	for(int i=0;i<4;i++)
   	{
        	for(int j=0;j<4;j++)
        	{
			printf("%02x",a[i][j]);
		}
		printf("\n");
        }
}
