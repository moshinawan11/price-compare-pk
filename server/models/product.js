const { Sequelize, DataTypes } = require('sequelize');
const sequelize = require('../app.js');

const Product = sequelize.define('Product', {
  product_id: {
    type: DataTypes.INTEGER,
    primaryKey: true,
    allowNull: false
  },
  title: {
    type: DataTypes.STRING,
    allowNull: false
  },
  description: {
    type: DataTypes.TEXT,
    allowNull: true
  },
  price: {
    type: DataTypes.INTEGER,
    allowNull: true
  },
  category: {
    type: DataTypes.TEXT,
    allowNull: true
  },
  brand: {
    type: DataTypes.TEXT,
    allowNull: true
  }
});

module.exports = Product;


