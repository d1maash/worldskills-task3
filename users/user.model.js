const { DataTypes } = require("sequelize");

module.exports = userModel;

function userModel(sequelize) {
  const attributes = {
    firstName: { type: DataTypes.STRING, allowNull: false },
    last_name: { type: DataTypes.STRING, allowNull: false },
    phone: { type: DataTypes.STRING, allowNull: false },
    hash: { type: DataTypes.STRING, allowNull: false },
    document_number: { type: DataTypes.STRING, allowNull: false },
  };

  const options = {
    defaultScope: {
      attributes: { exclude: [hash] },
    },
    scopes: {
      withHash: { attributes: {} },
    },
  };

  return sequelize.define("User", attributes, options);
}
