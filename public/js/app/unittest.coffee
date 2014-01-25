require ['nativej', 'jquery', 'qunit'], ($$, $, QUnit) ->
#    console.log $$('#testarea').find
#    console.log $('#testarea').find('.sub').toArray()

    test "Selector Tests", () ->
        equal $$(window).toArray(), window

        deepEqual $$('#qunit').toArray(), $('#qunit').toArray()
        deepEqual $$('.sub').toArray(), $('.sub').toArray()

        deepEqual $$('#testarea .sub').toArray(), $('#testarea .sub').toArray()

        deepEqual $$('#testarea').find('.sub').toArray(), $('#testarea .sub').toArray()

        deepEqual $$('#testarea').find('.sub').toArray(), $('#testarea').find('.sub').toArray()
        deepEqual $$('#testarea .sub').get(0), $('#testarea .sub').get(0)

        deepEqual $$('#testarea').find('.sub').get(0), $('#testarea').find('.sub').get(0)

    test "EventHandler Test", () ->
        window.eventFired = 0
        window.eventFiredJQuery = 0

        checkFunction = (e) ->
            window.eventFired += 1

        checkFunctionJQuery = (e) ->
            window.eventFiredJQuery += 1

        testEleJQuery = $$('#unittest_eventHandler_jquery').on('click', checkFunctionJQuery)
        testEleJQuery.trigger('click')

        testEle = $$('#unittest_eventHandler').on('click', checkFunction)
        testEle.trigger('click')
        equal window.eventFired, window.eventFiredJQuery, "Normal Click Handler - Click"

        testEleJQuery.off('click')
        testEleJQuery.trigger('click')

        testEle = testEle.off('click')
        testEle.trigger('click')

        equal window.eventFired, window.eventFiredJQuery, "Normal Click Handler - Handler removed"


        testEleJQuery.on('click', checkFunctionJQuery)
        testEleJQuery.trigger('click')

        testEle.on('click', checkFunction)
        testEle.trigger('click')
        equal window.eventFired, window.eventFiredJQuery, "Normal Click Handler - Click (Repeat)"

        testEleJQuery.off('click', checkFunctionJQuery)
        testEleJQuery.trigger('click')

        testEle = testEle.off('click', checkFunction)
        testEle.trigger('click')

        equal window.eventFired, window.eventFiredJQuery, "Normal Click Handler - Handler removed (with method)"

    test "EventHandler Test - Namespace", () ->
        window.eventNamespaceFired = 0
        window.eventNamespaceFiredJQuery = 0

        checkNamespaceFunctionJQuery = (e) ->
            window.eventNamespaceFiredJQuery += 1

        checkNamespaceFunction = (e) ->
            window.eventNamespaceFired += 1

        testEleJQuery = $$('#unittest_eventHandler_namespace_jquery').on('click.namespace', checkNamespaceFunctionJQuery)
        testEleJQuery.trigger('click')

        testEle = $$('#unittest_eventHandler_namespace').on('click.namespace', checkNamespaceFunction)
        testEle.trigger('click')
        equal window.eventNamespaceFired, window.eventNamespaceFiredJQuery, "Normal Click Handler - Click"

        testEleJQuery = testEleJQuery.off('click.namespace')
        testEleJQuery.trigger('click')

        testEle = testEle.off('click.namespace')
        testEle.trigger('click')
        equal window.eventNamespaceFired, window.eventNamespaceFiredJQuery, "Normal Click Handler - Handler removed"

        testEleJQuery = testEleJQuery.on('click.namespace', checkNamespaceFunctionJQuery)
        testEleJQuery.trigger('click')

        testEle.on('click.namespace', checkNamespaceFunction)
        testEle.trigger('click')
        equal window.eventNamespaceFired, window.eventNamespaceFiredJQuery, "Normal Click Handler - Click (Repeat)"

        
        testEleJQuery = testEleJQuery.off('click', checkNamespaceFunctionJQuery)
        testEleJQuery.trigger('click')

        testEle = testEle.off('click', checkNamespaceFunction)
        testEle.trigger('click')
        equal window.eventNamespaceFired, window.eventNamespaceFiredJQuery, "Normal Click Handler - Wrong Handler removed (with method)"


        testEleJQuery = testEleJQuery.off('click.namespace', checkNamespaceFunctionJQuery)
        testEleJQuery.trigger('click')

        testEle = testEle.off('click.namespace', checkNamespaceFunction)
        testEle.trigger('click')
        equal window.eventNamespaceFired, window.eventNamespaceFiredJQuery, "Normal Click Handler - Handler removed (with method)"

    test "EventHandler Test - Mixed Listener (No Namespace, Namespace)", () ->
        window.eventNamespaceFiredJQuery = 0
        window.eventFiredJQuery = 0

        window.eventNamespaceFired = 0
        window.eventFired = 0

        checkFunctionJQuery = (e) ->
            window.eventFiredJQuery += 1

        checkNamespaceFunctionJQuery = (e) ->
            window.eventNamespaceFiredJQuery += 1

        checkFunction = (e) ->
            window.eventFired += 1

        checkNamespaceFunction = (e) ->
            window.eventNamespaceFired += 1

        equal window.eventFired, 0, "Normal Click Handler - Precheck"
        equal window.eventNamespaceFired, 0, "Normal Namespace Click Handler - Precheck"

        testEleJQuery = $$('#unittest_eventHandler_mixed_listener_jquery')
        testEleJQuery.on('click', checkFunctionJQuery)
        testEleJQuery.on('click.namespace', checkNamespaceFunctionJQuery)

        testEleJQuery.trigger('click')

        testEle = $$('#unittest_eventHandler_mixed_listener')
        testEle.on('click', checkFunction)
        testEle.on('click.namespace', checkNamespaceFunction)

        testEle.trigger('click')

        equal window.eventFired, window.eventFiredJQuery, "Normal Click Handler - Click"
        equal window.eventNamespaceFired, window.eventNamespaceFiredJQuery, "Normal Namespace Click Handler - Click"

        testEleJQuery.off('click', checkFunctionJQuery)
        testEleJQuery.trigger('click')

        testEle.off('click', checkFunction)
        testEle.trigger('click')

        equal window.eventFired, window.eventFiredJQuery, "Normal Click Handler - Click"
        equal window.eventNamespaceFired, window.eventNamespaceFiredJQuery, "Normal Namespace Click Handler - Click"

    QUnit.config.reorder = false
    QUnit.load()
    QUnit.start()
