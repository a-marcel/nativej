requirejs.config {
    paths:
        jquery: 'http://code.jquery.com/jquery-2.0.3.min'
        nativej: '../lib/nativej/0.0.3/nativej'
        modernizer: '../lib/modernizer/2.7.1/modernizr.custom.18979'
        qunit: '../lib/qunit/1.13.0/qunit-1.13.0'

    shim:
        'modernizer':
            exports: 'Modernizr'
        'jquery_full':
            exports: 'jQuery'
        'nativej':
            exports: '$$'

        'qunit':
            exports: 'QUnit'
            init: () ->
                QUnit.config.autoload = false
                QUnit.config.autostart = false
}

require ['app'], (App) ->
