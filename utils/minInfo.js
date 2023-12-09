const user = user => {
    return {
        id: user.id,
        fullname: user.fullname,
        email: user.email,
        gender: user.gender,
        avatarurl: user.avatarurl,
        ispublic: user.ispublic
    }
}

module.exports = {
    user
}