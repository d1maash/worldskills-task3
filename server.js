const express = require("express");
const bodyParser = require("body-parser");
const bcrypt = require("bcryptjs");
const jwt = require("jsonwebtoken");
const mysql = require("mysql");
const { param } = require("./routes/user");
const { UUIDV4 } = require("sequelize");
const app = express();

app.use(bodyParser.json());

const db = mysql.createConnection({
  host: "localhost",
  user: "root",
  password: "",
  database: "FlightPool",
});

db.connect((err) => {
  if (err) {
    throw err;
  }
  console.log("Mysql connected");
});

app.post("/api/register", (req, res) => {
  const { first_name, last_name, phone, password, document_number } = req.body;

  bcrypt.hash(password, 10, (err, hash) => {
    if (err) {
      return res.status(500).json({ error: "Failed to hash password" });
    }

    const api_token = jwt.sign({ phone }, "secret", { expiresIn: "1h" });

    const newUser = {
      first_name,
      last_name,
      phone,
      password: hash,
      document_number,
      api_token,
      created_at: new Date(),
      updated_at: new Date(),
    };

    db.query("INSERT INTO users set ?", newUser, (err, results) => {
      if (err) {
        return res
          .status(422)
          .json({ message: "Validation error", erors: err });
      }
      res.status(204).json({
        message: "Validation error",
      });
    });
  });
});

app.post("/api/login", (req, res) => {
  const { phone, password } = req.body;

  db.query("SELECT * FROM users WHERE phone = ?", [phone], (err, results) => {
    if (err) {
      return res.status(500).json({ message: "Validation error", errors: err });
    }

    if (results.length === 0) {
      return res.status(401).json({ error: "Unouthorized" });
    }

    bcrypt.compare(password, results[0].password, (err, match) => {
      if (err) {
        return res.status(500).json({ error: "failed to auth" });
      }
      if (!match) {
        return res.status(401).json({ error: "invalid passwordd" });
      }

      const newApiToken = jwt.sign({ phone }, "secret", { expiresIn: "1h" });

      db.query(
        "UPDATE users SET api_token = ? WHERE phone = ?",
        [newApiToken, phone],
        (err, results) => {
          if (err) {
            return res
              .status(600)
              .json({ message: "Validation error", errors: err });
          }
          res.status(200).json({ token: newApiToken });
        }
      );
    });
  });
});

const airports = [
  { city: "Atyrau", name: "Atyrau", iata: "GUW" },
  { city: "Almaty", name: "Almaty", iata: "ALA" },
  { city: "Astana", name: "Astana", iata: "AST" },
];

app.get("/api/airports", (req, res) => {
  const sql = "SELECT * FROM airports";
  db.query(sql, (err, result) => {
    if (err) {
      throw err;
    }
    res.status(200).json({ data: { items: result } });
  });
});

app.get("/api/airport", (req, res) => {
  const { query } = req.query;

  if (!query) {
    return res.status(400).json({ error: "Query parameter is required" });
  }

  const result = airports.filter(
    (airport) =>
      airport.name.toLowerCase().includes(query.toLowerCase()) ||
      airport.iata.toLowerCase() === query.toLowerCase()
  );

  if (result.length > 0) {
    const airportsData = result.map((airport) => [
      airport.city,
      airport.name,
      airport.iata,
      new Date(),
      new Date(),
    ]);
    const sql =
      "INSERT INTO airports (city, name, iata, created_at, uploaded_at) VALUES ?";
    db.query(sql, [airportsData], (err, result) => {
      if (err) {
        throw err;
      }
      console.log(`${result.affectedRows} airports inserted`);
    });

    res.status(200).json({ data: { items: result } });
  } else {
    res.status(200).json({ data: { items: [] } });
  }
});

app.get("/api/flight", (req, res) => {
  const { from, to, date1, date2, passengeras } = req.query;

  if (!from || !to || !date1 || !passengeras) {
    return res.status(422).json({
      error: {
        code: 422,
        message: "Validation error",
        errors: {
          from: ["From parameter is required"],
          to: ["To parameter is required"],
          date1: ["Date1 parameter is required"],
          passengers: ["Passengers parameter is required"],
        },
      },
    });
  }

  const formattedDate1 = moment(date1).format("YYYY-MM-DD");
  const formattedDate2 = date2 ? moment(date2).format("YYYY-MM-DD") : null;

  let sqlTo = ` SELECT f.flight_id, f.flight_code, 
    from_airport.city AS from_city, from_airport.airport AS from_airport, from_airport.iata AS from_iata,
    DATE_FORMAT(flight_to.date, '%Y-%m-%d') AS date, 
    TIME_FORMAT(flight_to.time, '%H:%i') AS time, 
    to_airport.city AS to_city, to_airport.airport AS to_airport, to_airport.iata AS to_iata,
    f.cost, f.availability
FROM flights f
JOIN airports AS from_airport ON f.from_id = from_airport.id
JOIN airports AS to_airport ON f.to_id = to_airport.id
WHERE from_airport.iata = ? AND to_airport.iata = ? AND DATE_FORMAT(flight_to.date, '%Y-%m-%d') = ?;

    `;

  let paramsTo = [from.to, formattedDate1];

  if (date2) {
    sqlTo += `
        SELECT f.flight_id, f.flight_code, 
             from_airport.city AS from_city, from_airport.airport AS from_airport, from_airport.iata AS from_iata,
             DATE_FORMAT(flight_to.date, '%Y-%m-%d') AS date, 
             TIME_FORMAT(flight_to.time, '%H:%i') AS time, 
             to_airport.city AS to_city, to_airport.airport AS to_airport, to_airport.iata AS to_iata,
             f.cost, f.availability
      FROM flights f
      JOIN airports AS from_airport ON f.from_id = from_airport.id
      JOIN airports AS to_airport ON f.to_id = to_airport.id
      WHERE from_airport.iata = ? AND to_airport.iata = ? AND DATE_FORMAT(flight_to.date, '%Y-%m-%d') = ?;
   
        `;

    paramsTo = [from, to, formattedDate1, to, from, formattedDate2];
  }

  db.query(sqlTo, paramsTo, (err, results) => {
    if (err) {
      throw err;
    }

    const data = { flights_to: [], flights_back: [] };

    results.forEach((row) => {
      if (row.from_iata === from) {
        data.flights_to.push(row);
      } else {
        data.flights_back.push(row);
      }
    });

    res.status(200).json({ data });
  });
});

app.post("api/booking", (req, res) => {
  const { flight_from, flight_back, passengers } = req.body;
  const bookingCode = UUIDV4().substring(0, 5);

  const sqlCreateBooking = `
  INSERT INTO booking (flight_from, flight_back, date_from, date_back, code, created_at, updated_at VALUES (?, ?, ?, ?, ?, ?, ?))`;

  const values = [
    flight_from.id,
    flight_back.id,
    flight_from.date,
    flight_back.date,
    bookingCode,
    new Date(),
    new Date(),
  ];

  db.query(sqlCreateBooking, values, (err, result) => {
    if (err) {
      throw err;
    }

    res.status(201).json({ data: { code: bookingCode } });
  });
});

app.post("/api/");

const PORT = 3000;
app.listen(PORT, () => {
  console.log(`Server has been started on port ${[PORT]}`);
});
