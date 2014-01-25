
(function() {
  var NativeJ;
  NativeJ = (function() {
    NativeJ.classSelectorRE = /^\.([\w-]+)$/;

    NativeJ.idSelectorRE = /^#([\w-]+)$/;

    NativeJ.tagSelectorRE = /^[\w-]+$/;

    NativeJ.prototype.elements = [];

    NativeJ.prototype.instance = 0;

    function NativeJ(elements) {
      this.elements = elements;
      this.length = this.elements.length;
      this.listeners = {};
      this.namespaceListeners = {};
      this._bind = function(eventName, eventNamespace, elements, method) {
        var alreadyBindedElement, bindedMethod, checkList, ele, i, _i, _j, _len, _ref, _results;
        checkList = this.listeners;
        if (eventNamespace) {
          if (!this.namespaceListeners.hasOwnProperty(eventNamespace)) {
            this.namespaceListeners[eventNamespace] = {};
          }
          checkList = this.namespaceListeners[eventNamespace];
        }
        if (checkList.hasOwnProperty(eventName)) {
          for (i = _i = 0, _ref = checkList[eventName].aEls.length; _i <= _ref; i = _i += 1) {
            alreadyBindedElement = checkList[eventName].aEls[i];
            bindedMethod = checkList[eventName].aEvts[i];
            if (bindedMethod == method) {
              return;
            }
          }
          checkList[eventName].aEls.push(elements);
          checkList[eventName].aEvts.push(method);
        } else {
          checkList[eventName] = {
            aEls: [elements],
            aEvts: [method]
          };
        }
        _results = [];
        for (_j = 0, _len = elements.length; _j < _len; _j++) {
          ele = elements[_j];
          _results.push(ele.addEventListener(eventName, method));
        }
        return _results;
      };
      this._unbind = function(eventName, eventNamespace, method) {
        var checkList, eName, ele, i, j, _i, _j, _k, _len, _ref, _ref1, _ref2;
        checkList = this.listeners;
        if (eventNamespace) {
          checkList = [];
          if (this.namespaceListeners.hasOwnProperty(eventNamespace)) {
            for (eName in this.namespaceListeners[eventNamespace]) {
              if (checkList.hasOwnProperty(eName)) {
                checkList[eName].aEls = checkList[eName].aEls.concat(this.namespaceListeners[eventNamespace][eName].aEls);
                checkList[eName].aEvts = checkList[eName].aEvts.concat(this.namespaceListeners[eventNamespace][eName].aEvts);
              } else {
                checkList[eName] = this.namespaceListeners[eventNamespace][eName];
              }
            }
          }
        }
        for (eName in checkList) {
          if (eventName && eventName !== eName) {
            continue;
          }
          for (i = _i = 0, _ref = checkList[eName].aEls.length - 1; _i <= _ref; i = _i += 1) {
            if (method && checkList[eName].aEvts[i] === method) {
              _ref1 = checkList[eName].aEls[i];
              for (_j = 0, _len = _ref1.length; _j < _len; _j++) {
                ele = _ref1[_j];
                ele.removeEventListener(eventName, method);
              }
              checkList[eName].aEls.splice(i, 1);
              checkList[eName].aEvts.splice(i, 1);
            } else if (!method) {
              if (checkList[eName].aEls[i]) {
                for (j = _k = 0, _ref2 = checkList[eName].aEls[i].length - 1; 0 <= _ref2 ? _k <= _ref2 : _k >= _ref2; j = 0 <= _ref2 ? ++_k : --_k) {
                  ele = checkList[eName].aEls[i][j];
                  ele.removeEventListener(eName, checkList[eName].aEvts[i]);
                }
                checkList[eName].aEls.splice(i, 1);
                checkList[eName].aEvts.splice(i, 1);
              }
            }
          }
        }
      };
      this._handleBinding = function(type, event, selector, method) {
        var bindOnElements, eventName, eventNamespace;
        if (typeof selector !== "string") {
          method = selector;
          selector = null;
        }
        eventName = event.split('.');
        eventNamespace = void 0;
        if (eventName.length > 1) {
          eventNamespace = eventName[1];
        }
        eventName = eventName[0];
        if (type === 'on') {
          bindOnElements = this.elements;
          if (selector) {
            bindOnElements = this.find(selector);
            if (bindOnElements) {
              bindOnElements = bindOnElements.toArray();
            }
          }
          if (!bindOnElements.length) {
            return;
          }
          return this._bind(eventName, eventNamespace, bindOnElements, method);
        } else {
          return this._unbind(eventName, eventNamespace, method);
        }
      };
    }

    NativeJ.prototype.trigger = function(eventName) {
      var checkEle, domElement, elements, elementsFired, event, found, i, j, k, namespace, _i, _j, _k, _ref, _ref1, _ref2;
      elements = [];
      if (this.listeners.hasOwnProperty(eventName)) {
        elements = elements.concat(this.listeners[eventName].aEls);
      }
      if (this.namespaceListeners) {
        for (namespace in this.namespaceListeners) {
          if (this.namespaceListeners[namespace].hasOwnProperty(eventName)) {
            elements = elements.concat(this.namespaceListeners[namespace][eventName].aEls);
          }
        }
      }
      if (elements.length) {
        event = document.createEvent("MouseEvents");
        event.initMouseEvent(eventName, true, true, window, 0, 0, 0, 0, 0, false, false, false, false, 0, null);
        elementsFired = [];
        for (i = _i = 0, _ref = elements.length - 1; 0 <= _ref ? _i <= _ref : _i >= _ref; i = 0 <= _ref ? ++_i : --_i) {
          if (elements[i] && elements[i].length) {
            for (j = _j = 0, _ref1 = elements[i].length - 1; 0 <= _ref1 ? _j <= _ref1 : _j >= _ref1; j = 0 <= _ref1 ? ++_j : --_j) {
              domElement = elements[i][j];
              found = 0;
              for (k = _k = 0, _ref2 = elementsFired.length - 1; 0 <= _ref2 ? _k <= _ref2 : _k >= _ref2; k = 0 <= _ref2 ? ++_k : --_k) {
                checkEle = elementsFired[k];
                if (checkEle && checkEle.isSameNode(domElement)) {
                  found = 1;
                }
              }
              if (!found) {
                elementsFired.push(domElement);
                domElement.dispatchEvent(event);
              }
            }
          }
        }
        elementsFired = [];
      }
      return this;
    };

    NativeJ.prototype.off = function(event, selector, method) {
      this._handleBinding('off', event, selector, method);
      return this;
    };

    NativeJ.prototype.on = function(event, selector, method) {
      this._handleBinding('on', event, selector, method);
      return this;
    };

    NativeJ.prototype.isArray = function(o) {
      var _ref;
      return (_ref = Object.prototype.toString.call(o) === '[object Array]') != null ? _ref : {
        "true": false
      };
    };

    NativeJ.prototype.toArray = function() {
      return this.elements;
    };

    NativeJ.prototype.get = function(i) {
      return this.elements[i];
    };

    NativeJ.prototype.append = function(data) {
      var el, _i, _len, _ref, _results;
      _ref = this.elements;
      _results = [];
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        el = _ref[_i];
        _results.push(el.innerHTML += data);
      }
      return _results;
    };

    NativeJ.prototype.find = function(selector) {
      return NativeJ.find(selector, this.elements);
    };

    NativeJ.find = function(selector, elements) {
      var ele, entry, _i, _j, _k, _l, _len, _len1, _len2, _len3;
      if (typeof selector === 'object') {
        return new NativeJ(selector);
      }
      if (typeof elements === 'undefined') {
        elements = [document];
      }
      if (NativeJ.idSelectorRE.test(selector)) {
        ele = [];
        for (_i = 0, _len = elements.length; _i < _len; _i++) {
          entry = elements[_i];
          ele.push(entry.getElementById(RegExp.$1));
        }
        return new NativeJ(ele);
      } else {
        ele = [];
        if (NativeJ.classSelectorRE.test(selector)) {
          for (_j = 0, _len1 = elements.length; _j < _len1; _j++) {
            entry = elements[_j];
            ele = ele.concat(Array.prototype.slice.call(entry.getElementsByClassName(RegExp.$1)));
          }
        } else {
          if (NativeJ.tagSelectorRE.test(selector)) {
            for (_k = 0, _len2 = elements.length; _k < _len2; _k++) {
              entry = elements[_k];
              ele = ele.concat(Array.prototype.slice.call(entry.getElementsByTagName(selector)));
            }
          } else {
            for (_l = 0, _len3 = elements.length; _l < _len3; _l++) {
              entry = elements[_l];
              ele = ele.concat(Array.prototype.slice.call(entry.querySelectorAll(selector)));
            }
          }
        }
        return new NativeJ(Array.prototype.slice.call(ele));
      }
    };

    NativeJ.createXMLHttpRequestObject = function(error) {
      var e, xmlHttp;
      try {
        return xmlHttp = new XMLHttpRequest();
      } catch (_error) {
        e = _error;
        try {
          xmlHttp = new ActiveXObject("Microsoft.XMLHttp");
        } catch (_error) {
          e = _error;
        }
        if (!xmlHttp) {
          if (error != null) {
            return error("Error creating the XMLHttpRequest object.");
          }
        } else {
          return xmlHttp;
        }
      }
    };

    NativeJ.handleRequestStateChange = function(e) {
      var response, xmlHttp;
      xmlHttp = e.currentTarget;
      if (xmlHttp.readyState === 4) {
        if (xmlHttp.status === 200) {
          try {
            response = xmlHttp.responseText;
            if (xmlHttp.dataType && xmlHttp.dataType !== 'text' && xmlHttp.dataType !== 'html') {
              return xmlHttp.success(JSON.parse(response), xmlHttp.status, xmlHttp);
            } else {
              return xmlHttp.success(response, xmlHttp.status, xmlHttp);
            }
          } catch (_error) {
            e = _error;
            if (xmlHttp.onerror != null) {
              return xmlHttp.onerror(xmlHttp, "Error reading the response: " + e.toString());
            }
          }
        } else {
          if (xmlHttp.onerror != null) {
            return xmlHttp.onerror(xmlHttp, "There was a problem retrieving the data:\n" + xmlHttp.statusText);
          }
        }
      }
    };

    NativeJ.ajax = function(url, options) {
      var handleRequestStateChange, xmlHttp;
      if (typeof url === 'string') {
        options['url'] = url;
      }
      if (options == null) {
        options = url;
      }
      xmlHttp = NativeJ.createXMLHttpRequestObject((typeof options.error !== 'undefined' ? options.error : null));
      xmlHttp.open("GET", options.url, true);
      handleRequestStateChange = (function(xmlHttp, that) {
        return that.handleRequestStateChange;
      })(xmlHttp, NativeJ);
      xmlHttp.onreadystatechange = handleRequestStateChange;
      if (options.success) {
        xmlHttp.success = options.success;
      }
      if (options.error) {
        xmlHttp.onerror = options.error;
      }
      if (options.dataType) {
        xmlHttp.dataType = options.dataType;
      }
      if (options.beforeSend) {
        options.beforeSend(xmlHttp, options);
      }
      return xmlHttp.send(null);
    };

    return NativeJ;

  })();
  window.$$ = NativeJ.find;
  return window.$$.ajax = NativeJ.ajax;
})();

define("nativej", (function (global) {
    return function () {
        var ret, fn;
        return ret || global.$$;
    };
}(this)));
