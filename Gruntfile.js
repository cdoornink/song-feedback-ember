module.exports = function(grunt) {

  // Project configuration.
  grunt.initConfig({
    pkg: grunt.file.readJSON('package.json'),
    clean: ["build", "dist"],
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
            'app/scripts/controllers.coffee', 
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
          'app/libs/jqplot.pieRenderer.min.js'
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
          {src: ['index.html'], dest: "dist/dev/"},
          {src: ['favicon.ico'], dest: "dist/dev/"}
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
  express = require("express")
  
  grunt.registerTask('default', ['compile', 'webserver', 'watch']);
  grunt.registerTask('compile', ['clean', 'ember_templates', 'coffee', 'sass', 'concat', 'copy']);
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
};