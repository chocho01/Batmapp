path     = require 'path'
rootPath = path.normalize __dirname + '/..'
env      = process.env.NODE_ENV || 'development'

config =
  development:
    root: rootPath
    app:
      name: 'server'
    port: 3000
    db: 'mongodb://localhost:27017/batmapp'

  test:
    root: rootPath
    app:
      name: 'server'
    port: 3002
    db: 'mongodb://localhost/batmapp-test'

  production:
    root: rootPath
    app:
      name: 'server'
    port: 3000
    db: 'mongodb://localhost:27017/batmapp'

module.exports = config[env]
