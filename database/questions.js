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
  const countText = `
    SELECT COUNT(*) AS totalQuestions
    FROM questions q
  `;
  const totalCount = (await query(countText)).rows[0].totalQuestions;
  const totalPages = Math.ceil(totalCount / pageSize);
  return totalPages;
};

const searchAndFilter = async (filter) => {
  try {
    const {keyword, tags, status, sortBy, page, limit} = filter;
    const offset = (page - 1) * limit;

    // Sắp xếp
    let orderByField = '';
    if (sortBy === 'popular') {
      orderByField = `
    (SELECT COUNT(*) FROM question_notifications WHERE questionid = questions.id) +
    (SELECT COUNT(*) FROM answer_notifications 
      JOIN answers ON answer_notifications.answerid = answers.id
      WHERE answers.questionid = questions.id)
  `;
    } else {
      orderByField = 'updatedat';
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
      tagsCondition = `
      AND questions.id IN (
        SELECT questionid
        FROM question_tag
        WHERE tagid IN (SELECT id FROM tags WHERE tagname IN (${tags
          .map((tag) => `'${tag}'`)
          .join(', ')}))
      )
    `;
    }

    // Tạo điều kiện WHERE cho keyword
    let keywordCondition = '';
    if (keyword) {
      keywordCondition = `AND ((LOWER(unaccent(title)) LIKE LOWER(unaccent('%${keyword}%')) OR LOWER(unaccent(content)) LIKE LOWER(unaccent('%${keyword}%'))))`;
    }

    // Tìm kiếm không phân biệt dấu và đếm tổng số kết quả
    const countQuery = `SELECT COUNT(*)
                      FROM questions
                      WHERE 1 = 1
                      ${keywordCondition}
                      ${tagsCondition}
                      ${statusCondition}`;

    const countResult = await query(countQuery);
    const totalItems = countResult?.rows[0]?.count || 0;

    // Lấy dữ liệu trang hiện tại và thêm thông tin về số câu trả lời và danh sách tags
    const dataQuery = `
    SELECT questions.*, 
      users.fullname as author_fullname,
      users.avatarurl as author_avatar,
      (SELECT COUNT(*) FROM answers WHERE answers.questionid = questions.id) as answercount,
      (
        SELECT JSONB_AGG(
            JSONB_BUILD_OBJECT(
                'tagname', tags.tagname,
                'color', tags.color
            )
        )
        FROM question_tag
        JOIN tags ON question_tag.tagid = tags.id
        WHERE question_tag.questionid = questions.id
      ) as tags
    FROM questions
    LEFT JOIN users ON questions.userid = users.id
    WHERE 1 = 1
    ${keywordCondition}
    ${tagsCondition}
    ${statusCondition}
    ORDER BY ${orderByField} DESC
    LIMIT ${limit} OFFSET ${offset}
  `;

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
};
