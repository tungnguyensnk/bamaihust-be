const {query} = require('./client');

const createQuestionNotification = async (senderid, recipientid, questionid, content) => {
  const text = `INSERT INTO question_notifications (senderid, recipientid, questionid, content)
    VALUES (${senderid}, ${recipientid}, ${questionid}, '${content}')
    RETURNING *`;
    console.log(text);
  return await query(text);
};

module.exports = {
    createQuestionNotification,
};
