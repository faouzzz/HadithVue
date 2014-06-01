'use strict'

module.exports = (grunt) ->
  _ = require 'lodash'

  # Load grunt tasks automatically
  require('load-grunt-tasks') grunt, pattern: [
    'grunt-*',
    '!grunt-contrib-imagemin'
  ]

  # Time how long tasks take. Can help when optimizing build times
  require('time-grunt') grunt

  # Define the configuration for all the tasks
  grunt.initConfig

    # Project settings
    config:
      # configurable paths
      app: require('./bower.json').appPath or 'app'
      temp: '.tmp'
      dist: 'dist'

    express:
      options:
        port: process.env.PORT or 9000
        opts: ['node_modules/coffee-script/bin/coffee']
      dev:
        options:
          script: 'server.coffee'
          # debug: true
      prod:
        options:
          script: 'dist/server.coffee'
          node_env: 'production'

    open:
      server:
        url: 'http://localhost:<%= express.options.port %>'

    watch:
      json:
        files: ['<%= config.app %>/data/{,*/}*.json']
        tasks: ['newer:copy:dist']
      js:
        files: [
          '<%= config.app %>/scripts/**/*.js'
          '!<%= config.app %>/scripts/vendor/**/*.js'
        ]
        tasks: ['newer:jshint:all']
      coffee:
        files: ['<%= config.app %>/scripts/**/*.coffee']
        tasks: ['newer:coffee:dist']
      coffeeTest:
        files: ['test/spec/{,*/}*.{coffee,litcoffee,coffee.md}']
        tasks: ['newer:coffee:test', 'karma']
      mochaTest:
        files: ['test/server/{,*/}*.coffee']
        tasks: [
          'env:test'
          'mochaTest'
        ]
      jsTest:
        files: ['test/client/spec/{,*/}*.js']
        tasks: [
          'newer:jshint:test'
          'karma'
        ]
      compass:
        files: ['<%= config.app %>/styles/{,*/}*.{scss,sass}']
        tasks: ['compass:server']
      # sass:
      #   files: ['<%= config.app %>/styles/**/*.{scss,sass}']
      #   tasks: ['sass:dist']
      gruntfile:
        files: ['Gruntfile.coffee']
      livereload:
        files: [
          '<%= config.app %>/views/{,*//*}*.{html,jade}'
          '{<%= config.temp %>,<%= config.app %>}/styles/{,*//*}*.css'
          '{<%= config.temp %>,<%= config.app %>}/scripts/{,*//*}*.js'
          '{<%= config.temp %>,<%= config.app %>}/data/{,*//*}*.json'
          '<%= config.app %>/images/{,*//*}*.{png,jpg,jpeg,gif,webp,svg}'
        ]
        options:
          livereload: true
      express:
        files: [
          'server.coffee'
          'server/**/*.{coffee,json}'
        ]
        tasks: [
          # 'newer:jshint:server'
          'express:dev'
          'wait'
        ]
        options:
          livereload: true
          spawn: false #Without this option specified express won't be reloaded

    # Make sure code styles are up to par and there are no obvious mistakes
    jshint:
      options:
        jshintrc: '.jshintrc'
        reporter: require('jshint-stylish')
      server:
        options:
          jshintrc: 'server/.jshintrc'

        src: ['server/{,*/}*.js']
      all: []

    # Empties folders to start fresh
    clean:
      dist:
        files: [
          dot: true
          src: [
            '<%= config.temp %>'
            '<%= config.dist %>/*'
            '!<%= config.dist %>/.git*'
            '!<%= config.dist %>/Procfile'
          ]
        ]
      server: '<%= config.temp %>'

    # Add vendor prefixed styles
    autoprefixer:
      options:
        browsers: ['last 1 version']

      dist:
        files: [
          expand: true
          cwd: '<%= config.temp %>/styles/'
          src: '{,*/}*.css'
          dest: '<%= config.temp %>/styles/'
        ]

    # Use nodemon to run server in debug mode with an initial breakpoint
    nodemon:
      debug:
        script: 'server.coffee'
        options:
          nodeArgs: ['--debug-brk']
          env:
            PORT: process.env.PORT or 9000
          callback: (nodemon) ->
            nodemon.on 'log', (event) ->
              console.log event.colour
            # opens browser on initial server start
            nodemon.on 'config:update', ->
              setTimeout (->
                require('open') 'http://localhost:8080/debug?port=5858'
              ), 500

    # Compiles Coffeescripts to JS
    coffee:
      options:
        sourceMap: true
        sourceRoot: ''
      dist:
        files: [
          expand: true
          cwd: '<%= config.app %>/scripts'
          src: '{,*/}*.coffee'
          dest: '<%= config.temp %>/scripts'
          ext: '.js'
        ]
      test:
        files: [
          expand: true,
          cwd: 'test/client/spec',
          src: '{,*/}*.coffee',
          dest: '<%= config.temp %>/client/spec',
          ext: '.js'
        ]

    # # Compiles Sass to CSS and generates necessary files if requested
    # sass:
    #   dist:
    #     files:
    #       '<%= config.temp %>/styles/main.css': '<%= config.app %>/styles/main.scss'
    #     options:
    #       # grunt-contrib-sass version
    #       sourcemap: true
    #       trace: true
    #       compass: true
    #       loadPath: _.flatten [
    #         '<%= config.app %>/bower'
    #         '<%= config.app %>/bower/bourbon/dist'
    #         '<%= config.app %>/bower/neat/app/assets/stylesheets'
    #         '<%= config.app %>/bower/sass-toolkit/stylesheets'
    #         '<%= config.app %>/bower/scut/dist'
    #       ]

    # Compiles Sass to CSS and generates necessary files if requested
    compass:
      options:
        sassDir: "<%= config.app %>/styles"
        cssDir: "<%= config.temp %>/styles"
        generatedImagesDir: "<%= config.temp %>/images/generated"
        imagesDir: "<%= config.app %>/images"
        javascriptsDir: "<%= config.app %>/scripts"
        fontsDir: "<%= config.app %>/styles/fonts"
        importPath: _.flatten [
            '<%= config.app %>/bower'
            '<%= config.app %>/bower/bourbon/dist'
            '<%= config.app %>/bower/neat/app/assets/stylesheets'
            '<%= config.app %>/bower/sass-toolkit/stylesheets'
            '<%= config.app %>/bower/scut/dist'
          ]
        httpImagesPath: "<%= config.app %>/images"
        httpGeneratedImagesPath: "<%= config.app %>/images/generated"
        httpFontsPath: "<%= config.app %>/styles/fonts"
        relativeAssets: false
        assetCacheBuster: true
        raw: "Sass::Script::Number.precision = 10\n"
      dist:
        options:
          generatedImagesDir: "<%= config.app %>/images/generated"
      server:
        options:
          debugInfo: false

    # Renames files for browser caching purposes
    rev:
      dist:
        files:
          src: [
            '<%= config.dist %>/public/scripts/{,*/}*.js'
            '<%= config.dist %>/public/styles/{,*/}*.css'
            '<%= config.dist %>/public/images/{,*/}*.{png,jpg,jpeg,gif,webp,svg}'
            '<%= config.dist %>/public/styles/fonts/*'
          ]

    # Reads HTML for usemin blocks to enable smart builds that automatically
    # concat, minify and revision files. Creates configurations in memory so
    # additional tasks can operate on them
    useminPrepare:
      html: [
        '<%= config.app %>/views/index.html'
        '<%= config.app %>/views/index.jade'
      ]
      options:
        dest: '<%= config.dist %>/public'

    # Performs rewrites based on rev and the useminPrepare configuration
    usemin:
      html: [
        '<%= config.dist %>/views/**/*.html'
        '<%= config.dist %>/views/**/*.jade'
      ]
      css: ['<%= config.dist %>/public/styles/{,*/}*.css']
      options:
        assetsDirs: ['<%= config.dist %>/public']

    # The following *-min tasks produce minified files in the dist folder
    # imagemin:
    #   options:
    #     cache: false

    #   dist:
    #     files: [
    #       expand: true
    #       cwd: '<%= config.app %>/images'
    #       src: '{,*/}*.{png,jpg,jpeg,gif}'
    #       dest: '<%= config.dist %>/public/images'
    #     ]

    svgmin:
      dist:
        files: [
          expand: true
          cwd: '<%= config.app %>/images'
          src: '{,*/}*.svg'
          dest: '<%= config.dist %>/public/images'
        ]

    htmlmin:
      dist:
        options: {
          # collapseWhitespace: true,
          # collapseBooleanAttributes: true,
          # removeCommentsFromCDATA: true,
          # removeOptionalTags: true
        }

        files: [
          expand: true
          cwd: '<%= config.app %>/views'
          src: [
            '*.html'
            'partials/**/*.html'
          ]
          dest: '<%= config.dist %>/views'
        ]

    # # Allow the use of non-minsafe AngularJS files. Automatically makes it
    # # minsafe compatible so Uglify does not destroy the ng references
    # ngmin:
    #   dist:
    #     files: [
    #       expand: true
    #       cwd: '<%= config.temp %>/concat/scripts'
    #       src: '*.js'
    #       dest: '<%= config.temp %>/concat/scripts'
    #     ]

    # Replace Google CDN references
    cdnify:
      dist:
        html: ['<%= config.dist %>/views/*.html']

    # Copies remaining files to places other tasks can use
    copy:
      dist:
        files: [
            expand: true
            dot: true
            cwd: '<%= config.app %>'
            dest: '<%= config.dist %>/public'
            src: [
              '*.{ico,png,txt}'
              '.htaccess'
              'bower/**/*'
              'images/{,*/}*.{webp}'
              'fonts/**/*'
            ]
          ,
            expand: true
            dot: true
            cwd: '<%= config.app %>/views'
            dest: '<%= config.dist %>/views'
            src: '**/*.jade'
          ,
            expand: true
            dot: true
            cwd: '<%= config.app %>/data'
            dest: '<%= config.dist %>/data'
            src: '**/*.json'
          ,
            expand: true
            cwd: '<%= config.temp %>/images'
            dest: '<%= config.dist %>/public/images'
            src: ['generated/*']
          ,
            expand: true
            dest: '<%= config.dist %>'
            src: [
              'package.json'
              'server.coffee'
              'server/**/*'
            ]
        ]
      styles:
        expand: true
        cwd: '<%= config.app %>/styles'
        dest: '<%= config.temp %>/styles/'
        src: '{,*/}*.css'

    # Run some tasks in parallel to speed up the build process
    concurrent:
      server: [
        'coffee:dist'
        'compass:server'
        # 'sass:dist'
      ]
      test: [
        'coffee'
        'sass'
      ]
      debug:
        tasks: [
          'nodemon'
        ]
        options:
          logConcurrentOutput: true
      dist: [
        'coffee:dist'
        'compass:dist'
        # 'sass:dist'
        # 'imagemin'
        'svgmin'
        'htmlmin'
      ]

    # Test settings
    karma:
      unit:
        configFile: 'karma.conf.js'
        singleRun: true
    mochaTest:
      options:
        reporter: 'spec'

      src: ['test/server/**/*.coffee']
    env:
      test:
        NODE_ENV: 'test'

  # Used for delaying livereload until after server has restarted
  grunt.registerTask 'wait', ->
    grunt.log.ok 'Waiting for server reload...'
    done = @async()
    setTimeout (->
      grunt.log.writeln 'Done waiting!'
      done()
    ), 500

  grunt.registerTask 'express-keepalive', 'Keep grunt running', ->
    @async()

  grunt.registerTask 'serve', (target) ->
    if target is 'dist'
      return grunt.task.run([
        'build'
        'express:prod'
        'open'
        'express-keepalive'
      ])
    if target is 'debug'
      return grunt.task.run([
        'clean:server'
        'concurrent:server'
        'autoprefixer'
        'concurrent:debug'
      ])
    grunt.task.run [
      'clean:server'
      'concurrent:server'
      'autoprefixer'
      'express:dev'
      'open'
      'watch'
    ]

  grunt.registerTask 'test', (target) ->
    if target is 'server'
      grunt.task.run [
        'env:test'
        'mochaTest'
      ]
    else if target is 'client'
      grunt.task.run [
        'clean:server'
        'concurrent:test'
        'autoprefixer'
        'karma'
      ]
    else
      grunt.task.run [
        'test:server'
        'test:client'
      ]

  grunt.registerTask 'build', [
    'clean:dist'
    'useminPrepare'
    'concurrent:dist'
    'autoprefixer'
    'concat'
    'ngmin'
    'copy:dist'
    'cdnify'
    'cssmin'
    'uglify'
    'rev'
    'usemin'
  ]

  grunt.registerTask 'dist', [
    'newer:jshint'
    'test'
    'build'
  ]

  grunt.registerTask 'default', [
    'serve'
  ]
