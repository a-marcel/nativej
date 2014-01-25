do () ->
    class NativeJ
        @classSelectorRE: /^\.([\w-]+)$/
        @idSelectorRE: /^#([\w-]+)$/
        @tagSelectorRE: /^[\w-]+$/

        elements: []

        instance: 0

        constructor: (@elements) ->
            @length = @elements.length
            @listeners = {}
            @namespaceListeners = {}

            @_bind = (eventName, eventNamespace, elements, method) ->
                checkList = @listeners

                if eventNamespace
                    if not @namespaceListeners.hasOwnProperty(eventNamespace)
                        @namespaceListeners[eventNamespace] = {}
                    
                    checkList = @namespaceListeners[eventNamespace]

                if checkList.hasOwnProperty(eventName)
                    for i in [0..checkList[eventName].aEls.length] by 1
                        alreadyBindedElement = checkList[eventName].aEls[i]
                        bindedMethod = checkList[eventName].aEvts[i]

                        if `bindedMethod == method`
                            return

                    checkList[eventName].aEls.push(elements)
                    checkList[eventName].aEvts.push(method)
                else
                    checkList[eventName] = { aEls: [elements], aEvts: [ method ] }

                for ele in elements
                    ele.addEventListener eventName, method

            @_unbind = (eventName, eventNamespace, method) ->
                checkList = @listeners

                if eventNamespace
                    checkList = []
                    if @namespaceListeners.hasOwnProperty(eventNamespace)
                        for eName of @namespaceListeners[eventNamespace]
                            if checkList.hasOwnProperty(eName)
                                checkList[eName].aEls = checkList[eName].aEls.concat(@namespaceListeners[eventNamespace][eName].aEls)
                                checkList[eName].aEvts = checkList[eName].aEvts.concat(@namespaceListeners[eventNamespace][eName].aEvts)
                            else
                                checkList[eName] = @namespaceListeners[eventNamespace][eName]

                for eName of checkList
                    if eventName and eventName != eName
                        continue

                    for i in [0..(checkList[eName].aEls.length-1)] by 1

                        if method and checkList[eName].aEvts[i] == `method`
                            for ele in checkList[eName].aEls[i]
                                ele.removeEventListener eventName, method

                            checkList[eName].aEls.splice(i, 1)
                            checkList[eName].aEvts.splice(i, 1)
                        else if not method
                            if checkList[eName].aEls[i]

                                for j in [0..(checkList[eName].aEls[i].length-1)]
                                    ele = checkList[eName].aEls[i][j]
                                    ele.removeEventListener eName, checkList[eName].aEvts[i]

                                checkList[eName].aEls.splice(i, 1)
                                checkList[eName].aEvts.splice(i, 1)

                return


            @_handleBinding = (type, event, selector, method) ->
                if typeof selector != "string"
                    method = selector
                    selector = null

                eventName = event.split('.')
                eventNamespace = undefined
                if eventName.length > 1
                    eventNamespace = eventName[1]

                eventName = eventName[0]

                if type == 'on'
                    bindOnElements = @elements

                    if selector
                        bindOnElements = @find(selector)
                        if bindOnElements
                            bindOnElements = bindOnElements.toArray()

                    if !bindOnElements.length
                        return

                    @_bind eventName, eventNamespace, bindOnElements, method
                else
                    @_unbind eventName, eventNamespace, method

        trigger: (eventName) ->
            elements = []
            if @listeners.hasOwnProperty(eventName)
                elements = elements.concat(@listeners[eventName].aEls)

            if @namespaceListeners
                for namespace of @namespaceListeners
                    if @namespaceListeners[namespace].hasOwnProperty(eventName)
                        elements = elements.concat(@namespaceListeners[namespace][eventName].aEls)

            if elements.length
                event = document.createEvent "MouseEvents"
                event.initMouseEvent eventName, true, true, window, 0, 0, 0, 0, 0, false, false, false, false, 0, null

                elementsFired = []

                for i in [0..(elements.length-1)]
                    if elements[i] and elements[i].length
                        for j in [0..(elements[i].length-1)]
                            domElement = elements[i][j]

                            found = 0

                            for k in [0..(elementsFired.length-1)]
                                checkEle = elementsFired[k]
                                if checkEle and checkEle.isSameNode(domElement)
                                    found = 1

                            if not found
                                elementsFired.push domElement
                                domElement.dispatchEvent event
                elementsFired = []

            return @


        off: (event, selector, method) ->
            @_handleBinding 'off', event, selector, method
            return @

        on: (event, selector, method) ->
            @_handleBinding 'on', event, selector, method
            return @

        isArray: (o) ->
            return (Object.prototype.toString.call( o ) == '[object Array]') ? true : false

#### UTILS ###
        toArray: () ->
            return @elements

        get: (i) ->
            return @elements[i]

#### DOM ###
        append: (data) ->
            for el in @elements
                el.innerHTML += data


        find: (selector) ->

            return NativeJ.find(selector, @elements)

        @find: (selector, elements) ->
            if typeof selector == 'object'
                return new NativeJ(selector)

            if typeof elements == 'undefined'
                elements = [document]

            if (NativeJ.idSelectorRE.test(selector))
                ele = []
                for entry in elements
                    ele.push entry.getElementById(RegExp.$1)

                return new NativeJ ele
            else
                ele = []

                if NativeJ.classSelectorRE.test(selector)
                    for entry in elements
                        ele = ele.concat Array.prototype.slice.call( entry.getElementsByClassName(RegExp.$1) )

                else
                    if NativeJ.tagSelectorRE.test(selector)
                        for entry in elements
                            ele = ele.concat Array.prototype.slice.call( entry.getElementsByTagName(selector) )
                    else
                        for entry in elements
                            ele = ele.concat Array.prototype.slice.call( entry.querySelectorAll(selector) )

                return new NativeJ Array.prototype.slice.call( ele )

#### ajax ####

        @createXMLHttpRequestObject: (error) ->
            # xmlHttp will store the reference to the XMLHttpRequest object
            # try to instantiate the native XMLHttpRequest object
            try
                # create an XMLHttpRequest object
                xmlHttp = new XMLHttpRequest()
            catch e
                # assume IE6 or older
                try
                    xmlHttp = new ActiveXObject("Microsoft.XMLHttp")

                catch e

                # return the created object or display an error message

                if (!xmlHttp)
                    if error?
                        error("Error creating the XMLHttpRequest object.")
                else
                    return xmlHttp

#        handleRequestStateChange: (e) =>
        @handleRequestStateChange: (e) ->
            xmlHttp = e.currentTarget
            # continue if the process is completed
            if xmlHttp.readyState == 4
                # continue only if HTTP status is "OK"
                if xmlHttp.status == 200
                    try
                        # retrieve the response
                        response = xmlHttp.responseText
                        if (xmlHttp.dataType && xmlHttp.dataType != 'text' && xmlHttp.dataType != 'html')
                            xmlHttp.success JSON.parse(response), xmlHttp.status, xmlHttp

                        else
                            xmlHttp.success(response, xmlHttp.status, xmlHttp)
                    catch e
                        # display error message
                        if xmlHttp.onerror?
                            xmlHttp.onerror(xmlHttp, "Error reading the response: " + e.toString())
                else
                    # display status message
                    if xmlHttp.onerror?
                        xmlHttp.onerror(xmlHttp, "There was a problem retrieving the data:\n" + xmlHttp.statusText)


        @ajax: (url, options) ->
#        ajax: (url, options) ->
            if typeof url == 'string'
                options['url'] = url

            if not options?
                options = url

            xmlHttp = NativeJ.createXMLHttpRequestObject (if typeof options.error != 'undefined' then options.error else null)

            # call the server to execute the server side operation
            xmlHttp.open("GET", options.url, true)
            handleRequestStateChange = do (xmlHttp, that = NativeJ) ->
                return that.handleRequestStateChange

            xmlHttp.onreadystatechange = handleRequestStateChange

            if (options.success)
                xmlHttp.success = options.success

            if (options.error)
                xmlHttp.onerror = options.error

            if (options.dataType)
                xmlHttp.dataType = options.dataType

            if (options.beforeSend)
                options.beforeSend(xmlHttp, options)

            xmlHttp.send(null)

#    window.NativeJ = new NativeJ

    window.$$ = NativeJ.find

    window.$$.ajax = NativeJ.ajax


# JsPerf:
# http://jsperf.com/jquery-vs-nativej
