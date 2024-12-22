const userModal = require('../modal/user_modal');
const jwt = require("jsonwebtoken");
class UserService{
    static async registerUser(Full_Name, PhnNumber, Email, Password){
        try{
            const createUser = new userModal({
                Full_Name,
                PhnNumber,
                Email,
                Password
            });
            
                return  await createUser.save();
        }catch(err){
            if (err.code === 11000) {
                // Extract which field caused the error
                if (err.keyPattern.Email) {
                    throw new Error("Email address already exists. Please use a different email.");
                }
                if (err.keyPattern.PhnNumber) {
                    throw new Error("Phone number already exists. Please use a different phone number.");
                }
            }
            throw new Error(err.message); // Other errors
        }
    }
    static async checkUser (email){
        try{
            const isMatch = await userModal.findOne({Email:email});
            
            return isMatch;
            console.log("----------------------------Found-------------------")
        }catch(err){

        }
    }

    static async generateToken(tokenData,secretKey,jwtexpiry){
        try {
            return jwt.sign(tokenData, secretKey, {expiresIn: jwtexpiry});    
        } catch (error) {
            throw new Error (`Token generation failed: ${error.message}`);
        }
        
    }
}
module.exports = UserService;