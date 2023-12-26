let express = require('express');
const controllers = require('../controllers');
let router = express.Router();
let middlewares = require('../middlewares');
let utils = require('../utils');

router.put('/:id/like', controllers.answers.createAnswerLikes);
router.post('/', middlewares.validator(utils.validator.answer), controllers.answers.createAnswer);

router.post('/:id/accept-answer', controllers.answers.acceptAnswer);

module.exports = router;