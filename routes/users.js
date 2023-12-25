let express = require('express');
const controllers = require('../controllers');
let router = express.Router();

router.get('/:id', controllers.users.findUserById);

router.get('/:id/notifications', controllers.notifications.getAll);

module.exports = router;
