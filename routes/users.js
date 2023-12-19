let express = require('express');
const controllers = require('../controllers');
let router = express.Router();

router.get('/:id', controllers.users.findUserById);
module.exports = router;
