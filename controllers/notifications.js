const DB = require('../database');

const getAll = async (req, res) => {
  try {
    const userid = req.params.id;
    const {page} = req.query;
    const limit = 10;

    const notifications = await DB.questionNotifications.getNotifications(userid, page ?? 1, limit);

    return res.status(200).json({
      status: 'success',
      message: 'Notifications retrieved successfully',
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

const readAll = async (req, res) => {
  try {
    const userid = req.params.id;

    await DB.questionNotifications.readAllNotifications(userid);

    return res.status(200).json({
      status: 'success',
      message: 'Marked all notifications as read for the user.',
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
  readAll,
};
