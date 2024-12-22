const mongoose = require('../config/dbconnection');  // Import mongoose from dbconnection
const bcrypt = require('bcrypt');
// Define the schema for the user model
const user_schema = mongoose.Schema({
   
    Full_Name: {
        type: String,
        required: true, // Ensures the name is mandatory
    },
    PhnNumber: {
        type: String,
        required: true,
        unique: true, // Ensures the phone number is unique
        validate: {
            validator: function (v) {
                return /^\+\d{1,3}\d{9,12}$/.test(v); // Validates 10-digit phone numbers
            },
            message: props => `${props.value} is not a valid phone number!`,
        },
    },
    Email: {
        type: String,
        required: true,
        lowercase: true,
        unique: true, // Ensures the email is unique
        match: [/.+\@.+\..+/, "Please enter a valid email address"], // Validates email format
    },
    Password: {
        type: String,
        required: true, // Ensures password is mandatory
        minlength: 6, // Sets minimum length for the password
    },
    Date_joined: {
        type: Date,
        default: Date.now, // Automatically sets the date when the user is created
    },
});
user_schema.pre('save', async function (next) {
    try {
        if (!this.isModified('Password')) return next(); // Skip if password is not modified
        const salt = await bcrypt.genSalt(10);
        const hashedPassword = await bcrypt.hash(this.Password, salt);
        this.Password = hashedPassword;
        next(); // Proceed to save
    } catch (err) {
        next(err); // Pass error to save operation
    }
});

user_schema.methods.comparePassword= async function(userPassword) {
    try {
        return await bcrypt.compare(userPassword, this.Password)
    
    } catch (error) {
    throw new Error("Error comparing Passwords");    
    }
}
// Create the user model using mongoose.model
const userModal = mongoose.model('user', user_schema);

module.exports = userModal;
