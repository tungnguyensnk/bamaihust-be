let express = require('express');
const controllers = require('../controllers');
let router = express.Router();

router.get('/:id', controllers.users.findUserById);

router.get('/:id/notifications', controllers.notifications.getAll);

router.put('/:id/notifications/read', controllers.notifications.readAll);

module.exports = router;
