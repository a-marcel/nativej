module.exports = (grunt) ->
    grunt.initConfig(
        concurrent:
            watch: ['watch:coffee', 'watch:scss']
            options:
                logConcurrentOutput: true


        requirejs:
            compile:
                options:
#                    appDir: 'public/js/app'
                    optimize: 'none'
                    baseUrl: 'public/js/app/'
                    dir: 'public/js/built'
                    mainConfigFile: 'public/js/app/main.js'
#                    fileExclusionRegExp: /^\.|node_modules|Gruntfile|\.md|package.json/
                    findNestedDependencies: true,
#                    fileExclusionRegExp: /^\./,
                    inlineText: true
                    pragmasOnSave:
                        # removes Handlebars.Parser code (used to compile template strings) set
                        # it to `false` if you need to parse template strings even after build
                        excludeHbsParser : true,
                        # kills the entire plugin set once it's built.
                        excludeHbs: true,
                        # removes i18n precompiler, handlebars and json2
                        excludeAfterBuild: true

                    pragmas:
                        mainconfigExclude: true


                    paths:
                        jquery: 'empty:'

                    modules: [
                        {
                            name: 'app'
                        }
                        {
                            name: 'nativej'
                        }
                    ]
        uglify:
            default:
                files:
                    'public/js/release/app/main.js': ['public/js/built/app.js']
                    'public/js/release/app/nativej.min.js': ['public/js/built/nativej.js']
                    'dist/nativej.min.js': ['public/js/built/nativej.js']

        clean:
            before:
                [
                    'public/js/built'
                    'public/js/release'
                    'dist'
                ]
            after:
                [
                    'public/js/built'
                ]


        watch:
            coffee:
                files: ['public/js/**/*.coffee']
                tasks: ['coffee']
                options:
                    spawn: false

            scss:
                files: ['public/sass/**/*.scss']
                tasks: ['compass']
                options:
                    nospawn : true

        coffee:
            options:
                bare: true
                ext: '.js'

            compile:
                expand: true
                src: [ 'public/js/**/*.coffee']
                ext: '.js'

        copy:
            uncompressed:
                files: [
                    {
                        src: 'public/js/built/nativej.js'
                        dest: 'public/js/release/app/nativej.js'
                    }
                    {
                        src: 'public/js/built/nativej.js'
                        dest: 'dist/nativej.js'
                    }
                ]

        compass:
            dist:
                options:
                    config: 'public/config.rb'
                    basePath: 'public/'
                    fontsDir: '../fonts/'
                    noLineComments: false
#                    sassDir: 'public/sass/'
#                    cssDir: 'public/stylesheets/'
#                    imagesDir: 'public/images/'


        zopfli:
            compress:
                options:
                    iterations: 20
                files:
                    'public/js/release/app/nativej.min.js.gz': 'public/js/release/app/nativej.min.js'
    )

    grunt.loadNpmTasks('grunt-contrib-compass')
    grunt.loadNpmTasks('grunt-contrib-coffee')
    grunt.loadNpmTasks('grunt-contrib-requirejs')
    grunt.loadNpmTasks('grunt-contrib-watch')
    grunt.loadNpmTasks('grunt-concurrent')
    grunt.loadNpmTasks('grunt-contrib-requirejs')
    grunt.loadNpmTasks('grunt-contrib-uglify')
    grunt.loadNpmTasks('grunt-contrib-copy')
    grunt.loadNpmTasks('grunt-contrib-clean')
    grunt.loadNpmTasks('grunt-zopfli')


    grunt.registerTask 'default', [
        'clean:before'
        'compass'
        'coffee'
        'requirejs'
        'copy:uncompressed'
        'uglify'
        'clean:after'
#        'zopfli:compress'
    ]

    grunt.registerTask 'watchme', [
        'compass'
        'concurrent'
    ]

    # on watch events configure jshint:all to only run on changed file
    grunt.event.on 'watch', (action, filepath, target) ->
        grunt.log.writeln 'Detected ' + action + ' in ' + target + ' file: ' + filepath

        switch target
            when 'coffee'
                grunt.config 'coffee.compile.src', filepath
