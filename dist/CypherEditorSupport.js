"use strict";

function _typeof(obj) { "@babel/helpers - typeof"; if (typeof Symbol === "function" && typeof Symbol.iterator === "symbol") { _typeof = function _typeof(obj) { return typeof obj; }; } else { _typeof = function _typeof(obj) { return obj && typeof Symbol === "function" && obj.constructor === Symbol && obj !== Symbol.prototype ? "symbol" : typeof obj; }; } return _typeof(obj); }

Object.defineProperty(exports, "__esModule", {
  value: true
});
exports.default = void 0;

var _CompletionTypeResolver = _interopRequireDefault(require("./completion/CompletionTypeResolver"));

var _AutoCompletion = require("./completion/AutoCompletion");

var CypherTypes = _interopRequireWildcard(require("./lang/CypherTypes"));

var _CypherSyntaxHighlight = _interopRequireDefault(require("./highlight/CypherSyntaxHighlight"));

var _TreeUtils = _interopRequireDefault(require("./util/TreeUtils"));

var _PositionConverter = _interopRequireDefault(require("./util/PositionConverter"));

var _retryOperation = _interopRequireDefault(require("./util/retryOperation"));

var _parse2 = _interopRequireDefault(require("./util/parse"));

function _getRequireWildcardCache(nodeInterop) { if (typeof WeakMap !== "function") return null; var cacheBabelInterop = new WeakMap(); var cacheNodeInterop = new WeakMap(); return (_getRequireWildcardCache = function _getRequireWildcardCache(nodeInterop) { return nodeInterop ? cacheNodeInterop : cacheBabelInterop; })(nodeInterop); }

function _interopRequireWildcard(obj, nodeInterop) { if (!nodeInterop && obj && obj.__esModule) { return obj; } if (obj === null || _typeof(obj) !== "object" && typeof obj !== "function") { return { default: obj }; } var cache = _getRequireWildcardCache(nodeInterop); if (cache && cache.has(obj)) { return cache.get(obj); } var newObj = {}; var hasPropertyDescriptor = Object.defineProperty && Object.getOwnPropertyDescriptor; for (var key in obj) { if (key !== "default" && Object.prototype.hasOwnProperty.call(obj, key)) { var desc = hasPropertyDescriptor ? Object.getOwnPropertyDescriptor(obj, key) : null; if (desc && (desc.get || desc.set)) { Object.defineProperty(newObj, key, desc); } else { newObj[key] = obj[key]; } } } newObj.default = obj; if (cache) { cache.set(obj, newObj); } return newObj; }

function _interopRequireDefault(obj) { return obj && obj.__esModule ? obj : { default: obj }; }

function ownKeys(object, enumerableOnly) { var keys = Object.keys(object); if (Object.getOwnPropertySymbols) { var symbols = Object.getOwnPropertySymbols(object); if (enumerableOnly) { symbols = symbols.filter(function (sym) { return Object.getOwnPropertyDescriptor(object, sym).enumerable; }); } keys.push.apply(keys, symbols); } return keys; }

function _objectSpread(target) { for (var i = 1; i < arguments.length; i++) { var source = arguments[i] != null ? arguments[i] : {}; if (i % 2) { ownKeys(Object(source), true).forEach(function (key) { _defineProperty(target, key, source[key]); }); } else if (Object.getOwnPropertyDescriptors) { Object.defineProperties(target, Object.getOwnPropertyDescriptors(source)); } else { ownKeys(Object(source)).forEach(function (key) { Object.defineProperty(target, key, Object.getOwnPropertyDescriptor(source, key)); }); } } return target; }

function _toConsumableArray(arr) { return _arrayWithoutHoles(arr) || _iterableToArray(arr) || _unsupportedIterableToArray(arr) || _nonIterableSpread(); }

function _nonIterableSpread() { throw new TypeError("Invalid attempt to spread non-iterable instance.\nIn order to be iterable, non-array objects must have a [Symbol.iterator]() method."); }

function _unsupportedIterableToArray(o, minLen) { if (!o) return; if (typeof o === "string") return _arrayLikeToArray(o, minLen); var n = Object.prototype.toString.call(o).slice(8, -1); if (n === "Object" && o.constructor) n = o.constructor.name; if (n === "Map" || n === "Set") return Array.from(o); if (n === "Arguments" || /^(?:Ui|I)nt(?:8|16|32)(?:Clamped)?Array$/.test(n)) return _arrayLikeToArray(o, minLen); }

function _iterableToArray(iter) { if (typeof Symbol !== "undefined" && iter[Symbol.iterator] != null || iter["@@iterator"] != null) return Array.from(iter); }

function _arrayWithoutHoles(arr) { if (Array.isArray(arr)) return _arrayLikeToArray(arr); }

function _arrayLikeToArray(arr, len) { if (len == null || len > arr.length) len = arr.length; for (var i = 0, arr2 = new Array(len); i < len; i++) { arr2[i] = arr[i]; } return arr2; }

function _classCallCheck(instance, Constructor) { if (!(instance instanceof Constructor)) { throw new TypeError("Cannot call a class as a function"); } }

function _defineProperties(target, props) { for (var i = 0; i < props.length; i++) { var descriptor = props[i]; descriptor.enumerable = descriptor.enumerable || false; descriptor.configurable = true; if ("value" in descriptor) descriptor.writable = true; Object.defineProperty(target, descriptor.key, descriptor); } }

function _createClass(Constructor, protoProps, staticProps) { if (protoProps) _defineProperties(Constructor.prototype, protoProps); if (staticProps) _defineProperties(Constructor, staticProps); return Constructor; }

function _defineProperty(obj, key, value) { if (key in obj) { Object.defineProperty(obj, key, { value: value, enumerable: true, configurable: true, writable: true }); } else { obj[key] = value; } return obj; }

var CypherEditorSupport = /*#__PURE__*/function () {
  function CypherEditorSupport() {
    var _this = this;

    var input = arguments.length > 0 && arguments[0] !== undefined ? arguments[0] : '';

    _classCallCheck(this, CypherEditorSupport);

    _defineProperty(this, "schema", {});

    _defineProperty(this, "input", null);

    _defineProperty(this, "positionConverter", new _PositionConverter.default(''));

    _defineProperty(this, "parseTree", null);

    _defineProperty(this, "parseErrors", []);

    _defineProperty(this, "referencesProviders", {});

    _defineProperty(this, "completion", new _AutoCompletion.AutoCompletion());

    _defineProperty(this, "queriesAndCommands", []);

    _defineProperty(this, "statements", []);

    _defineProperty(this, "listeners", []);

    _defineProperty(this, "version", 0);

    _defineProperty(this, "ensureVersion", function (version) {
      var delay = arguments.length > 1 && arguments[1] !== undefined ? arguments[1] : 30;
      var times = arguments.length > 2 && arguments[2] !== undefined ? arguments[2] : 5;
      return (0, _retryOperation.default)(function () {
        return new Promise(function (resolve, reject) {
          if (version === _this.version) {
            return resolve();
          }

          return reject();
        });
      }, delay, times);
    });

    this.update(input);
  }

  _createClass(CypherEditorSupport, [{
    key: "on",
    value: function on(eventName, cb) {
      this.listeners[eventName] = Array.isArray(this.listeners[eventName]) ? this.listeners[eventName].concat([cb]) : this.listeners[eventName] = [cb];
    }
  }, {
    key: "off",
    value: function off(eventName, cb) {
      if (!this.listeners[eventName]) return;
      var index = this.listeners[eventName].indexOf(cb);

      if (index > -1) {
        this.listeners[eventName].splice(index, 1);
      }
    }
  }, {
    key: "trigger",
    value: function trigger(eventName) {
      var args = arguments.length > 1 && arguments[1] !== undefined ? arguments[1] : [];
      if (!this.listeners[eventName]) return;
      this.listeners[eventName].forEach(function (cb) {
        return cb.apply(void 0, _toConsumableArray(args));
      });
    }
  }, {
    key: "update",
    value: function update() {
      var input = arguments.length > 0 && arguments[0] !== undefined ? arguments[0] : '';
      var version = arguments.length > 1 ? arguments[1] : undefined;
      this.trigger('update');

      if (input === this.input) {
        this.version = version || this.version;
        this.trigger('updated', [{
          queriesAndCommands: this.queriesAndCommands,
          referencesProviders: this.referencesProviders
        }]);
        return;
      }

      this.positionConverter = new _PositionConverter.default(input);
      this.input = input;

      var _parse = (0, _parse2.default)(input),
          parseTree = _parse.parseTree,
          referencesListener = _parse.referencesListener,
          errorListener = _parse.errorListener,
          referencesProviders = _parse.referencesProviders;

      this.parseTree = parseTree;
      this.parseErrors = errorListener.errors;
      var queriesAndCommands = referencesListener.queriesAndCommands,
          statements = referencesListener.statements;
      this.statements = statements;
      this.queriesAndCommands = queriesAndCommands;
      this.referencesProviders = referencesProviders;
      this.completion.updateReferenceProviders(this.referencesProviders);
      this.version = version || this.version;
      this.trigger('updated', [{
        queriesAndCommands: this.queriesAndCommands,
        referencesProviders: this.referencesProviders
      }]);
    }
  }, {
    key: "setSchema",
    value: function setSchema(schema) {
      this.schema = schema;
      this.completion.updateSchema(this.schema);
    }
  }, {
    key: "getElement",
    value: function getElement(line, column) {
      var abs = this.positionConverter.toAbsolute(line, column);

      function getElement(pt) {
        var pos = _TreeUtils.default.getPosition(pt);

        if (pos != null && (abs < pos.start || abs > pos.stop)) {
          return null;
        }

        var c = pt.getChildCount();

        if (c === 0 && pos != null) {
          return pt;
        }

        for (var i = 0; i < c; i += 1) {
          var e = getElement(pt.getChild(i));

          if (e != null) {
            return e;
          }
        }

        return pos != null ? pt : null;
      }

      return getElement(this.parseTree);
    }
  }, {
    key: "getReferences",
    value: function getReferences(line, column) {
      var e = _TreeUtils.default.findAnyParent(this.getElement(line, column), CypherTypes.SYMBOLIC_CONTEXTS);

      if (e == null) {
        return [];
      }

      var type = e.constructor.name;
      var query = type === CypherTypes.VARIABLE_CONTEXT ? _TreeUtils.default.findAnyParent(e, [CypherTypes.QUERY_CONTEXT]) : null;
      return this.referencesProviders[type].getReferences(e.getText(), query);
    }
  }, {
    key: "getCompletionInfo",
    value: function getCompletionInfo(line, column) {
      var element = this.getElementForCompletion(line, column);

      var query = _TreeUtils.default.findAnyParent(element, [CypherTypes.QUERY_CONTEXT]);

      var _CompletionTypeResolv = _CompletionTypeResolver.default.getTypes(element),
          found = _CompletionTypeResolv.found,
          types = _CompletionTypeResolv.types;

      return {
        element: element,
        query: query,
        found: found,
        types: types
      };
    }
  }, {
    key: "getElementForCompletion",
    value: function getElementForCompletion(line, column) {
      var e = this.getElement(line, column);
      return _TreeUtils.default.findAnyParent(e, CypherTypes.COMPLETION_CANDIDATES) || e;
    }
  }, {
    key: "getCompletion",
    value: function getCompletion(line, column) {
      var doFilter = arguments.length > 2 && arguments[2] !== undefined ? arguments[2] : true;
      var info = this.getCompletionInfo(line, column); // Shift by one symbol back and try again.

      if (!info.found && column > 0) {
        var prevInfo = this.getCompletionInfo(line, column - 1);

        if (prevInfo.found) {
          info = prevInfo;
        }
      }

      var _info = info,
          element = _info.element,
          query = _info.query,
          found = _info.found,
          types = _info.types;
      var replaceRange = {
        from: {
          line: line,
          column: column
        },
        to: {
          line: line,
          column: column
        }
      };
      var filter = null;

      var shouldBeReplaced = _AutoCompletion.AutoCompletion.shouldBeReplaced(element);

      if (found && shouldBeReplaced) {
        // There are number of situations where we need to be smarter than default behavior
        var _TreeUtils$getPositio = _TreeUtils.default.getPosition(element),
            start = _TreeUtils$getPositio.start,
            stop = _TreeUtils$getPositio.stop;

        var smartReplaceRange = _AutoCompletion.AutoCompletion.calculateSmartReplaceRange(element, start);

        if (smartReplaceRange) {
          replaceRange.from = this.positionConverter.toRelative(smartReplaceRange.start);
          replaceRange.to = this.positionConverter.toRelative(smartReplaceRange.stop + 1);

          if (smartReplaceRange.filterText) {
            filter = smartReplaceRange.filterText;
          }
        } else {
          replaceRange.from = this.positionConverter.toRelative(start);
          replaceRange.to = this.positionConverter.toRelative(stop + 1);
        }
      }

      if (filter === null) {
        filter = doFilter && found && shouldBeReplaced ? element.getText() : '';
      }

      return _objectSpread({
        items: this.completion.getItems(types, {
          filter: filter,
          query: query,
          elementType: element ? element.constructor.name : 'unknown'
        })
      }, replaceRange);
    }
  }, {
    key: "applyHighlighthing",
    value: function applyHighlighthing(callback) {
      _CypherSyntaxHighlight.default.process(this.parseTree, callback);
    }
  }]);

  return CypherEditorSupport;
}();

exports.default = CypherEditorSupport;
//# sourceMappingURL=CypherEditorSupport.js.map