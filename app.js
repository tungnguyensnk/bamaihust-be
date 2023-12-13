let express = require('express');
let path = require('path');
let cookieParser = require('cookie-parser');
let logger = require('morgan');
let {client} = require('./database/client');
let indexRouter = require('./routes/index');

let app = express();

client.connect();
app.use(logger('dev'));
app.use(express.json());
app.use(express.urlencoded({extended: false}));
app.use(cookieParser());
app.use(express.static(path.join(__dirname, 'public')));

// disable CORS
app.use((req, res, next) => {
    res.header('Access-Control-Allow-Origin', '*');
    res.header('Access-Control-Allow-Headers', '*');
    res.header('Access-Control-Allow-Methods', '*');
    next();
});

app.use('/', indexRouter);

// error handler
app.use((err, req, res, next) => {
    console.log(err);
    res.status(err.status || 500).json({message: err.message});
});

module.exports = app;
