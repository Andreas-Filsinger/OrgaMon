// rs232_to_led.c
// e.boelen 5 Mar 2002
// Andreas Filsinger 05.11.2020
//
// a small c program that will turn pin 4 on a rs232 port 'high'


// C library headers
#include <stdio.h>
#include <string.h>

// Linux headers
#include <fcntl.h> // Contains file controls like O_RDWR
#include <errno.h> // Error integer and strerror() function
#include <termios.h> // Contains POSIX terminal control definitions
#include <unistd.h> // write(), read(), close()

#include <stdlib.h>
#include <sys/ioctl.h>

void main()
{
  int fd,pin,i;
  char device[255] = "/dev/ttyS0"; // this is serial port 2 

  fd = open(device, O_RDWR | O_NOCTTY);
  if (fd == -1) {
    char s[255];
    sprintf(s, "statserial: can't open device `%s'", device);
    perror(s);
    exit(1);
  }

  pin=TIOCM_RTS;  // Set RTS (pin 4)

  while (1) {
   ioctl(fd, TIOCMBIS,&pin); // low level io function
   sleep(1);
   ioctl(fd, TIOCMBIC,&pin); // low level io function
   sleep(1);
  }
  close(fd);
}