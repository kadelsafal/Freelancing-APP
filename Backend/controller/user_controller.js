const UserService = require('../services/user_services');

exports.register = async (req, res, next) => {
    try {
        const { Full_Name, PhnNumber, Email, Password } = req.body;

        // Register user
        const response = await UserService.registerUser(Full_Name, PhnNumber, Email, Password);

        // Generate token
        const tokenData = {
            _id: response._id,
            Email: response.Email,
            Full_Name: response.Full_Name,
            PhnNumber: response.PhnNumber
        };
        const token = await UserService.generateToken(tokenData, "123", "2h");

        // Single response
        return res.status(200).json({
            status: true,
            message: "User registered successfully",
            token: token,
            user: {
                Full_Name: response.Full_Name,
                Email: response.Email,
                PhnNumber: response.PhnNumber
            }
        });
    } catch (err) {
        return res.status(400).json({
            status: false,
            message: err.message
        });
    }
};

exports.login = async (req, res, next) => {
    try {
        const { Email, Password } = req.body;

        // Check if user exists
        const user = await UserService.checkUser(Email);
        if (!user) {
            throw new Error("User does not exist");
        }

        // Check password
        const isMatch = await user.comparePassword(Password);
        if (!isMatch) {
            throw new Error("Invalid password");
        }

        // Generate token
        const tokenData = {
            _id: user._id,
            Email: user.Email,
            Full_Name: user.Full_Name,
            PhnNumber: user.PhnNumber
        };
        const token = await UserService.generateToken(tokenData, "123", "2h");

        return res.status(200).json({
            status: true,
            token: token,
            user: {
                Full_Name: user.Full_Name,
                Email: user.Email,
                PhnNumber: user.PhnNumber
            }
        });
    } catch (err) {
        return res.status(400).json({
            status: false,
            message: err.message
        });
    }
};
