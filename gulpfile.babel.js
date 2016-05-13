// Dependencies
import glob from 'glob';
import gulp from 'gulp';
import gutil from 'gulp-util';
import babel from 'gulp-babel';
import plumber from 'gulp-plumber';
import less from 'gulp-less';
import prefix from 'gulp-autoprefixer';
import minify from 'gulp-cssnano';
import uglify from 'uglifyify';
import concat from 'gulp-concat';
import browserify from 'browserify';
import babelify from 'babelify';
import source from 'vinyl-source-stream';
import buffer from 'vinyl-buffer';
import eventStream from 'event-stream';

// Paths
const MODULES_PATH = './node_modules';
const SRC_PATH = 'app/assets';
const DIST_PATH = 'public/assets';

// Configs
const config = {
  paths: {
    less: {
      src: [`${SRC_PATH}/stylesheets/*.less`],
      dist: `${DIST_PATH}/stylesheets/`
    },
    img: {
      src: [`${SRC_PATH}/images/*.{jpg,png,svg}`],
      dist: `${DIST_PATH}/images/`
    },
    js: {
      src: `${SRC_PATH}/javascripts/*.js`,
      dist: `${DIST_PATH}/javascripts/`
    }
  },
  options: {
    babel: {
      presets: [
        'es2015',
        'stage-0',
        'react'
      ]
    },
    prefix: {
      cascade: false,
      browsers: [
        'last 3 versions'
      ]
    }
  }
};

// Images
gulp.task('images', () => {
  gulp.src(config.paths.img.src)
    .pipe(gulp.dest(config.paths.img.dist));
});

// Stylesheets
gulp.task('stylesheets', () => {
  let production = gutil.env.type === 'production';
  gulp.src(config.paths.less.src)
    .pipe(plumber())
    .pipe(less())
    .pipe(prefix(config.options.prefix))
    .pipe(production ? minify() : gutil.noop())
    .pipe(plumber.stop())
    .pipe(gulp.dest(config.paths.less.dist));
});

// JavaScripts
gulp.task('javascripts', () => {
  let sourceDistPath;
  let browserifyInstance;
  let production = gutil.env.type === 'production';
  let sourcesFilesPaths = glob.sync(config.paths.js.src);
  let sourceStreams = sourcesFilesPaths.map((sourceFile) => {
    sourceDistPath = sourceFile.replace(`${SRC_PATH}/javascripts/`, '');
    browserifyInstance = browserify({ entries: [sourceFile] }).transform(babelify);
    if(production) {
      browserifyInstance.transform(uglify);
    }
    return browserifyInstance
      .bundle()
      .on('error', console.error.bind(console))
      .pipe(plumber())
      .pipe(source(sourceDistPath))
      .pipe(buffer())
      .pipe(plumber.stop())
      .pipe(gulp.dest(config.paths.js.dist))
  });
  return eventStream.merge.apply(null, sourceStreams);
});

// Development
gulp.task('watch', () => {
	gulp.watch(`${SRC_PATH}/stylesheets/**/*.less`, ['stylesheets', 'images']);
	gulp.watch(`${SRC_PATH}/javascripts/**/*.js`, ['javascripts']);
});

// Bundle
gulp.task('bundle', [ 'images', 'stylesheets', 'javascripts' ]);

// Default task
gulp.task('default', [ 'watch', 'build' ]);
