//Initilization of mongoose

const mongoose = require ('mongoose');

//Connecting to mongoose
mongoose.connect("mongodb://localhost:27017/freelancingapp").then (
()=>{
    console.log("Mongoose Connected !");
}).catch((error) => {
    console.error("Connection error: ", error)
})

module.exports = mongoose;