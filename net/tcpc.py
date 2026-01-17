from socket import * 
serverPort = 12000
serverHost = "127.0.0.1"
clientSocket = socket(AF_INET, SOCK_STREAM)

clientSocket.connect((serverHost, serverPort))
msg = input("Input lowercase sentence: ")
clientSocket.send(msg.encode())
modifiedMsg = clientSocket.recv(1024)
print('From Server: ', modifiedMsg.decode())
clientSocket.close()

C5hai%ma1neww$%FxF22