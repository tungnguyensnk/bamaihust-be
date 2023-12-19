let express = require('express');
const controllers = require('../controllers');
let router = express.Router();
let middlewares = require('../middlewares');
let utils = require('../utils');

router.get('/', middlewares.validator(utils.validator.search), controllers.search.searchAndFilter);

module.exports = router;