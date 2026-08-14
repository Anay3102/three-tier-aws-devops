const request = require("supertest");

const app = require("../server");


describe("Node.js API Tests", () => {


  test("GET / should return application status", async () => {

    const response = await request(app)
      .get("/");


    expect(response.statusCode)
      .toBe(200);


    expect(response.body.status)
      .toBe("running");

  });


  test("GET /health should return healthy", async () => {

    const response = await request(app)
      .get("/health");


    expect(response.statusCode)
      .toBe(200);


    expect(response.body.status)
      .toBe("healthy");

  });


  test("GET /api/users should return users", async () => {

    const response = await request(app)
      .get("/api/users");


    expect(response.statusCode)
      .toBe(200);


    expect(Array.isArray(response.body))
      .toBe(true);

  });

});