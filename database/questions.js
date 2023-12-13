const {query} = require('./client');

const getAllQuestions = async () => {
    const text = 'SELECT * FROM questions';
    return (await query(text))?.rows;
}

const findById = async (id) => {
    const text = `SELECT *
                  FROM questions
                  WHERE id = ${id}`;
    return (await query(text))?.rows[0];
}

const createQuestion = async (title, content, is_anonymous, user_id) => {
    const text = `INSERT INTO questions (title, content, isanonymous, userid)
                  VALUES ('${title}', '${content}', ${is_anonymous}, ${user_id})
                  RETURNING id`;
    return await query(text);
}

const increaseViewCount = async (question_id) => {
    const text = `UPDATE questions
                  SET viewcount = viewcount + 1
                  WHERE id = ${question_id}`;
    return await query(text);
}
module.exports = {
    getAllQuestions,
    findById,
    createQuestion,
    increaseViewCount
}