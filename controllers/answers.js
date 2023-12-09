const DB = require('../database');
const utils = require('../utils');

const createAnswerLikes = async (req, res) => {
  try {
    const answerId = req.params.id;
    const userId = req.body.userId;

    // Kiểm tra xem người dùng đã like câu trả lời chưa
    const existingLike = await DB.answerLikes.findAnswerLike(answerId, userId);

    if (existingLike) {
      // Nếu đã like, thực hiện unlike
      await DB.answerLikes.unlike(answerId, userId);
    } else {
      // Nếu chưa like, tạo record trong bảng answer_likes
      await DB.answerLikes.createLike(answerId, userId);
      
      // Lấy thông tin user
      const user = await DB.users.findById(userId);

      // Tạo thông báo cho người viết câu trả lời
      const answer = await DB.answers.findById(answerId);
      const content = `${user.fullname} đã thích câu trả lời của bạn: ${answer.content}`;
      await DB.answerNotifications.createAnswerNotification(
        userId,
        answer.userId,
        answerId,
        content
      );
    }

    // Lấy trường likecount trong câu trả lời
    const answer = await DB.answers.findById(answerId);

    res.json({
      status: 'success',
      likeCount: answer.likecount,
      message: existingLike ? 'You unliked the answer' : 'You liked the answer',
    });
  } catch (error) {
    res.status(500).json({
      status: 'fail',
      message: 'Something went wrong',
    });
  }
};

module.exports = {
  createAnswerLikes,
};
