const {query} = require('./client');

const findById = async (id) => {
  const text = `SELECT *
                  FROM users
                  WHERE id = ${id}`;
  let user = (await query(text))?.rows[0];
  if(user) {
    user.reputation = (await getReputationScore(id))?.reputation;
    delete user.password;
  }
  return user;
};

const findByKeyword = async (filter) => {
  try {
    const {keyword, page, sort, limit} = filter;
    const offset = (page - 1) * limit;

    // Sắp xếp
    let orderByField;
    if (sort === 'trending') {
      // TODO: reputation
      orderByField =
          '(SELECT COUNT(*) FROM question_notifications WHERE recipientid = users.id) + (SELECT COUNT(*) FROM answer_notifications WHERE recipientid = users.id)';
    } else {
      orderByField = 'updatedat';
    }

    // Tạo điều kiện WHERE cho keyword
    let keywordCondition = '';
    if (keyword) {
      keywordCondition = `WHERE LOWER(unaccent(name)) LIKE LOWER(unaccent('%${keyword}%'))`;
    }

    // Tìm kiếm không phân biệt dấu và đếm tổng số kết quả
    const countQuery = `SELECT COUNT(*)
                        FROM users
                        ${keywordCondition}`;

    const countResult = await query(countQuery);
    const totalItems = countResult?.rows[0]?.count || 0;

    // Lấy dữ liệu trang hiện tại
    const dataQuery = `SELECT *
                       FROM users
                          ${keywordCondition}
                       ORDER BY ${orderByField} DESC
                       LIMIT ${limit} OFFSET ${offset}`;

    console.log(dataQuery);
    const result = await query(dataQuery);
    const users = result?.rows;

    if (users) {
      users.forEach((user) => {
        delete user.password;
      });
    }

    // Tính toán thông tin meta
    const totalPages = Math.ceil(totalItems / limit);
    const currentPage = page;

    const meta = {
      total: totalItems,
      totalPages,
      currentPage,
      pageSize: limit,
    };

    return {
      data: users,
      meta,
    };
  } catch (error) {
    console.error(error);
    // Handle the error and return an appropriate response
    return error;
  }
};

const getReputationScore = async (userId) => {
  const text =
      `SELECT u.id,
              u.fullname,
              (SELECT COUNT(*) -- Số câu hỏi đã viết x 10
               FROM questions q
               WHERE q.userId = u.id)
                * 10
                +
              (SELECT COUNT(*)
               FROM answers a -- Số câu trả lời đã viết x 10
               WHERE a.userId = u.id)
                * 10
                +
              (SELECT COUNT(*) -- Số like của các câu hỏi đã viết x 5
               FROM question_likes ql
                      JOIN questions q on q.id = ql.questionId
               WHERE q.userId = u.id)
                * 5
                +
              (SELECT COUNT(*) -- Số like của các câu trả lời đã viết x 5
               FROM answer_likes al
                      JOIN answers a on a.id = al.answerId
               WHERE a.userId = u.id)
                * 5
                +
              (SELECT COUNT(*) -- Số câu trả lời đc ng hỏi chấp nhận x 40
               FROM answers a
                      JOIN questions q on q.id = a.questionId
               WHERE a.userId = u.id
                 AND q.acceptedAnswerId = a.id)
                * 40
                +
              (SELECT COUNT(*) -- Số câu hỏi của bản thân được giải quyết x 10
               FROM questions q
               WHERE q.userId = u.id
                 AND q.acceptedAnswerId IS NOT NULL)
                * 10
                +
              (SELECT COUNT(*) -- Số like đã cho cho câu hỏi x 2
               FROM question_likes ql
               WHERE ql.userId = u.id)
                * 2
                +
              (SELECT COUNT(*) -- Số like đã cho cho câu trả lời x 2
               FROM answer_likes al
               WHERE al.userId = u.id)
                * 2
                AS reputation
       FROM users u
       WHERE u.id = ${userId}`;
  return (await query(text))?.rows[0];
};
module.exports = {
  findById,
  findByKeyword,
  getReputationScore,
};
