#include<stdio.h>
#include<stdlib.h> 
#include<string.h>
int loop()
{
    char str[256];
    FILE *fp1,*fp2;
    if ((fp1=fopen("/var/log/messages","r"))==NULL)
    { /* 以只读方式打开文件1 */
        printf("cannot open file\n");
        exit(0);
    }
    if((fp2=fopen("/home/lookfiresu/four-level/test.txt","w"))==NULL)
    { /*以只写方式打开文件2 */
        printf("cannot open file\n");
        exit(0);
    }
    while((fgets(str,256,fp1))!=NULL)
    /*从文件中读回的字符串长度大于0 */
    {
	if(strstr(str,"error")||strstr(str,"ERROR")||strstr(str,"warning")||strstr(str,"WARNING"))
        {
            fputs(str,fp2 ); /* 从文件1读字符串并写入文件2 */
        }
    }
    fclose(fp1);
    fclose(fp2);
}

void main()
{
    while(1){
	loop();
	sleep(30);
    }
}
