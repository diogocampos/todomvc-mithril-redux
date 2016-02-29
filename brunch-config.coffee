exports.config =
  paths:
    watched: ['assets']

  files:
    stylesheets: joinTo: 'app.css'

  npm:
    enabled: true
    styles:
      'todomvc-common': ['base.css']
      'todomvc-app-css': ['index.css']

  server:
    hostname: '0.0.0.0'
