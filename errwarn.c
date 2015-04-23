#include<stdio.h>
#include<stdlib.h> 
void main(){
    system("grep -i error /var/log/messages");
    system("grep -i warning /var/log/messages");
}
