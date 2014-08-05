var gulp = require('gulp');

var coffee = require('gulp-coffee'),
    sass = require('gulp-ruby-sass'),
    connect = require('gulp-connect'),
    sourcemaps = require('gulp-sourcemaps'),
    del = require('del'),
    concat = require('gulp-concat');

var paths = {
  scripts: ['coffee/application.coffee', 'coffee/**/*.coffee'],
  stylesheets: ['scss/**/*.scss'],
  templates: ['*.html', 'partials/**/*.html']
};

// Run a server
gulp.task('connect', function () {
  connect.server({
    livereload: true
  });
});

// Cleanup the environment. Deletes JS and CSS files, which are compiled from
// Coffee and Sass files.
gulp.task('clean', function (cb) {
  del(['js/**/*.js', 'css/**/*.css'], cb)
});

// Compile Sass files
gulp.task('stylesheets', function () {
  gulp.src(paths.stylesheets)
    .pipe(sourcemaps.init())
    .pipe(sass())
    .on('error', function (err) { console.log("CoffeeScript", err.message); })
    .pipe(sourcemaps.write('.'))
    .pipe(gulp.dest('css'))
    .pipe(connect.reload());
});

// Compile Coffeescript files
gulp.task('scripts', function () {
  gulp.src(paths.scripts)
    .pipe(sourcemaps.init())
    .pipe(coffee())
    .on('error', function (err) { console.log("Sass", err.message); })
    .pipe(concat('application.js'))
    .pipe(sourcemaps.write('.'))
    .pipe(gulp.dest('js'))
    .pipe(connect.reload());
});

// Reload the browser when HTML changes
gulp.task('templates', function () {
  gulp.src(paths.templates)
    .pipe(connect.reload());
})

// Watch specific file blobs for changes and trigger their individual build
// when they change
gulp.task('watch', ['clean', 'stylesheets', 'scripts', 'connect'], function () {
  gulp.watch(paths.stylesheets, ['stylesheets']);
  gulp.watch(paths.scripts, ['scripts']);
  gulp.watch(paths.templates, ['templates']);
})

// Default task
gulp.task('default', ['clean', 'stylesheets', 'scripts']);
