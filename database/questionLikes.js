const {query} = require('./client');

const createLike = async (questionId, userId) => {
  const text = `INSERT INTO question_likes (userid, questionid)
                  VALUES ('${userId}', ${questionId})
                  RETURNING id`;
  return await query(text);
};

const findQuestionLike = async (questionId, userId) => {
  const text = `
      SELECT *
      FROM question_likes
      WHERE questionid = ${questionId} AND userid = ${userId}
    `;
  const result = await query(text);
  return result.rows[0];
};

const unlike = async (questionId, userId) => {
  const text = `
      DELETE FROM question_likes
      WHERE questionid = ${questionId} AND userid = ${userId}
    `;

  return await query(text);
};

module.exports = {
  createLike,
  unlike,
  findQuestionLike,
};
