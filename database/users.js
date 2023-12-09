const {query} = require('./client');

const findById = async (id) => {
    const text = `SELECT *
                  FROM users
                  WHERE id = ${id}`;
    let user = (await query(text))?.rows[0];
    delete user.password;
    return user;
}

module.exports = {
    findById
}