const {query} = require('./client');

const createQuestionNotification = async (senderid, recipientid, questionid, content) => {
  const text = `INSERT INTO question_notifications (senderid, recipientid, questionid, content)
    VALUES (${senderid}, ${recipientid}, ${questionid}, '${content}')
    RETURNING *`;
  return await query(text);
};

const deleteNotification = async (senderid, recipientid, questionid, content) => {
  const text = `
      DELETE FROM question_notifications
      WHERE questionid = ${questionid} AND senderid = ${senderid} AND recipientid = ${recipientid} AND content = '${content}'
    `;
  console.log(text);
  return await query(text);
};

const getNotifications = async (userid, page, limit) => {
  const offset = (page - 1) * limit;

  const countQuery = `
    SELECT 
      COALESCE(answer_count, 0) + COALESCE(question_count, 0) AS count
    FROM (
      SELECT
          (SELECT COUNT(*) FROM answer_notifications WHERE recipientid = ${userid}) AS answer_count,
          (SELECT COUNT(*) FROM question_notifications WHERE recipientid =  ${userid}) AS question_count
    ) AS counts;
  `;

  const countResult = await query(countQuery);
  const totalItems = countResult?.rows[0]?.count || 0;

  const dataQuery = `
      SELECT
          id,
          senderid,
          recipientid,
          answerid AS relatedid,
          url,
          content,
          hasread,
          createdat
      FROM
          answer_notifications
      WHERE
          recipientid = ${userid}
      UNION
      SELECT
          id,
          senderid,
          recipientid,
          questionid AS relatedid,
          url,
          content,
          hasread,
          createdat
      FROM
          question_notifications
      WHERE
          recipientid = ${userid}
      ORDER BY
          createdat DESC
      OFFSET ${offset} LIMIT ${limit};`;

  const result = await query(dataQuery);
  const notifications = result?.rows;

  const totalPages = Math.ceil(totalItems / limit);
  const currentPage = page;

  const meta = {
    totalItems,
    totalPages,
    currentPage,
    pageSize: limit,
  };

  return {
    data: notifications,
    meta,
  };
};

const readAllNotifications = async (userid) => {
  const questionQuery = `UPDATE question_notifications SET hasread = 1 WHERE recipientid = ${userid}`;
  const answerQuery = `UPDATE question_notifications SET hasread = 1 WHERE recipientid = ${userid}`;

  await query(questionQuery);
  await query(answerQuery);
};

module.exports = {
  createQuestionNotification,
  deleteNotification,
  getNotifications,
  readAllNotifications,
};
