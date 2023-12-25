const {query} = require('./client');

const createAnswerNotification = async (senderid, recipientid, answerid, content) => {
  const text = ` INSERT INTO answer_notifications (senderid, recipientid, answerid, content)
    VALUES (${senderid}, ${recipientid}, ${answerid}, ${content})
    RETURNING *`;
  return await query(text);
};

const deleteNotification = async (senderid, recipientid, answerid, content) => {
  const text = `
    DELETE FROM answer_notifications
    WHERE answerid = ${answerid} AND senderid = ${senderid} AND recipientid = ${recipientid} AND content = '${content}'
  `;

  return await query(text);
};

module.exports = {
  createAnswerNotification,
  deleteNotification,
};
