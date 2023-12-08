const {Client} = require('pg')
const client = new Client({
    host: process.env.DB_HOST || 'localhost',
    port: process.env.DB_PORT || 5432,
    user: process.env.DB_USERNAME || 'postgres',
    password: process.env.POSTGRES_PASSWORD || 'itss@123',
    database: process.env.POSTGRES_DB || 'itss'
});

const query = async (text) => {
    try {
        const query = {
            text: text
        }
        return await client.query(query);
    } catch (e) {
        console.log(e);
        return null;
    }
}
module.exports = {client, query};