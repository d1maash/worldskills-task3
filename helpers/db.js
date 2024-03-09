const config = require("../config.json");
const mysql = require("mysql2/promise");
const { Sequelize } = require("sequelize");

module.exports = db = {};

initalize();

async function initalize() {
  const { host, port, user, password, database } = config.database;
  const connection = await mysql.createConnection({
    host,
    port,
    user,
    password,
  });
  await connection.query(`Create dataabe if not exists \ ${database} \;`);
  const sequelize = new Sequelize(database, user, password, {
    dialect: "mysql",
  });

  await sequelize.sync();
}
