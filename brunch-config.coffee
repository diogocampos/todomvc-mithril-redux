exports.config =
  paths:
    watched: ['app', 'assets']

  files:
    javascripts: joinTo: 'app.js'
    stylesheets: joinTo: 'app.css'

  modules:
    autoRequire:
      'app.js': ['main']

  npm:
    enabled: true
    styles:
      'todomvc-common': ['base.css']
      'todomvc-app-css': ['index.css']

  server:
    hostname: '0.0.0.0'
