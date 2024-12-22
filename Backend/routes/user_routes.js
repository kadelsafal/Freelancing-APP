const router = require('express').Router();
const Usercontroller = require('../controller/user_controller');
router.post('/registration',Usercontroller.register);
router.post('/login',Usercontroller.login);

module.exports = router;