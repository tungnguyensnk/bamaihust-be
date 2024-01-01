const {check} = require('express-validator');

const question = [
    check('title')
        .exists().withMessage('Title is required')
        .isLength({max: 255}).withMessage('Title must be less than 255 characters'),
    check('tags')
        .exists().withMessage('Tags is required')
        .isArray({min: 1, max: 5}).withMessage('Tags must be an array with length from 1 to 5'),
    check('content')
        .exists().withMessage('Content is required')
        .isLength({max: 40000}).withMessage('Content must be less than 40000 characters'),
    check('is_anonymous')
        .isIn([0, 1]).withMessage('is_anonymous must be 0 or 1'),
];

const answer = [
    check('user_id')
        .exists().withMessage('User ID is required')
        .isLength({ max: 255 }).withMessage('User ID must be less than 255 characters'),
  
    check('question_id')
        .exists().withMessage('Question ID is required')
        .isLength({ max: 255 }).withMessage('Question ID must be less than 255 characters'),
  
    check('content')
        .exists().withMessage('Content is required')
        .isLength({ max: 40000 }).withMessage('Content must be less than 40000 characters'),
  
    check('is_anonymous')
        .isIn([0, 1]).withMessage('is_anonymous must be 0 or 1'),
];

const search = [
    check('objectType')
        .exists().isIn(['user', 'question']).withMessage('Object type must be user or question'),

    check('tags')
        .isArray().withMessage('Tags must be an array')
        .optional()
        .isArray({ max: 5 }).withMessage('Tags array should have at most 5 elements'),

    check('status')
        .optional()
        .isIn(['all', 'solved', 'not resolved']).withMessage('Status should be one of: all, solved, not resolved'),

    check('sort')
        .optional()
        .isIn(['trending', 'newest']).withMessage('Sort should be one of: trending, newest'),

    check('page')
        .optional()
        .isInt({min: 1})
        .isNumeric().withMessage('Page should be a number'),
]

const mainPage = [
    check('numberOfPage')
        .optional()
        .isInt({min: 1}).withMessage('numberOfPage must be an integer greater than 0'),
    check('pageSize')
        .optional()
        .isInt({min: 1}).withMessage('pageSize must be an integer greater than 0'),
    check('sort')
        .optional()
        .isIn(['newest', 'trending']).withMessage('sort must be \'newest\' or \'trending\''),
];

const acceptAnswer = [
    check('userId')
        .exists()
        .withMessage('User ID is required')
        .isInt()
        .withMessage('User ID must be a number'),
];

const likeAnswer = [
    check('userId')
        .exists()
        .withMessage('User ID is required')
        .isInt()
        .withMessage('User ID must be a number'),
];

const likeQuestion = [
    check('userId')
        .exists()
        .withMessage('User ID is required')
        .isInt()
        .withMessage('User ID must be a number'),
];

const notification = [check('page').optional().isInt({min: 1}).isNumeric().withMessage('Page should be a number')];

module.exports = {
    question,
    answer,
    search,
    mainPage,
    acceptAnswer,
    likeAnswer,
    likeQuestion,
    notification,
};
