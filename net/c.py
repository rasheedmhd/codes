from socket import * 
serverName = "127.0.0.1"
serverPort = 12000
clientSocket = socket(AF_INET, SOCK_DGRAM) 

while True:
    msg = input("Input lowercase sentence: ")
    clientSocket.sendto(msg.encode(), (serverName, serverPort))
    modifiedMsg, serverAddress = clientSocket.recvfrom(2048)
x
    print(modifiedMsg.decode())
    # clientSocket.close()