const {vi, en, Faker} = require('@faker-js/faker');
const faker = new Faker({locale: [vi, en]});
const date = require('date-and-time')
const {client, query} = require('./index');

const TOTAL = 100;
const randomUser = async () => {
    return {
        "fullName": faker.person.fullName(),
        "password": faker.internet.password(),
        "email": faker.internet.email(),
        "reputation": faker.number.int({min: 0, max: 100}),
        "gender": faker.number.int({min: 0, max: 1}),
        // date timestamp
        dateOfBirth: date.format(faker.date.past(), 'YYYY-MM-DD HH:mm:ss'),
        avatarUrl: faker.image.avatar(),
        studentID: faker.number.int({min: 20140000, max: 20239999}),
        class: faker.lorem.word(),
        school: faker.lorem.word(),
        schoolYear: faker.lorem.word(),
        aboutMe: faker.lorem.paragraph(),
        isPublic: faker.number.int({min: 0, max: 1}),
    }
}

const randomQuestion = async () => {
    return {
        title: faker.lorem.sentence(),
        content: faker.lorem.paragraph(),
        isAnonymous: faker.number.int({min: 0, max: 1}),
        viewCount: faker.number.int({min: 0, max: 100}),
        likeCount: 0,
        userId: faker.number.int({min: 1, max: 100}),
        acceptedAnswerId: null,
        createdAt: date.format(faker.date.past(), 'YYYY-MM-DD HH:mm:ss')
    }
}

const randomAnswer = async () => {
    return {
        content: faker.lorem.paragraph(),
        isAnonymous: faker.number.int({min: 0, max: 1}),
        likeCount: 0,
        userId: faker.number.int({min: 1, max: 100}),
        questionId: faker.number.int({min: 1, max: 100}),
        createdAt: date.format(faker.date.past(), 'YYYY-MM-DD HH:mm:ss')
    }
}

const randomTag = async () => {
    return {
        tagName: faker.lorem.word(),
        count: faker.number.int({min: 0, max: 100}),
        color: faker.internet.color()
    }
}

const randomQuestionTag = async () => {
    return {
        questionId: faker.number.int({min: 1, max: 100}),
        tagId: faker.number.int({min: 1, max: 100})
    }
}

const seed = async () => {
    // seed users
    for (let i = 0; i < TOTAL; i++) {
        let user = await randomUser();
        await query(`INSERT INTO users (fullname, password, email, reputation, gender, dateofbirth, avatarurl,
                                        studentid, class, school, schoolyear, aboutme, ispublic)
                     VALUES ('${user.fullName}', '${user.password}', '${user.email}', ${user.reputation},
                             ${user.gender}, '${user.dateOfBirth}', '${user.avatarUrl}', ${user.studentID},
                             '${user.class}', '${user.school}', '${user.schoolYear}', '${user.aboutMe}',
                             ${user.isPublic})`);

    }
    // seed questions
    for (let i = 0; i < TOTAL; i++) {
        let question = await randomQuestion();
        await query(`INSERT INTO questions (title, content, isanonymous, viewcount, likecount, userid, acceptedanswerid, createdat)
                     VALUES ('${question.title}', '${question.content}', ${question.isAnonymous}, ${question.viewCount},
                             ${question.likeCount}, ${question.userId}, ${question.acceptedAnswerId}, '${question.createdAt}')`);
    }
    // seed answers
    for (let i = 0; i < TOTAL; i++) {
        let answer = await randomAnswer();
        await query(`INSERT INTO answers (content, isanonymous, likecount, userid, questionid, createdat)
                     VALUES ('${answer.content}', ${answer.isAnonymous}, ${answer.likeCount}, ${answer.userId},
                             ${answer.questionId}, '${answer.createdAt}')`);
    }
    // seed tags
    for (let i = 0; i < TOTAL; i++) {
        let tag = await randomTag();
        await query(`INSERT INTO tags (tagname, count, color)
                     VALUES ('${tag.tagName}', ${tag.count}, '${tag.color}')`);
    }
}

(async () => {
    console.log('Seeding data...');
    await client.connect();
    // remove all data
    await query(`DELETE FROM answers`);
    await query(`DELETE FROM questions`);
    await query(`DELETE FROM users`);
    await query(`DELETE FROM tags`);

    // reset auto increment
    await query(`TRUNCATE users RESTART IDENTITY CASCADE;`);
    await query(`TRUNCATE questions RESTART IDENTITY CASCADE;`);
    await query(`TRUNCATE answers RESTART IDENTITY CASCADE;`);
    await query(`TRUNCATE tags RESTART IDENTITY CASCADE;`);

    // seed data
    await seed();
    client.end();
    console.log('Seeding data done!');
})()