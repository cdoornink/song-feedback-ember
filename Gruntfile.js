module.exports = function(grunt) {

  // Project configuration.
  grunt.initConfig({
    pkg: grunt.file.readJSON('package.json'),
    clean: {
      dev: ["build", "dist/dev"],
      prod: ["build", "dist/prod"]
    },
    ember_templates: {
      compile: {
        options: {
          templateName: function(sourceFile) {
            return sourceFile.replace(/app\/templates\//, '')
          }
        },
        files: {
          'build/templates/templates.js': 'app/templates/**/*.handlebars'
        }
      }
    },
    coffee: {
      compile: {
        files: {
          'build/js/app.js': [
            'app/scripts/routes.coffee', 
            'app/scripts/controllers/*', 
            'app/scripts/views.coffee', 
            'app/scripts/helpers.coffee', 
            'app/scripts/data.coffee', 
            'app/scripts/models/song.coffee', 
            'app/scripts/models/user.coffee'
          ]
        }
      }
    },  
    sass:{
      dist: {
        files : {
          'build/compiled_sass.css': 'app/styles/app.sass'
        }
      }
    },
    cssmin: {
      compress: {
        files: {
          'build/prodcss/app.css': 'build/css/app.css'
        }
      }
    },
    uglify: {
      my_target: {
        files: {
          'build/js/app.js': ['build/js/app.js']
        }
      }
    },
    concat: {
      vendor: {
        src: [
          'app/libs/jquery-1.8.3.min.js',
          'app/libs/bootstrap.min.js',
          'app/libs/bootstrap-fileupload.js',
          'app/libs/handlebars-1.0.0.rc.3.js',
          'app/libs/ember.js',
          'app/libs/excanvas.min.js',
          'app/libs/jquery.jqplot.min.js',
          'app/libs/jqplot.pieRenderer.min.js',
          'app/libs/moment.js',
          'app/libs/md5.js',
          'app/libs/jQuery-File-Upload-master/js/vendor/jquery.ui.widget.js',
          'app/libs/jQuery-File-Upload-master/js/jquery.iframe-transport.js',
          'app/libs/jQuery-File-Upload-master/js/jquery.fileupload.js',
          'app/libs/jQuery.jPlayer.2.4.0/jquery.jplayer.min.js'
        ],
        dest: 'build/js/vendor.js'
      },
      prodVendor: {
        src: [
          'app/libs/jquery-1.8.3.min.js',
          'app/libs/bootstrap.min.js',
          'app/libs/bootstrap-fileupload.js',
          'app/libs/handlebars-1.0.0.rc.3.js',
          'app/libs/ember-1.0.0-rc.3.min.js',
          'app/libs/excanvas.min.js',
          'app/libs/jquery.jqplot.min.js',
          'app/libs/jqplot.pieRenderer.min.js',
          'app/libs/moment.js',
          'app/libs/md5.js',
          'app/libs/jQuery-File-Upload-master/js/vendor/jquery.ui.widget.js',
          'app/libs/jQuery-File-Upload-master/js/jquery.iframe-transport.js',
          'app/libs/jQuery-File-Upload-master/js/jquery.fileupload.js',
          'app/libs/jQuery.jPlayer.2.4.0/jquery.jplayer.min.js'
        ],
        dest: 'build/js/vendor.js'
      },
      app: {
        src: [
          'build/js/app.js',
          'build/templates/templates.js',
        ],
        dest: 'build/js/app.js'
      },
      prodApp: {
        src: [
          'build/js/app.js',
          'build/templates/templates.js',
        ],
        dest: 'build/js/app.js'
      },
      styles: {
        src: [
          'app/styles/libs/jquery.jqplot.css',
          'app/styles/libs/bootstrap.css',
          'app/styles/libs/bootstrap-responsive.css',
          'app/styles/libs/bootstrap-fileupload.css',
          'build/compiled_sass.css'
        ],
        dest: 'build/css/app.css'
      }
    },
    copy: {
      dev: {
        files: [
          {expand: true, cwd: "app/img", src: ['**'], dest: "dist/dev/img"},
          {expand: true, cwd: "build/js", src: ['**'], dest: "dist/dev/js"},
          {expand: true, cwd: "build/css", src: ['**'], dest: "dist/dev/css"},
          {expand: true, cwd: "server", src: ['**'], dest: "dist/dev/server"},
          {expand: true, src: ['Jplayer.swf'], dest: "dist/dev/js/"},
          {src: ['index.html'], dest: "dist/dev/"},
          {src: ['privacy_policy.html'], dest: "dist/dev/"},
          {src: ['terms.html'], dest: "dist/dev/"},
          {src: ['favicon.ico'], dest: "dist/dev/"}
        ]
      },
      prod: {
        files: [
          {expand: true, cwd: "app/img", src: ['**'], dest: "dist/prod/img"},
          {expand: true, cwd: "build/js", src: ['**'], dest: "dist/prod/js"},
          {expand: true, cwd: "build/prodcss", src: ['**'], dest: "dist/prod/css"},
          {expand: true, cwd: "server", src: ['**'], dest: "dist/prod/server"},
          {expand: true, src: ['Jplayer.swf'], dest: "dist/prod/js/"},
          {src: ['index.html'], dest: "dist/prod/"},
          {src: ['privacy_policy.html'], dest: "dist/prod/"},
          {src: ['terms.html'], dest: "dist/prod/"},
          {src: ['favicon.ico'], dest: "dist/prod/"}
        ]
      },
      test: {
        files: [
          {expand: true, cwd: "app/img", src: ['**'], dest: "../test/img"},
          {expand: true, cwd: "build/js", src: ['**'], dest: "../test/js"},
          {expand: true, cwd: "build/css", src: ['**'], dest: "../test/css"},
          {expand: true, cwd: "server", src: ['**'], dest: "../test/server"},
          {expand: true, src: ['Jplayer.swf'], dest: "../test/js/"},
          {src: ['index.html'], dest: "../test/"},
          {src: ['privacy_policy.html'], dest: "../test/"},
          {src: ['terms.html'], dest: "../test/"},
          {src: ['favicon.ico'], dest: "../test/"}
        ]
      }
    },
    watch: {
      scripts: {
        files: 'app/**/*',
        tasks: ['compile']
      }
    }
  });

  // Load the plugin that provides the "uglify" task.
  grunt.loadNpmTasks('grunt-contrib-concat');
  grunt.loadNpmTasks('grunt-ember-templates');
  grunt.loadNpmTasks('grunt-contrib-copy');
  grunt.loadNpmTasks('grunt-contrib-clean');
  grunt.loadNpmTasks('grunt-contrib-watch');
  grunt.loadNpmTasks('grunt-contrib-coffee');
  grunt.loadNpmTasks('grunt-contrib-sass');
  grunt.loadNpmTasks('grunt-contrib-cssmin');
  grunt.loadNpmTasks('grunt-contrib-uglify');
  express = require("express")
  
  grunt.registerTask('default', ['compile', 'webserver', 'watch']);
  grunt.registerTask('compile', ['clean:dev', 'ember_templates', 'coffee', 'sass', 'concat:vendor', 'concat:app', 'concat:styles', 'copy:dev']);
  grunt.registerTask("webserver", "Start a custom static web server.", function(){
    grunt.log.writeln('Starting static web server');
    server = express();
    server.configure(function() {
      server.use("/", express["static"](__dirname + "/dist/dev"));
      server.get("*", function(req, res) {
        res.sendfile(__dirname + '/dist/dev/index.html');
      });
    });
    grunt.log.writeln('Listening on port 3000');
    server.listen(3000);
  });  
  grunt.registerTask('prod', ['clean:prod', 'ember_templates', 'coffee', 'sass', 'concat:prodVendor', 'concat:prodApp', 'concat:styles', 'cssmin', 'uglify', 'copy:prod']);
  grunt.registerTask('test', ['clean:prod', 'ember_templates', 'coffee', 'sass', 'concat:prodVendor', 'concat:prodApp', 'concat:styles', 'copy:test']);
};