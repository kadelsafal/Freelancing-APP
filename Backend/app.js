//Initilization of express
const express = require("express");
const body_parser = require('body-parser');
const userRoute = require('./routes/user_routes');
const app = express();
app.use(body_parser.json());
app.use("/", userRoute);
module.exports = app;