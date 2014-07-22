gulp = require 'gulp'
sass = require 'gulp-ruby-sass'
coffee = require 'gulp-coffee'
protractor = require('gulp-protractor').protractor
sourcemaps = require 'gulp-sourcemaps'
connect = require 'gulp-connect'
gutil = require 'gulp-util'

cwd = process.cwd()

paths =
  stylesheets: ['scss/**/*.scss']
  javascripts: ['coffee/**/*.coffee']
  html: ['index.html']
  javascriptSpecs: ['test/e2e/**/*.spec.coffee']

gulp.task 'connect', ->
  connect.server
    livereload: true

gulp.task 'sass', ->
  gulp.src paths.stylesheets
    .pipe sass
      sourcemap: true
      sourcemapPath: '../scss'
      loadPath: "#{cwd}/scss"
    .pipe gulp.dest 'css'
    .pipe connect.reload()

gulp.task 'coffee', ->
  gulp.src paths.javascripts
    .pipe sourcemaps.init()
    .pipe coffee().on 'error', gutil.log
    .pipe sourcemaps.write 'maps', { sourceRoot: '../../coffee' }
    .pipe gulp.dest 'js'
    .pipe connect.reload()


gulp.task 'html', ->
  gulp.src 'index.html'
    .pipe connect.reload()

gulp.task 'jsSpec', ['coffee'], ->
  gulp.src paths.javascriptSpecs
    .pipe coffee().on 'error', gutil.log
    .pipe gulp.dest 'test/e2e/compiled'
    .pipe protractor(
      configFile: 'test/protractor.conf.js'
    ).on 'error', gutil.log

gulp.task 'watch', ['connect', 'sass', 'coffee', 'jsSpec'], ->
  gulp.watch paths.stylesheets, ['sass']
  gulp.watch paths.javascripts, ['coffee']
  gulp.watch paths.html, ['html']
  gulp.watch paths.javascriptSpecs, ['jsSpec']

gulp.task 'default', ['watch']
