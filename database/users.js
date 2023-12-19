const {query} = require('./client');

const findById = async (id) => {
  const text = `SELECT *
                  FROM users
                  WHERE id = ${id}`;
  let user = (await query(text))?.rows[0];
  delete user.password;
  return user;
};

const findByKeyword = async (filter) => {
  try {
    const {keyword, page, sortBy, limit} = filter;
    const offset = (page - 1) * limit;

    // Sắp xếp
    let orderByField = '';
    if (sortBy === 'popular') {
      // TODO: reputation
      orderByField =
        '(SELECT COUNT(*) FROM question_notifications WHERE recipientid = users.id) + (SELECT COUNT(*) FROM answer_notifications WHERE recipientid = users.id)';
    } else {
      orderByField = 'updatedat';
    }

    // Tạo điều kiện WHERE cho keyword
    let keywordCondition = '';
    if (keyword) {
      keywordCondition = `AND LOWER(unaccent(name)) LIKE LOWER(unaccent('%${keyword}%'))`;
    }

    // Tìm kiếm không phân biệt dấu và đếm tổng số kết quả
    const countQuery = `SELECT COUNT(*)
    FROM users
    WHERE 1=1
    ${keywordCondition}`;

    const countResult = await query(countQuery);
    const totalItems = countResult?.rows[0]?.count || 0;

    // Lấy dữ liệu trang hiện tại
    const dataQuery = `SELECT *
    FROM users
    WHERE 1=1
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

module.exports = {
  findById,
  findByKeyword,
};
