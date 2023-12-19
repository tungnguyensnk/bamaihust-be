let express = require('express');
let router = express.Router();

let app = express();
let questionsRouter = require('./questions');
let usersRouter = require('./users');
let answersRouter = require('./answers');
let searchRouter = require('./search');
let tagsRouter = require('./tags');
/* GET home page. */
router.get('/', (req, res) => {
    res.json({status: 'healthy'});
});

router.use('/question', questionsRouter);
router.use('/user', usersRouter);
router.use('/answer', answersRouter);
router.use('/search', searchRouter);
router.use('/tag', tagsRouter);

module.exports = router;
