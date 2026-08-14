const express = require("express");
const client = require("prom-client");

const app = express();

app.use(express.json());

const register = new client.Registry();

client.collectDefaultMetrics({
  register
});


/*
============================================================
ROOT ENDPOINT
============================================================
*/

app.get("/", (req, res) => {

  res.status(200).json({
    application: "Three Tier Node.js Application",
    status: "running"
  });

});


/*
============================================================
HEALTH CHECK
============================================================
*/

app.get("/health", (req, res) => {

  res.status(200).json({
    status: "healthy"
  });

});


/*
============================================================
USERS API
============================================================
*/

app.get("/api/users", (req, res) => {

  res.status(200).json([
    {
      id: 1,
      name: "Anay"
    },
    {
      id: 2,
      name: "DevOps User"
    }
  ]);

});


/*
============================================================
PROMETHEUS METRICS
============================================================
*/

app.get("/metrics", async (req, res) => {

  res.set(
    "Content-Type",
    register.contentType
  );

  res.end(
    await register.metrics()
  );

});


/*
============================================================
START SERVER
============================================================
*/

const PORT = process.env.PORT || 3000;

if (require.main === module) {

  app.listen(
    PORT,
    "0.0.0.0",
    () => {
      console.log(
        `Server running on port ${PORT}`
      );
    }
  );

}


module.exports = app;