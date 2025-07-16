const { createServer } = require('node:http');

const hostname = '127.0.0.1';
const port = 3000;

const colorDim = "\x1b[2m";
const colorReset = "\x1b[0m";
const colorValue = "\x1b[32m";
const colorError = "\x1b[41m";

const server = createServer((req, res) => {
    res.statusCode = 200;
    res.setHeader('Content-Type', 'text/plain');
    res.end('Hello World');

    console.log(`${colorDim}[200]: ${colorReset + colorValue}${req.method} ${req.url}${colorReset}`);
});

server.listen(port, hostname, () => {
    console.log(`${colorDim}Started WSAS (a1.0) server @ ${colorReset + colorValue}http://${hostname}:${port}/${colorReset}`);
});