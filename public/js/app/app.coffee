requirejs.config {
  paths:
    jquery: 'http://code.jquery.com/jquery-2.0.3.min'
}

require ['modernizer', 'unittest'], (Modernizer, UnitTest) ->

#    require [ 'jquery', 'jquery_full' ], ($$, jQuery) ->
#        console.log "NativeJ"
#        console.log $$('#test').length
#
#        console.log "jQuery"
#        console.log $('#test').length
#
#
#        console.log "NativeJ (Sub)"
#        console.log $$('#test .sub').length
#
#        console.log "jQuery (Sub)"
#        console.log $('#test .sub').length
#
#        console.log "NativeJ (Sub - 2)"
#        console.log $$('#test').find('.sub').length
#
#        console.log "jQuery (Sub - 2)"
#        console.log $('#test').find('.sub').length
#
#
#        console.log "ajax"
#
#        console.log $$.ajax('test.json', {success: (x) ->
#            console.log "ready"
#            console.log x
#        , error: (xmlHttp, error) ->
#            console.log "error"
#            console.log y})
#
