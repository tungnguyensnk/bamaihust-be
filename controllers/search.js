const DB = require('../database');

const searchAndFilter = async (req, res) => {
  try {
    let data;
    const {keyword, objectType, tags, status, sort, page} = req.query;
    const limit = 5;

    // Thiết lập giá trị mặc định
    const defaultStatus = 'all';
    const defaultPage = 1;
    const defaultSort = 'newest';

    // Áp dụng giá trị mặc định nếu không được cung cấp
    const filter = {
      keyword,
      objectType,
      tags,
      status: status || defaultStatus,
      sort: sort || defaultSort,
      page: page ? parseInt(page) : defaultPage,
      limit,
    };

    if (objectType === 'question') {
      data = await DB.questions.searchAndFilter(filter);
    } else if (objectType === 'user') {
      data = await DB.users.findByKeyword(filter);
    } else {
      // Xử lý khi objectType không hợp lệ
      res.status(400).json({
        status: 'fail',
        message: 'Invalid objectType specified',
      });
      return;
    }

    if (data) {
      res.status(200).json({
        status: 'success',
        message: 'Search results were successfully',
        data: data,
      });
    } else {
      res.status(500).json({
        status: 'fail',
        message: 'Something went wrong',
      });
    }
  } catch (error) {
    console.error(error);
    res.status(500).json({message: 'Internal Server Error'});
  }
};

module.exports = {
  searchAndFilter,
};
