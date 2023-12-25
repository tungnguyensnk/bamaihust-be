const DB = require('../database');
const utils = require('../utils');
const getAllQuestions = async (req, res) => {
    let {numberOfPage, pageSize, sort} = req.query;
    numberOfPage??=1;
    pageSize ??= 10;
    sort ??= 'trending';
    let result;
    switch (sort) {
        case 'newest':
            result = await DB.questions.getAllByNewest(numberOfPage, pageSize);
            break;
        case 'trending':
        default:
            result = await DB.questions.getAllByTrending(numberOfPage, pageSize);
            break;
    }
    if (result) {
        for (let question of result) {
            question.author = utils.minInfo.user(await DB.users.findById(question.userid));
            question.tags = await DB.tags.getTagsByQuestionId(question.id);
            delete question.userid;
        }
        res.json({
            status: 'success',
            numberOfPage: numberOfPage,
            pageSize: pageSize,
            sort: sort,
            questions: result,
        });
    } else {
        res.status(500).json({
            status: 'fail',
            message: 'Something went wrong',
        });
    }
};

const getQuestionById = async (req, res) => {
  const id = req.params.id;
  const question = await DB.questions.findById(id);
  if (!question) {
    return res.status(404).json({
      message: 'Question not found',
    });
  }

  await DB.questions.increaseViewCount(id);
  question.author = utils.minInfo.user(await DB.users.findById(question.userid));
  question.tags = await DB.tags.getTagsByQuestionId(id);
  question.answers = await DB.answers.getAnswersByQuestionId(id);
  for (let answer of question.answers) {
    answer.user = utils.minInfo.user(await DB.users.findById(answer.userid));
    answer.is_accepted = question.acceptedanswerid === answer.id;
    answer.diem_danh_gia = answer.likecount;
  }
  delete question.userid;
  res.json(question);
};

const createQuestion = async (req, res) => {
  const {title, content, is_anonymous, tags, user_id} = req.body;
  const result = await DB.questions.createQuestion(title, content, is_anonymous, user_id);
  if (result) {
    let question_id = result.rows[0].id;
    for (let tag of tags) {
      let tag_id = (await DB.tags.createTag(tag)).rows[0].id;
      await DB.tags.mapTagToQuestion(tag_id, question_id);
    }
    res.status(201).json({
      status: 'success',
      question_id: question_id,
      message: 'Question created successfully',
    });
  } else {
    res.status(500).json({
      status: 'fail',
      message: 'Something went wrong',
    });
  }
};

const createQuestionLikes = async (req, res) => {
  try {
    const questionId = req.params.id;
    const userId = req.body.userId;

    // Kiểm tra xem người dùng đã like câu hỏi chưa
    const existingLike = await DB.questionLikes.findQuestionLike(questionId, userId);

    if (existingLike) {
      // Nếu đã like, thực hiện unlike
      await DB.questionLikes.unlike(questionId, userId);
      
      // Lấy thông tin user
      const user = await DB.users.findById(userId);

      // Xóa thông báo cho người viết câu hỏi
      const question = await DB.questions.findById(questionId);
      const content = `${user.fullname} đã thích câu hỏi của bạn: ${question.content}`;
      await DB.questionNotifications.deleteNotification(
        userId,
        question.userid,
        questionId,
        content
      );
    } else {
      // Nếu chưa like, tạo record trong bảng question_likes
      await DB.questionLikes.createLike(questionId, userId);

      // Lấy thông tin user
      const user = await DB.users.findById(userId);

      // Tạo thông báo cho người viết câu hỏi
      const question = await DB.questions.findById(questionId);
      const content = `${user.fullname} đã thích câu hỏi của bạn: ${question.content}`;
      await DB.questionNotifications.createQuestionNotification(
        userId,
        question.userid,
        questionId,
        content
      );
    }

    // Lấy trường likecount trong câu hỏi
    const question = await DB.questions.findById(questionId);

    res.json({
      status: 'success',
      likeCount: question.likecount,
      message: existingLike ? 'You unliked the question' : 'You liked the question',
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
    getAllQuestions,
    getQuestionById,
    createQuestion,
    createQuestionLikes
};
