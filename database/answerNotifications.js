const {query} = require('./client');

const createAnswerNotification = async (senderid, recipientid, answerid, content) => {
  const text = ` INSERT INTO answer_notifications (senderid, recipientid, answerid, content)
    VALUES (${senderid}, ${recipientid}, ${answerid}, ${content})
    RETURNING *`;
  return await query(text);
};

module.exports = {
    createAnswerNotification,
};
