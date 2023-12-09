let express = require('express');
const controllers = require('../controllers');
let router = express.Router();
let middlewares = require('../middlewares');
let utils = require('../utils');

router.put('/:id/like', controllers.answers.createAnswerLikes);

module.exports = router;