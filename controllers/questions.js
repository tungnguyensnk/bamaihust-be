const DB = require('../database');
const utils = require('../utils');
const getAllQuestions = async (req, res) => {
    const result = await DB.questions.getAllQuestions();
    res.json(result);
}

const getQuestionById = async (req, res) => {
    const id = req.params.id;
    const question = await DB.questions.getQuestionById(id);
    if (!question) {
        return res.status(404).json({
            message: 'Question not found'
        });
    }

    await DB.questions.increaseViewCount(id);
    question.author = utils.minInfo.user(await DB.users.getUserById(question.userid));
    question.tags = await DB.tags.getTagsByQuestionId(id);
    question.answers = await DB.answers.getAnswersByQuestionId(id);
    for (let answer of question.answers) {
        answer.user = utils.minInfo.user(await DB.users.getUserById(answer.userid));
        answer.is_accepted = question.acceptedanswerid === answer.id;
        answer.diem_danh_gia = answer.likecount;
    }
    delete question.userid;
    res.json(question);
}

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
            'question_id': question_id,
            message: 'Question created successfully'
        });
    } else {
        res.status(500).json({
            status: 'fail',
            message: 'Something went wrong'
        });
    }
}

module.exports = {
    getAllQuestions,
    getQuestionById,
    createQuestion
}