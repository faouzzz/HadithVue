'use strict'

Sequelize = require 'sequelize'
sequelize = new Sequelize 'mysql://root:www@localhost:3306/IslamVue'

DB =
  Collection: sequelize.define 'collection',
    code: Sequelize.STRING
    title_en: Sequelize.STRING
    title_ar: Sequelize.STRING

  Book: sequelize.define 'book',
    collection_code: Sequelize.STRING
    book_number: Sequelize.INTEGER
    book_id: Sequelize.FLOAT
    title_en: Sequelize.TEXT
    title_ar: Sequelize.TEXT

  HadithEnglish: sequelize.define 'englishText',
    collection_code: Sequelize.STRING
    volume_number: Sequelize.INTEGER
    book_number: Sequelize.INTEGER
    book_name: Sequelize.TEXT
    bab_number: Sequelize.INTEGER
    bab_name: Sequelize.TEXT
    hadith_number: Sequelize.INTEGER
    hadith_text: Sequelize.TEXT
    book_id: Sequelize.FLOAT
    grade_1: Sequelize.TEXT
    grade_2: Sequelize.TEXT
    hadith_number_edit: Sequelize.INTEGER

  HadithArabic: sequelize.define 'arabicText',
    collection_code: Sequelize.STRING
    volume_number: Sequelize.INTEGER
    book_number: Sequelize.INTEGER
    book_name: Sequelize.TEXT
    bab_number: Sequelize.INTEGER
    bab_name: Sequelize.TEXT
    hadith_number: Sequelize.INTEGER
    hadith_text: Sequelize.TEXT
    book_id: Sequelize.FLOAT
    grade_1: Sequelize.TEXT
    grade_2: Sequelize.TEXT
    hadith_number_edit: Sequelize.INTEGER

DB.Collection.hasMany DB.HadithEnglish
DB.HadithEnglish.belongsTo DB.Collection, foreignKey: 'collection_code'

module.exports =
  Sequelize: Sequelize
  DB: DB
