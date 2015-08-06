#include<syslog.h>
#include<stdio.h>
#include<stdarg.h>

int main(void){
    int i;
    for(i=0;i<10;i++){
        openlog("log_test",LOG_PID|LOG_CONS,LOG_USER);
        syslog(LOG_INFO,"PID information, pid=%d",getpid());
        //printf("this pid = %d",getpid());
        syslog(LOG_DEBUG,"debug message");
        closelog();
    }
    return 0;
}
