"use strict";

function _typeof(obj) { "@babel/helpers - typeof"; if (typeof Symbol === "function" && typeof Symbol.iterator === "symbol") { _typeof = function _typeof(obj) { return typeof obj; }; } else { _typeof = function _typeof(obj) { return obj && typeof Symbol === "function" && obj.constructor === Symbol && obj !== Symbol.prototype ? "symbol" : typeof obj; }; } return _typeof(obj); }

Object.defineProperty(exports, "__esModule", {
  value: true
});
exports.AutoCompletion = exports.KEYWORD_ITEMS = void 0;

var _fuzzaldrin = require("fuzzaldrin");

var _lodash = _interopRequireDefault(require("lodash"));

var CypherTypes = _interopRequireWildcard(require("../lang/CypherTypes"));

var CompletionTypes = _interopRequireWildcard(require("./CompletionTypes"));

var _CypherKeywords = _interopRequireDefault(require("../lang/CypherKeywords"));

var _TreeUtils = _interopRequireDefault(require("../util/TreeUtils"));

var _escapeCypher = _interopRequireDefault(require("../util/escapeCypher"));

var _defineProperty2;

function _getRequireWildcardCache(nodeInterop) { if (typeof WeakMap !== "function") return null; var cacheBabelInterop = new WeakMap(); var cacheNodeInterop = new WeakMap(); return (_getRequireWildcardCache = function _getRequireWildcardCache(nodeInterop) { return nodeInterop ? cacheNodeInterop : cacheBabelInterop; })(nodeInterop); }

function _interopRequireWildcard(obj, nodeInterop) { if (!nodeInterop && obj && obj.__esModule) { return obj; } if (obj === null || _typeof(obj) !== "object" && typeof obj !== "function") { return { default: obj }; } var cache = _getRequireWildcardCache(nodeInterop); if (cache && cache.has(obj)) { return cache.get(obj); } var newObj = {}; var hasPropertyDescriptor = Object.defineProperty && Object.getOwnPropertyDescriptor; for (var key in obj) { if (key !== "default" && Object.prototype.hasOwnProperty.call(obj, key)) { var desc = hasPropertyDescriptor ? Object.getOwnPropertyDescriptor(obj, key) : null; if (desc && (desc.get || desc.set)) { Object.defineProperty(newObj, key, desc); } else { newObj[key] = obj[key]; } } } newObj.default = obj; if (cache) { cache.set(obj, newObj); } return newObj; }

function _interopRequireDefault(obj) { return obj && obj.__esModule ? obj : { default: obj }; }

function _inherits(subClass, superClass) { if (typeof superClass !== "function" && superClass !== null) { throw new TypeError("Super expression must either be null or a function"); } subClass.prototype = Object.create(superClass && superClass.prototype, { constructor: { value: subClass, writable: true, configurable: true } }); if (superClass) _setPrototypeOf(subClass, superClass); }

function _setPrototypeOf(o, p) { _setPrototypeOf = Object.setPrototypeOf || function _setPrototypeOf(o, p) { o.__proto__ = p; return o; }; return _setPrototypeOf(o, p); }

function _createSuper(Derived) { var hasNativeReflectConstruct = _isNativeReflectConstruct(); return function _createSuperInternal() { var Super = _getPrototypeOf(Derived), result; if (hasNativeReflectConstruct) { var NewTarget = _getPrototypeOf(this).constructor; result = Reflect.construct(Super, arguments, NewTarget); } else { result = Super.apply(this, arguments); } return _possibleConstructorReturn(this, result); }; }

function _possibleConstructorReturn(self, call) { if (call && (_typeof(call) === "object" || typeof call === "function")) { return call; } return _assertThisInitialized(self); }

function _assertThisInitialized(self) { if (self === void 0) { throw new ReferenceError("this hasn't been initialised - super() hasn't been called"); } return self; }

function _isNativeReflectConstruct() { if (typeof Reflect === "undefined" || !Reflect.construct) return false; if (Reflect.construct.sham) return false; if (typeof Proxy === "function") return true; try { Boolean.prototype.valueOf.call(Reflect.construct(Boolean, [], function () {})); return true; } catch (e) { return false; } }

function _getPrototypeOf(o) { _getPrototypeOf = Object.setPrototypeOf ? Object.getPrototypeOf : function _getPrototypeOf(o) { return o.__proto__ || Object.getPrototypeOf(o); }; return _getPrototypeOf(o); }

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

var KEYWORD_ITEMS = _CypherKeywords.default.map(function (keyword) {
  return {
    type: CompletionTypes.KEYWORD,
    view: keyword,
    content: keyword,
    postfix: null
  };
});

exports.KEYWORD_ITEMS = KEYWORD_ITEMS;

var AbstractCachingCompletion = /*#__PURE__*/function () {
  function AbstractCachingCompletion() {
    var cache = arguments.length > 0 && arguments[0] !== undefined ? arguments[0] : {};

    _classCallCheck(this, AbstractCachingCompletion);

    _defineProperty(this, "cache", {});

    this.cache = cache;
  } // eslint-disable-next-line class-methods-use-this, no-unused-vars


  _createClass(AbstractCachingCompletion, [{
    key: "calculateItems",
    value: function calculateItems(type) {
      var query = arguments.length > 1 && arguments[1] !== undefined ? arguments[1] : null;
      return [];
    }
  }, {
    key: "complete",
    value: function complete(types, query) {
      var _this = this;

      return types.map(function (typeData) {
        var cached = _this.cache[typeData.type];

        if (cached != null) {
          return cached;
        }

        return _this.calculateItems(typeData, query);
      }).reduce(function (acc, items) {
        return [].concat(_toConsumableArray(acc), _toConsumableArray(items));
      }, []);
    }
  }]);

  return AbstractCachingCompletion;
}();

var SchemaBasedCompletion = /*#__PURE__*/function (_AbstractCachingCompl) {
  _inherits(SchemaBasedCompletion, _AbstractCachingCompl);

  var _super = _createSuper(SchemaBasedCompletion);

  function SchemaBasedCompletion() {
    var _super$call;

    var _this2;

    var schema = arguments.length > 0 && arguments[0] !== undefined ? arguments[0] : {};

    _classCallCheck(this, SchemaBasedCompletion);

    _this2 = _super.call(this, (_super$call = {}, _defineProperty(_super$call, CompletionTypes.KEYWORD, KEYWORD_ITEMS), _defineProperty(_super$call, CompletionTypes.LABEL, (schema.labels || []).map(function (label) {
      return {
        type: CompletionTypes.LABEL,
        view: label,
        content: (0, _escapeCypher.default)(label),
        postfix: null
      };
    })), _defineProperty(_super$call, CompletionTypes.RELATIONSHIP_TYPE, (schema.relationshipTypes || []).map(function (relType) {
      return {
        type: CompletionTypes.RELATIONSHIP_TYPE,
        view: relType,
        content: (0, _escapeCypher.default)(relType),
        postfix: null
      };
    })), _defineProperty(_super$call, CompletionTypes.PROPERTY_KEY, (schema.propertyKeys || []).map(function (propKey) {
      return {
        type: CompletionTypes.PROPERTY_KEY,
        view: propKey,
        content: (0, _escapeCypher.default)(propKey),
        postfix: null
      };
    })), _defineProperty(_super$call, CompletionTypes.FUNCTION_NAME, (schema.functions || []).map(function (_ref) {
      var name = _ref.name,
          signature = _ref.signature;
      return {
        type: CompletionTypes.FUNCTION_NAME,
        view: name,
        content: (0, _escapeCypher.default)(name),
        postfix: signature
      };
    })), _defineProperty(_super$call, CompletionTypes.PROCEDURE_NAME, (schema.procedures || []).map(function (_ref2) {
      var name = _ref2.name,
          signature = _ref2.signature;
      return {
        type: CompletionTypes.PROCEDURE_NAME,
        view: name,
        content: name,
        postfix: signature
      };
    })), _defineProperty(_super$call, CompletionTypes.CONSOLE_COMMAND_NAME, (schema.consoleCommands || []).map(function (consoleCommandName) {
      return {
        type: CompletionTypes.CONSOLE_COMMAND_NAME,
        view: consoleCommandName.name,
        content: consoleCommandName.name,
        postfix: consoleCommandName.description || null
      };
    })), _defineProperty(_super$call, CompletionTypes.PARAMETER, (schema.parameters || []).map(function (parameter) {
      return {
        type: CompletionTypes.PARAMETER,
        view: parameter,
        content: parameter,
        postfix: null
      };
    })), _super$call));

    _defineProperty(_assertThisInitialized(_this2), "schema", {});

    _this2.schema = schema;
    return _this2;
  }

  _createClass(SchemaBasedCompletion, [{
    key: "calculateItems",
    value: function calculateItems(typeData) {
      return (SchemaBasedCompletion.providers[typeData.type] || function () {
        return [];
      })(this.schema, typeData);
    }
  }]);

  return SchemaBasedCompletion;
}(AbstractCachingCompletion);

_defineProperty(SchemaBasedCompletion, "providers", (_defineProperty2 = {}, _defineProperty(_defineProperty2, CompletionTypes.PROCEDURE_OUTPUT, function (schema, typeData) {
  var findByName = function findByName(e) {
    return e.name === typeData.name && e.returnItems !== [];
  };

  var procedure = _lodash.default.find(schema.procedures, findByName);

  if (procedure) {
    return procedure.returnItems.map(function (_ref4) {
      var name = _ref4.name,
          signature = _ref4.signature;
      return {
        type: CompletionTypes.PROCEDURE_OUTPUT,
        view: name,
        content: name,
        postfix: " :: ".concat(signature)
      };
    });
  }

  return [];
}), _defineProperty(_defineProperty2, CompletionTypes.CONSOLE_COMMAND_SUBCOMMAND, function (schema, typeData) {
  var filterLastElement = typeData.filterLastElement,
      path = typeData.path;
  var length = filterLastElement ? path.length - 1 : path.length;
  var currentLevel = schema.consoleCommands;

  for (var i = 0; i < length; i += 1) {
    var foundCommand = _lodash.default.find(currentLevel, ['name', path[i]]);

    if (foundCommand) {
      currentLevel = foundCommand.commands || [];
    } else {
      return [];
    }
  }

  return currentLevel.map(function (_ref5) {
    var name = _ref5.name,
        description = _ref5.description;
    return {
      type: CompletionTypes.CONSOLE_COMMAND_SUBCOMMAND,
      view: name,
      content: name,
      postfix: description || null
    };
  });
}), _defineProperty2));

var QueryBasedCompletion = /*#__PURE__*/function (_AbstractCachingCompl2) {
  _inherits(QueryBasedCompletion, _AbstractCachingCompl2);

  var _super2 = _createSuper(QueryBasedCompletion);

  function QueryBasedCompletion() {
    var _this3;

    var referenceProviders = arguments.length > 0 && arguments[0] !== undefined ? arguments[0] : {};

    _classCallCheck(this, QueryBasedCompletion);

    _this3 = _super2.call(this);

    _defineProperty(_assertThisInitialized(_this3), "providers", {});

    _defineProperty(_assertThisInitialized(_this3), "emptyProvider", {
      getNames: function getNames() {
        return [];
      }
    });

    _this3.providers = _defineProperty({}, CompletionTypes.VARIABLE, function (query) {
      return (referenceProviders[CypherTypes.VARIABLE_CONTEXT] || _this3.emptyProvider).getNames(query).map(function (name) {
        return {
          type: CompletionTypes.VARIABLE,
          view: name,
          content: name,
          postfix: null
        };
      });
    });
    return _this3;
  }

  _createClass(QueryBasedCompletion, [{
    key: "calculateItems",
    value: function calculateItems(typeData, query) {
      return (this.providers[typeData.type] || function () {
        return [];
      })(query);
    }
  }]);

  return QueryBasedCompletion;
}(AbstractCachingCompletion);

var AutoCompletion = /*#__PURE__*/function () {
  function AutoCompletion() {
    _classCallCheck(this, AutoCompletion);

    _defineProperty(this, "queryBased", null);

    _defineProperty(this, "schemaBased", null);

    this.updateSchema({});
  }

  _createClass(AutoCompletion, [{
    key: "getItems",
    value: function getItems(types, _ref3) {
      var _ref3$query = _ref3.query,
          query = _ref3$query === void 0 ? null : _ref3$query,
          _ref3$filter = _ref3.filter,
          filter = _ref3$filter === void 0 ? '' : _ref3$filter;
      var text = filter.toLowerCase();
      var filteredText = AutoCompletion.filterText(text);

      var completionItemFilter = function completionItemFilter() {
        return true;
      };

      var list = [this.queryBased, this.schemaBased].filter(function (s) {
        return s != null;
      }).map(function (t) {
        return t.complete(types, query);
      }).reduce(function (acc, items) {
        return [].concat(_toConsumableArray(acc), _toConsumableArray(items));
      }, []).filter(completionItemFilter);

      if (filteredText) {
        return (0, _fuzzaldrin.filter)(list, filteredText, {
          key: 'view'
        });
      }

      if (text) {
        return (0, _fuzzaldrin.filter)(list, text, {
          key: 'view'
        });
      }

      return list;
    }
  }, {
    key: "updateSchema",
    value: function updateSchema(schema) {
      this.schemaBased = new SchemaBasedCompletion(schema);
    }
  }, {
    key: "updateReferenceProviders",
    value: function updateReferenceProviders(referenceProviders) {
      this.queryBased = new QueryBasedCompletion(referenceProviders);
    }
    /**
     * Define whether element should be replaced or not.
     */

  }], [{
    key: "shouldBeReplaced",
    value: function shouldBeReplaced(element) {
      if (element == null) {
        return false;
      }

      var text = element.getText();
      var parent = element.parentCtx; // If element is whitespace

      if (/^\s+$/.test(text)) {
        return false;
      } // If element is opening bracket (e.g. start of relationship pattern)


      if (text === '[') {
        return false;
      } // If element is opening brace (e.g. start of node pattern)


      if (text === '(') {
        return false;
      }

      if (text === '.') {
        return false;
      }

      if (text === '{') {
        return false;
      }

      if (text === '$') {
        return false;
      }

      return !(text === ':' && parent != null && parent.constructor.name === CypherTypes.MAP_LITERAL_ENTRY);
    }
  }, {
    key: "filterText",
    value: function filterText(text) {
      if (text.startsWith('$')) {
        return text.slice(1);
      }

      return text;
    } // eslint-disable-next-line no-unused-vars

  }, {
    key: "calculateSmartReplaceRange",
    value: function calculateSmartReplaceRange(element, start) {
      // If we are in relationship type or label and we have error nodes in there.
      // This means that we typed in just ':' and Antlr consumed other tokens in element
      // In this case replace only ':'
      if (element.constructor.name === CypherTypes.RELATIONSHIP_TYPE_CONTEXT || element.constructor.name === CypherTypes.NODE_LABEL_CONTEXT) {
        if (_TreeUtils.default.hasErrorNode(element)) {
          return {
            filterText: ':',
            start: start,
            stop: start
          };
        }
      }

      return null;
    }
  }]);

  return AutoCompletion;
}();

exports.AutoCompletion = AutoCompletion;
//# sourceMappingURL=AutoCompletion.js.map