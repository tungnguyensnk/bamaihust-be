let express = require('express');
const controllers = require('../controllers');
let router = express.Router();

router.get('/all', controllers.tags.getAllTags);
router.get('/top-tags', controllers.tags.getTopTags);

module.exports = router;