const DB = require('../database');

const getAllTags = async (req, res) => {
    const tags = await DB.tags.getAllTags();
    res.json(tags);
}

module.exports = {
    getAllTags,
}