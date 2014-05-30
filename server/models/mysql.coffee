'use strict'

Sequelize = require 'sequelize'
sequelize = new Sequelize 'mysql://root:www@localhost:3306/IslamVue'

DB =
  Collection: sequelize.define 'collection',
    code: Sequelize.STRING
    title_en: Sequelize.STRING
    title_ar: Sequelize.STRING
  ,
    timestamps: false,
    underscored: true

  Book: sequelize.define 'book',
    collection_id: Sequelize.INTEGER
    collection_code: Sequelize.STRING
    book_number: Sequelize.INTEGER
    book_id: Sequelize.FLOAT
    title_en: Sequelize.TEXT
    title_ar: Sequelize.TEXT
  ,
    timestamps: false,
    underscored: true

  HadithEnglish: sequelize.define 'englishText',
    collection_id: Sequelize.INTEGER
    collection_code: Sequelize.STRING
    volume_number: Sequelize.INTEGER
    book_number: Sequelize.INTEGER
    book_id: Sequelize.STRING
    book_name: Sequelize.TEXT
    bab_number: Sequelize.INTEGER
    bab_name: Sequelize.TEXT
    hadith_number: Sequelize.INTEGER
    hadith_text: Sequelize.TEXT
    grade_1: Sequelize.TEXT
    grade_2: Sequelize.TEXT
    hadith_number_edit: Sequelize.INTEGER
  ,
    timestamps: false,
    underscored: true

  HadithArabic: sequelize.define 'arabicText',
    collection_id: Sequelize.INTEGER
    collection_code: Sequelize.STRING
    volume_number: Sequelize.INTEGER
    book_number: Sequelize.INTEGER
    book_id: Sequelize.INTEGER
    book_name: Sequelize.TEXT
    bab_number: Sequelize.INTEGER
    bab_name: Sequelize.TEXT
    hadith_number: Sequelize.INTEGER
    hadith_text: Sequelize.TEXT
    grade_1: Sequelize.TEXT
    grade_2: Sequelize.TEXT
    hadith_number_edit: Sequelize.INTEGER
  ,
    timestamps: false,
    underscored: true

DB.Collection.hasMany DB.HadithEnglish
DB.HadithEnglish.belongsTo DB.Collection, foreignKey: 'collection_id'

module.exports =
  Sequelize: Sequelize
  DB: DB
