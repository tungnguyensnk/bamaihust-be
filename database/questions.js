const {query} = require('./client');

const getAllQuestions = async () => {
  const text = 'SELECT * FROM questions';
  return (await query(text))?.rows;
};

const findById = async (id) => {
  const text = `SELECT *
                  FROM questions
                  WHERE id = ${id}`;
  return (await query(text))?.rows[0];
};

const createQuestion = async (title, content, is_anonymous, user_id) => {
  const text = `INSERT INTO questions (title, content, isanonymous, userid)
                  VALUES ('${title}', '${content}', ${is_anonymous}, ${user_id})
                  RETURNING id`;
  return await query(text);
};

const increaseViewCount = async (question_id) => {
  const text = `UPDATE questions
                  SET viewcount = viewcount + 1
                  WHERE id = ${question_id}`;
  return await query(text);
};

const getAllByTrending = async (numberOfPage, pageSize) => {
  const text = `SELECT q.*,
                       (SELECT COUNT(*)
                        FROM question_notifications qn
                        WHERE qn.questionId = q.id)
                           +
                       (SELECT COUNT(*)
                        FROM answer_notifications an
                                 JOIN answers a on a.id = an.answerId
                        WHERE a.questionId = q.id) AS score,
                       (SELECT COUNT(*)
                        FROM answers a
                        WHERE a.questionId = q.id) AS answercount
                FROM questions q
                ORDER BY score DESC, q.id DESC
                LIMIT ${pageSize} OFFSET ${(numberOfPage - 1) * pageSize}`;
  return (await query(text))?.rows;
};

const getAllByNewest = async (numberOfPage, pageSize) => {
  const text = `SELECT questions.*,
                            (SELECT COUNT(*)
                            FROM answers
                            WHERE answers.questionid = questions.id) AS answercount
                FROM questions
                ORDER BY id DESC
                LIMIT ${pageSize} OFFSET ${(numberOfPage - 1) * pageSize}`;
  return (await query(text))?.rows;
};

const getTotalPages = async (pageSize) => {
  const text = `SELECT CEIL(COUNT(*)::NUMERIC / ${pageSize}) AS totalpages
                    FROM questions`;
  return (await query(text))?.rows[0]?.totalpages;
};

const searchAndFilter = async (filter) => {
  try {
    const {keyword, tags, status, sort, page, limit} = filter;
    const offset = (page - 1) * limit;

    // Sắp xếp
    let orderByField = '';
    if (sort === 'trending') {
      orderByField = 'notification_count';
    } else {
      orderByField = 'questions.updatedat';
    }

    // Tạo điều kiện WHERE cho trạng thái
    let statusCondition = '';
    if (status === 'solved') {
      statusCondition = 'AND acceptedanswerid IS NOT NULL';
    } else if (status === 'not resolved') {
      statusCondition = 'AND acceptedanswerid IS NULL';
    }

    // Tạo điều kiện WHERE cho tags
    let tagsCondition = '';
    if (tags && tags.length > 0) {
      tagsCondition = `AND tags.tagname IN (${tags.map((tag) => `'${tag}'`).join(', ')})`;
    }

    // Tạo điều kiện WHERE cho keyword
    let keywordCondition = '';
    if (keyword) {
      keywordCondition = `AND ((LOWER(unaccent(title)) LIKE LOWER(unaccent('%${keyword}%')) OR LOWER(unaccent(content)) LIKE LOWER(unaccent('%${keyword}%'))))`;
    }

    // Tìm kiếm không phân biệt dấu và đếm tổng số kết quả
    const countQuery = `SELECT COUNT(*) FROM (SELECT DISTINCT questions.id
      FROM questions
      JOIN question_tag ON questions.id = question_tag.questionid
      JOIN tags ON question_tag.tagid = tags.id
      WHERE 1 = 1
      ${keywordCondition}
      ${tagsCondition}
      ${statusCondition}
      ${
        tagsCondition
          ? `GROUP BY questions.id
        HAVING COUNT(DISTINCT tags.tagname) = ${tags.length}`
          : ''
      }) as subquery`;

    const countResult = await query(countQuery);
    const totalItems = parseInt(countResult?.rows[0]?.count) || 0;

    // Lấy dữ liệu trang hiện tại và thêm thông tin về số câu trả lời và danh sách tags
    const dataQuery = `
    SELECT DISTINCT questions.*, 
      (
        SELECT JSONB_AGG(
            JSONB_BUILD_OBJECT(
                'id', users.id,
                'fullname', users.fullname,
                'avatarurl', users.avatarurl
            )
        )
        FROM users
        WHERE questions.userid = users.id
      ) as author,
      (SELECT COUNT(*) FROM answers WHERE answers.questionid = questions.id) as answercount,
      (
        SELECT JSONB_AGG(
            JSONB_BUILD_OBJECT(
                'id', tags.id,
                'tagname', tags.tagname,
                'color', tags.color
            )
        )
        FROM question_tag
        JOIN tags ON question_tag.tagid = tags.id
        WHERE question_tag.questionid = questions.id
      ) as tags,
      (SELECT COUNT(*) FROM question_notifications WHERE questionid = questions.id) +
      (SELECT COUNT(*)
      FROM answer_notifications
                JOIN answers ON answer_notifications.answerid = answers.id
      WHERE answers.questionid = questions.id) as notification_count
    FROM questions
    LEFT JOIN users ON questions.userid = users.id
    JOIN question_tag ON questions.id = question_tag.questionid
    JOIN tags ON question_tag.tagid = tags.id
    WHERE 1 = 1
    ${keywordCondition}
    ${tagsCondition}
    ${statusCondition}
    ${
      tagsCondition
        ? `GROUP BY questions.id, questions.updatedat
      HAVING COUNT(DISTINCT tags.tagname) = ${tags.length}`
        : ''
    }
    ORDER BY ${orderByField} DESC
    LIMIT ${limit} OFFSET ${offset}
  `;

    console.log(dataQuery);
    const result = await query(dataQuery);
    const questions = result?.rows;

    // Tính toán thông tin meta
    const totalPages = Math.ceil(totalItems / limit);
    const currentPage = page;

    const meta = {
      totalItems,
      totalPages,
      currentPage,
      pageSize: limit,
    };

    return {
      data: questions,
      meta,
    };
  } catch (error) {
    console.error(error);
    // Handle the error and return an appropriate response
    return error;
  }
};

const acceptAnswer = async (answerId, questionId) => {
  const text = `UPDATE questions
  SET acceptedanswerid = ${answerId}
  WHERE id = ${questionId}`;
  return (await query(text))?.rows;
};

const isLiked = async (questionId, userId) => {
  const text = `SELECT *
    FROM question_likes
    WHERE questionid = ${questionId} AND userid = ${userId}`;
  return (await query(text))?.rows[0];
};

module.exports = {
  getAllQuestions,
  findById,
  createQuestion,
  increaseViewCount,
  searchAndFilter,
  getAllByTrending,
  getAllByNewest,
  acceptAnswer,
  getTotalPages,
  isLiked,
};
