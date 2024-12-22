const UserService = require('../services/user_services');


exports.register = async (req,res, next )=>{
    try{
        const {Full_Name, PhnNumber, Email, Password} = req.body;

        const response = await UserService.registerUser(Full_Name, PhnNumber, Email, Password);
        res.json({status:true, success:"User Registered Succesfully",response});
    }
    catch(err){
        return res.json({
            status: false,
            
            message: err.message
        })
    }
}

exports.login = async (req,res, next )=>{
    try{
        const {Email, Password} = req.body;

        const user = await UserService.checkUser(Email)
        console.log("-----------------------------user------------------------------", user);

        if(!user){
            throw new Error("User don't Exits");
        }

        const isMatch = await user.comparePassword(Password);

        if(isMatch === false ){
            throw new Error("Password Invalid");
        }
        
        let tokenData;
        tokenData = {_id:user._id, Email:user.Email, Full_Name: user.Full_Name, PhnNumber: user.PhnNumber};

        const token = await UserService.generateToken(tokenData,"123",'2h' );
        console.log("Generated token:", token);
        res.status(200).json({status:true, token:token});
    }
    catch(err){
        return res.json({
            status: false,
            
            message: err.message
        })
    }
}
