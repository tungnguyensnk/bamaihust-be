const {validationResult} = require('express-validator');
const validator = (schema) => {
    return async (req, res, next) => {
        await Promise.all(schema.map((s) => s.run(req)));
        const errors = validationResult(req);
        if (errors.isEmpty()) {
            return next();
        }
        res.status(400).json({
            status: 'fail',
            errors: errors.array().map((e) => e.msg),
        });
    }
}

module.exports = validator;