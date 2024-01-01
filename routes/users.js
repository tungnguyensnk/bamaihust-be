let express = require('express');
const controllers = require('../controllers');
let middlewares = require('../middlewares');
let utils = require('../utils');
let router = express.Router();

router.get('/:id', controllers.users.findUserById);

router.get('/:id/notifications', middlewares.validator(utils.validator.notification), controllers.notifications.getAll);

router.put('/:id/notifications/read', controllers.notifications.readAll);

module.exports = router;
