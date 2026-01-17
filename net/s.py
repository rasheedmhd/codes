# Server 
from socket import *
PORT = 12000
serverSocket = socket(AF_INET, SOCK_DGRAM)
serverSocket.bind(("", PORT))

print("Ready to receive")
while True:
    msg, clientA = serverSocket.recvfrom(2048)
    mmsg = msg.decode().upper()
    serverSocket.sendto(mmsg.encode(), clientA)