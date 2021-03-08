// ------------------------------------------------------------------------------------------------
// B. Lang, OS
// ------------------------------------------------------------------------------------------------
#include <windows.h>
#include<stdio.h>

int main(void) {
  HANDLE Pipe_C2VHD;
  HANDLE Pipe_VHD2C;
  char buffer[1024];
  DWORD dwRead;
  DWORD dwWrite;
  printf("Pipe_Server\r\n");
  Pipe_C2VHD = CreateNamedPipe(TEXT("\\\\.\\pipe\\PipeA"),
                          PIPE_ACCESS_DUPLEX, // PIPE_ACCESS_OUTBOUND, //
                          PIPE_TYPE_BYTE | PIPE_READMODE_BYTE | PIPE_WAIT,   // FILE_FLAG_FIRST_PIPE_INSTANCE is not needed but forces CreateNamedPipe(..) to fail if the pipe already exists...
                          2,
                          1024 * 16,
                          1024 * 16,
                          NMPWAIT_USE_DEFAULT_WAIT,
                          NULL);
  Pipe_VHD2C = CreateNamedPipe(TEXT("\\\\.\\pipe\\PipeB"),
                               PIPE_ACCESS_DUPLEX, // PIPE_ACCESS_OUTBOUND, //
                               PIPE_TYPE_BYTE | PIPE_READMODE_BYTE | PIPE_WAIT,   // FILE_FLAG_FIRST_PIPE_INSTANCE is not needed but forces CreateNamedPipe(..) to fail if the pipe already exists...
                               2,
                               1024 * 16,
                               1024 * 16,
                               NMPWAIT_USE_DEFAULT_WAIT,
                               NULL);
  if ( (Pipe_C2VHD != INVALID_HANDLE_VALUE) && (Pipe_VHD2C != INVALID_HANDLE_VALUE) ) {
    BOOL ret;
    ret = ConnectNamedPipe(Pipe_C2VHD, NULL);
    ret = ConnectNamedPipe(Pipe_VHD2C, NULL);
    printf("starting\r\n");
    { int i;
      char* values[] = {"0000 0\r\n\0", "0001 0\r\n\0", "0010 0\r\n\0", "0011 0\r\n\0",
                        "0100 0\r\n\0", "0101 0\r\n\0", "0110 0\r\n\0", "0111 0\r\n\0",
                        "1000 0\r\n\0", "1001 0\r\n\0", "1010 0\r\n\0", "1011 0\r\n\0",
                        "1100 0\r\n\0", "1101 0\r\n\0", "1110 0\r\n\0", "1111 1\r\n\0",NULL };
      for(i=0;values[++i]!=NULL;) {
        strcpy(buffer,values[i]);
        if (WriteFile(Pipe_C2VHD, buffer, strlen(buffer), &dwWrite, NULL) == FALSE){ printf("write error"); break; }
        if (ReadFile (Pipe_VHD2C, buffer, sizeof(buffer), &dwRead,  NULL) == FALSE){ printf("read error");  break; }
        buffer[dwRead] = '\0'; // add terminating zero
        printf("%s", buffer);  // process received data
      }
    }
  }
  DisconnectNamedPipe(Pipe_VHD2C);
  DisconnectNamedPipe(Pipe_C2VHD);
  return 0;
}
