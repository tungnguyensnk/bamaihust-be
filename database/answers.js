const {query} = require('./client');

const getAnswersByQuestionId = async (question_id) => {
    const text = `SELECT *
                  FROM answers
                  WHERE questionid = ${question_id}`;
    return (await query(text)).rows;
}

module.exports = {
    getAnswersByQuestionId
}