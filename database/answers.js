const {query} = require('./client');

const getAnswersByQuestionId = async (question_id) => {
    const text = `SELECT *
                  FROM answers
                  WHERE questionid = ${question_id}`;
    return (await query(text)).rows;
}

const findById = async (id) => {
    const text = `SELECT *
                  FROM answers
                  WHERE id = ${id}`;
    return (await query(text)).rows[0];
}

module.exports = {
    getAnswersByQuestionId,
    findById,
}