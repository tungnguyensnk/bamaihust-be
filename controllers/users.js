const DB = require('../database');

const findUserById = async (req, res) => {
    const id = req.params.id;
    const user = await DB.users.findById(id);
    if (!user) {
        return res.status(404).json({
            message: 'User not found',
        });
    }
    res.json(user);
}

module.exports = {
    findUserById,
}