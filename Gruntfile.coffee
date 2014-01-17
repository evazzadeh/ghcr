require "shelljs/global"

# like set -e
config.fatal = true

module.exports = (grunt) ->
  grunt.loadNpmTasks('grunt-contrib-coffee')
  grunt.loadNpmTasks('grunt-contrib-sass')
  grunt.loadNpmTasks('grunt-concat-sourcemap')
  grunt.loadNpmTasks('grunt-contrib-uglify')
  grunt.loadNpmTasks('grunt-contrib-watch')
  grunt.loadNpmTasks('grunt-multiresize')
  grunt.loadNpmTasks('grunt-slim')
  grunt.loadNpmTasks('grunt-contrib-copy')

  grunt.config.init
    pkg: grunt.file.readJSON "package.json"
    coffee:
      options: { join: true, sourceMap: false, bare: true }
      default: files:
        # shared
        "build/shared/ghcr.js": [
          "build/shared/app/page.coffee"
          "build/shared/app/api.coffee"
          "build/shared/app/repository.coffee"
          "build/shared/app/template.coffee"
          "build/shared/app/user.coffee"
          "build/shared/app/config.coffee"
          "build/shared/ghcr.coffee"
        ]

        # Chrome
        "build/chrome-tmp/request.js":    ["build/chrome/request.coffee"]
        "build/chrome-tmp/storage.js":    ["build/chrome/storage.coffee"]
        "build/chrome/background.js": ["build/chrome/background.coffee"]
        "build/chrome/settings.js":   ["build/shared/settings.coffee"]
    sass:
      options: { lineNumbers: true }
      default: files:
        "build/shared/ghcr.css": ["build/shared/ghcr.sass"]
    slim: default: files:
        "build/chrome/settings.html": "source/shared/settings.slim"
    concat_sourcemap:
      options: { sourcesContent: true, sourceRoot: 'foobar' }
      default: files:
        "build/chrome/ghcr.js": [
          "build/shared/vendor/*.js"
          "build/chrome-tmp/*.js"
          "build/shared/ghcr.js"
        ]
        "build/chrome/ghcr.css": ["build/shared/*.css"]
        "build/chrome/settings.css": ["build/shared/vendor/*.css"]

    uglify:
      options: { compress: true },
      default: files:
        "build/chrome/ghcr.js": "build/chrome/ghcr.js"
    watch:
      options: { atBegin: true }
      default:
        files: ['source/**']
        tasks: ['build']
    multiresize:
      default:
        src: 'build/shared/icon256.png'
        dest: [
          'build/chrome/icon128.png',
          'build/chrome/icon48.png',
          'build/chrome/icon38.png',
          'build/chrome/icon19.png',
          'build/chrome/icon16.png',
        ]
        destSizes: ['128x128', '128x128', '48x48', '38x38', '19x19', '16x16']

  grunt.registerTask "build", "Build extension", ->
    rm "-rf", "build"
    cp "-r", "source/*", "build"
    grunt.task.run "coffee"
    grunt.task.run "sass"
    grunt.task.run "slim"
    grunt.task.run "concat_sourcemap"
    grunt.task.run "multiresize"
    grunt.task.run "cleanup"

  grunt.registerTask "release", "Release extension", ->
    grunt.task.run "build"
    grunt.task.run "uglify"
    grunt.task.run "zip"

  grunt.registerTask "cleanup", "Cleanup", ->
    exec "find build -name '*.coffee' | xargs rm"
    exec "find build -name '*.sass' | xargs rm"
    exec "find build -name '*.map' | xargs rm"
    rm "-rf", "build/shared"
    rm "-rf", "build/chrome-tmp"

  grunt.registerTask "zip", "Zip extension", ->
    exec "zip -rj build/chrome.zip build/chrome"

  grunt.registerTask "default", ->
    grunt.log.writeln("grunt build")
    grunt.log.writeln("grunt release")
    grunt.log.writeln("grunt watch")
