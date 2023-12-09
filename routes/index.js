let express = require('express');
let router = express.Router();

let app = express();
let questionsRouter = require('./questions');
let usersRouter = require('./users');
let answersRouter = require('./answers');

/* GET home page. */
router.get('/health', (req, res) => {
    res.json({status: 'UP'});
});

router.use('/question', questionsRouter);
router.use('/user', usersRouter);
router.use('/answer', answersRouter);
module.exports = router;
