const app = require('./app');
const db = require('./config/dbconnection');
const userModal = require('./modal/user_modal');
const port = 3000;

app.get("/", (req,res)=>{
res.send("Node file");
})

app.listen(port, ()=>{
    console.log(`Server is running on ${port}`);

})