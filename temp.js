const { createServer } = require('node:http');

const hostname = '127.0.0.1';
const port = 3000;

const colorDim = "\x1b[2m";
const colorReset = "\x1b[0m";
const colorValue = "\x1b[32m";
const colorError = "\x1b[31m";

const server = createServer((req, res) => {

    console.log(`${colorDim}=> ${colorReset + colorValue}${req.method} ${req.url}${colorReset}`);
    
    res.statusCode = 404;
    res.setHeader('Content-Type', 'text/plain');
    res.end('Hello World');

    switch (res.statusCode) {

        case 200:
            console.log(`${colorDim}<= [200]${colorReset}`);
            break;
        
        default:
            console.log(`${colorDim}<= [${colorReset + colorError}${res.statusCode}${colorReset + colorDim}]: ${colorReset + colorError}<Error message>${colorReset}`);
    }
});

server.listen(port, hostname, () => {

    console.log(`${colorDim}Started WSAS (a1.0) server @ ${colorReset + colorValue}http://${hostname}:${port}/${colorReset}`);
});