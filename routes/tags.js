let express = require('express');
const controllers = require('../controllers');
let router = express.Router();

router.get('/all', controllers.tags.getAllTags);

module.exports = router;