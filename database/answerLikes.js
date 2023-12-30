const {query} = require('./client');

const createLike = async (answerId, userId) => {
  const text = `INSERT INTO answer_likes (userid, answerid)
                  VALUES ('${userId}', ${answerId})
                  RETURNING id`;
  return await query(text);
};

const findAnswerLike = async (answerId, userId) => {
  const text = `
        SELECT *
        FROM answer_likes
        WHERE answerid = ${answerId} AND userid = ${userId}
      `;
  const result = await query(text);
  return result.rows[0];
};

const unlike = async (answerId, userId) => {
  const text = `
        DELETE FROM answer_likes
        WHERE answerid = ${answerId} AND userid = ${userId}
      `;

  return await query(text);
};

module.exports = {
  createLike,
  unlike,
  findAnswerLike,
};
