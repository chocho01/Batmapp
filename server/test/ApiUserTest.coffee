expect = require("chai").expect
server = require("./MockServer")
supertest = require("supertest")
request = null

describe "Test API Users", ()->

  before (done)->
    server.app (app)->
      request = supertest.agent(app);
      done()

  it "Should create a user", (done)->
    request
    .post '/api/users'
    .send
        email: "martin.choraine@epsi.fr"
        password: "martin"
        firstName: "Martin"
        lastName: "Choraine"
    .expect 200, done

  it "Should log the users", (done)->
    request
    .post '/api/login'
    .send
        user: "martin.choraine@epsi.fr"
        password: "martin"
    .end (req, res)->
      expect(res.statusCode).to.equal 200
      expect(res.body.email).to.equal "martin.choraine@epsi.fr"
      done()

  it "Should not create a user (missing email)", (done)->
    request
    .post '/api/users'
    .send
        password: "martin"
        firstName: "Martin"
        lastName: "Choraine"
    .expect 400, done

  it "Should not create a user (wrong email)", (done)->
    request
    .post '/api/users'
    .send
        email: "emailpasbon"
        password: "martin"
        firstName: "Martin"
        lastName: "Choraine"
    .expect 400, done

  it "Should get all user", (done)->
    request
    .get '/api/users'
    .end (err, res)->
      expect(res.statusCode).to.equal 200
      expect(res.body.length).to.equal 1
      done()

  after (done)->
    server.shutdown()
    done()

