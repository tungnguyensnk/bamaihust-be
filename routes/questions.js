let express = require('express');
const controllers = require('../controllers');
let router = express.Router();
let middlewares = require('../middlewares');
let utils = require('../utils');

router.get('/all', middlewares.validator(utils.validator.mainPage), controllers.questions.getAllQuestions);
router.get('/:id', controllers.questions.getQuestionById);
router.post('/create', middlewares.validator(utils.validator.question), controllers.questions.createQuestion);

router.put('/:id/like', controllers.questions.createQuestionLikes);

module.exports = router;
