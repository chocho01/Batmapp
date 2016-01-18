expect = require("chai").expect
server = require("./MockServer")
supertest = require("supertest")
request = null

describe "Test API Login", ()->

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


  it "Should not log the users", (done)->
    request
    .post '/api/login'
    .send
        user: "martin.choraine@epsi.fr"
        password: "martine"
    .end (req, res)->
      expect(res.statusCode).to.equal 401
      expect(res.body.err).to.equal "Login or password is wrong"
      done()


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


  after (done)->
    server.shutdown()
    done()

