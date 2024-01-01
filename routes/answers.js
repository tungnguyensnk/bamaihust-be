let express = require('express');
const controllers = require('../controllers');
let router = express.Router();
let middlewares = require('../middlewares');
let utils = require('../utils');

router.put('/:id/like', middlewares.validator(utils.validator.likeAnswer), controllers.answers.createAnswerLikes);
router.post('/', middlewares.validator(utils.validator.answer), controllers.answers.createAnswer);

router.post('/:id/accept-answer', middlewares.validator(utils.validator.acceptAnswer), controllers.answers.acceptAnswer);

module.exports = router;