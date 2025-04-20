// Save this as server.js
const http = require('http');

const server = http.createServer((req, res) => {
  const host = req.headers.host;

  if (host === 'example.com') {
    res.writeHead(200, { 'Content-Type': 'text/plain' });
    res.end('Hello from example.com!\n');
  } else if (host === 'test.com') {
    res.writeHead(200, { 'Content-Type': 'text/plain' });
    res.end('Hello from test.com!\n');
  } else {
    res.writeHead(404, { 'Content-Type': 'text/plain' });
    res.end('Unknown host!\n');
  }
});

server.listen(3000, () => {
  console.log('Server is running on http://localhost:3000');
});
