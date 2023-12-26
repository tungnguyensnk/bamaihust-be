const DB = require('../database');

const getAll = async (req, res) => {
  try {
    const userid = req.params.id;
    const {page} = req.query;
    const limit = 10;

    const notifications = await DB.questionNotifications.getNotifications(userid, page ?? 1, limit);

    return res.status(200).json({
      status: 'success',
      message: 'Search results were successfully',
      data: notifications,
    });

  } catch (error) {
    console.log(error.message);
    res.status(500).json({
      status: 'fail',
      message: 'Something went wrong',
    });
  }
};

module.exports = {
  getAll,
};
