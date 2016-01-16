expect = require("chai").expect
server = require("./MockServer")
supertest = require("supertest")

describe "Test API Users", ()->

  request = supertest.agent(server.app);

  it "Should create a user", (done)->
    request
    .post '/api/users'
    .send
      email : "martin.choraine@epsi.fr"
      password : "martin"
      firstName : "Martin"
      lastName: "Choraine"
    .expect 200, done

  it "Should not create a user", (done)->
    request
    .post '/api/users'
    .send
        password : "martin"
        firstName : "Martin"
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

