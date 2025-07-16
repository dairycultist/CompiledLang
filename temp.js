const { createServer } = require('node:http');

const hostname = "127.0.0.1";
const port = 3000;

const colorDim = "\x1b[2m";
const colorReset = "\x1b[0m";
const colorValue = "\x1b[32m";
const colorError = "\x1b[31m";



function processGET(req, res) {

    switch (req.url) {

        case "/": respond(res, 200, "text/plain", "Hello World", "Serving index."); break;
        default: respond(res, 404, "text/plain", "404", "Could not locate URL."); break;
    }
}

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
    
    switch (req.method) {

        case "GET": processGET(req, res); break;
        
        default:
            respond(res, 200, "text/plain",
                `WSAS is currently unable to process ${req.method} requests.`,
                `WSAS is currently unable to process ${req.method} requests.`
            );
            break;
    }
});

server.listen(port, hostname, () => {

    console.log(`${colorDim}Started WSAS (a1.0) server @ ${colorReset + colorValue}http://${hostname}:${port}/${colorReset}`);
});