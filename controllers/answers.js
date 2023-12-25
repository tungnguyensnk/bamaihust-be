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

      // Lấy thông tin user
      const user = await DB.users.findById(userId);

      // Xóa thông báo cho người viết câu trả lời
      const answer = await DB.answers.findById(answerId);
      const content = `${user.fullname} đã thích câu trả lời của bạn: ${answer.content}`;
      await DB.answerNotifications.deleteNotification(
        userId,
        answer.userid,
        answerId,
        content
      );
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
        answer.userid,
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

const createAnswer = async (req, res) => {
  const {question_id, content, is_anonymous, user_id} = req.body;

  // Lấy thông tin question
  const question = await DB.questions.findById(question_id);

  if (!question) {
    res.status(400).json({
      status: 'fail',
      message: 'Not found question',
    });
  }

  const result = await DB.answers.createAnswer(question_id, content, is_anonymous, user_id);

  if (result) {
    // Lấy thông tin user
    const user = await DB.users.findById(question.userid);

    // Tạo thông báo cho người viết câu hỏi
    const content = `${is_anonymous ? 'Ai đó' : user.fullname} đã trả lời về câu hỏi của bạn: ${question.title}`;
    await DB.questionNotifications.createQuestionNotification(user_id, question.userid, question_id, content);

    res.status(201).json({
      status: 'success',
      data: result,
      message: 'Answer created successfully',
    });
  } else {
    res.status(500).json({
      status: 'fail',
      message: 'Something went wrong',
    });
  }
};


const acceptAnswer = async (req, res) => {
  try {
    const answerid = req.params.id;
    const userId = req.body.userId;

    const answer = await DB.answers.findById(answerid);
    if (!answer?.questionid) {
      res.status(404).json({
        status: 'fail',
        message: 'Not found answer',
      });
    }

    const user = await DB.users.findById(userId);
    if (!user) {
      res.status(404).json({
        status: 'fail',
        message: 'Not found user',
      });
    }

    await DB.questions.acceptAnswer(answerid, answer.questionid)

    // Tạo thông báo cho người viết câu trả lời
    const content = `${user.fullname} đã chấp nhận câu trả lời của bạn: ${answer.content}`;
    await DB.answerNotifications.createAnswerNotification(
      userId,
      answer.userid,
      answerid,
      content
    );

    res.json({
      status: 'success',
      message: 'Câu trả lời đã được chấp nhận.',
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
  createAnswerLikes,
  createAnswer,
  acceptAnswer,
};
