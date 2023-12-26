const DB = require('../database');

const getAllTags = async (req, res) => {
    const tags = await DB.tags.getAllTags();
    res.json(tags);
}

const getTopTags = async (req, res) => {
    const tags = await DB.tags.getTopTags();
    res.json(tags);
}

module.exports = {
    getAllTags,
    getTopTags,
}