const { createServer } = require('node:http');

const hostname = "127.0.0.1";
const port = 3000;

const colorDim = "\x1b[2m";
const colorReset = "\x1b[0m";
const colorValue = "\x1b[32m";
const colorError = "\x1b[31m";

function respond(res, statusCode, contentType, content, logMessage) {

    // respond
    res.statusCode = statusCode;
    res.setHeader("Content-Type", contentType);
    res.end(content);

    // log response
    if (res.statusCode == 200) {

        console.log(`${colorDim}<= [200]: ${logMessage}${colorReset}`);
    } else {
        console.log(`${colorDim}<= [${colorReset + colorError}${res.statusCode}${colorReset + colorDim}]: ${colorReset + colorError}${logMessage}${colorReset}`);
    }
}

const server = createServer((req, res) => {

    // log request
    console.log(`${colorDim}=> ${colorReset + colorValue}${req.method} ${req.url}${colorReset}`);
    
    // respond
    respond(res, 200, "text/plain", "Hello World", "");
});

server.listen(port, hostname, () => {

    console.log(`${colorDim}Started WSAS (a1.0) server @ ${colorReset + colorValue}http://${hostname}:${port}/${colorReset}`);
});