const {query} = require('./client');
const utils = require('../utils');
const getTagsByQuestionId = async (question_id) => {
    const text = `SELECT *
                  FROM tags
                  WHERE id IN (SELECT tagid
                               FROM question_tag
                               WHERE questionid = ${question_id})`;
    return (await query(text)).rows;
}

const createTag = async (tag) => {
    const text = `INSERT INTO tags (tagname, color)
                  VALUES ('${tag}', '${utils.random.color()}')
                  ON CONFLICT (tagname) DO UPDATE SET tagname = '${tag}'
                  RETURNING id`;
    return await query(text);
}

const mapTagToQuestion = async (tag_id, question_id) => {
    const text = `INSERT INTO question_tag (questionid, tagid)
                  VALUES (${question_id}, ${tag_id})`;
    return await query(text);
}

const getAllTags = async () => {
    const text = `SELECT * FROM tags`;
    return (await query(text)).rows;
}
module.exports = {
    getTagsByQuestionId,
    createTag,
    mapTagToQuestion,
    getAllTags,
}