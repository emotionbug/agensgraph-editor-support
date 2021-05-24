"use strict";

function _typeof(obj) { "@babel/helpers - typeof"; if (typeof Symbol === "function" && typeof Symbol.iterator === "symbol") { _typeof = function _typeof(obj) { return typeof obj; }; } else { _typeof = function _typeof(obj) { return obj && typeof Symbol === "function" && obj.constructor === Symbol && obj !== Symbol.prototype ? "symbol" : typeof obj; }; } return _typeof(obj); }

Object.defineProperty(exports, "__esModule", {
  value: true
});
exports.default = void 0;

var _CypherListener2 = _interopRequireDefault(require("../_generated/CypherListener"));

var CypherTypes = _interopRequireWildcard(require("../lang/CypherTypes"));

function _getRequireWildcardCache(nodeInterop) { if (typeof WeakMap !== "function") return null; var cacheBabelInterop = new WeakMap(); var cacheNodeInterop = new WeakMap(); return (_getRequireWildcardCache = function _getRequireWildcardCache(nodeInterop) { return nodeInterop ? cacheNodeInterop : cacheBabelInterop; })(nodeInterop); }

function _interopRequireWildcard(obj, nodeInterop) { if (!nodeInterop && obj && obj.__esModule) { return obj; } if (obj === null || _typeof(obj) !== "object" && typeof obj !== "function") { return { default: obj }; } var cache = _getRequireWildcardCache(nodeInterop); if (cache && cache.has(obj)) { return cache.get(obj); } var newObj = {}; var hasPropertyDescriptor = Object.defineProperty && Object.getOwnPropertyDescriptor; for (var key in obj) { if (key !== "default" && Object.prototype.hasOwnProperty.call(obj, key)) { var desc = hasPropertyDescriptor ? Object.getOwnPropertyDescriptor(obj, key) : null; if (desc && (desc.get || desc.set)) { Object.defineProperty(newObj, key, desc); } else { newObj[key] = obj[key]; } } } newObj.default = obj; if (cache) { cache.set(obj, newObj); } return newObj; }

function _interopRequireDefault(obj) { return obj && obj.__esModule ? obj : { default: obj }; }

function ownKeys(object, enumerableOnly) { var keys = Object.keys(object); if (Object.getOwnPropertySymbols) { var symbols = Object.getOwnPropertySymbols(object); if (enumerableOnly) { symbols = symbols.filter(function (sym) { return Object.getOwnPropertyDescriptor(object, sym).enumerable; }); } keys.push.apply(keys, symbols); } return keys; }

function _objectSpread(target) { for (var i = 1; i < arguments.length; i++) { var source = arguments[i] != null ? arguments[i] : {}; if (i % 2) { ownKeys(Object(source), true).forEach(function (key) { _defineProperty(target, key, source[key]); }); } else if (Object.getOwnPropertyDescriptors) { Object.defineProperties(target, Object.getOwnPropertyDescriptors(source)); } else { ownKeys(Object(source)).forEach(function (key) { Object.defineProperty(target, key, Object.getOwnPropertyDescriptor(source, key)); }); } } return target; }

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

var Index = /*#__PURE__*/function () {
  function Index() {
    _classCallCheck(this, Index);

    _defineProperty(this, "names", {});

    _defineProperty(this, "namesByQuery", []);

    _defineProperty(this, "referencesByName", {});

    _defineProperty(this, "referencesByQueryAndName", []);
  }

  _createClass(Index, [{
    key: "addQuery",
    value: function addQuery() {
      this.namesByQuery.push([]);
      this.referencesByQueryAndName.push({});
    }
  }, {
    key: "add",
    value: function add(ctx) {
      var addName = arguments.length > 1 && arguments[1] !== undefined ? arguments[1] : true;
      var queryIndex = this.namesByQuery.length - 1;
      var text = ctx.getText();

      if (addName) {
        this.names[text] = true;
        this.namesByQuery[queryIndex][text] = true;
      }

      this.referencesByName[text] = [].concat(_toConsumableArray(this.referencesByName[text] || []), [ctx]);
      var index = this.referencesByQueryAndName[queryIndex];
      index[text] = [].concat(_toConsumableArray(index[text] || []), [ctx]);
    }
    /**
     * Variables have specific rules, because they participate in autocompletion.
     * We should not add to the names list variables that are in expression.
     */

  }, {
    key: "addVariable",
    value: function addVariable(ctx) {
      var addName = true; // If variable is inside atom, then variable is inside expression.
      // Therefore, variables is node defined here.

      var parent = ctx.parentCtx;

      if (parent && parent.constructor.name === CypherTypes.ATOM_CONTEXT) {
        addName = false;
      }

      this.add(ctx, addName);
    }
  }]);

  return Index;
}();

var ReferencesListener = /*#__PURE__*/function (_CypherListener) {
  _inherits(ReferencesListener, _CypherListener);

  var _super = _createSuper(ReferencesListener);

  function ReferencesListener() {
    var _this;

    _classCallCheck(this, ReferencesListener);

    for (var _len = arguments.length, args = new Array(_len), _key = 0; _key < _len; _key++) {
      args[_key] = arguments[_key];
    }

    _this = _super.call.apply(_super, [this].concat(args));

    _defineProperty(_assertThisInitialized(_this), "queries", []);

    _defineProperty(_assertThisInitialized(_this), "queriesAndCommands", []);

    _defineProperty(_assertThisInitialized(_this), "statements", []);

    _defineProperty(_assertThisInitialized(_this), "raw", []);

    _defineProperty(_assertThisInitialized(_this), "indexes", CypherTypes.SYMBOLIC_CONTEXTS.reduce(function (acc, t) {
      return _objectSpread(_objectSpread({}, acc), {}, _defineProperty({}, t, new Index(t)));
    }, {}));

    _defineProperty(_assertThisInitialized(_this), "inConsoleCommand", false);

    return _this;
  }

  _createClass(ReferencesListener, [{
    key: "enterRaw",
    value: function enterRaw(ctx) {
      this.raw.push(ctx);
    }
  }, {
    key: "exitRaw",
    value: function exitRaw(ctx) {
      if (this.raw.length === 0) {
        this.raw.push(ctx);
      }
    }
  }, {
    key: "enterCypherPart",
    value: function enterCypherPart(ctx) {
      this.statements.push(ctx);
    }
  }, {
    key: "exitCypher",
    value: function exitCypher(ctx) {
      if (this.statements.length === 0) {
        this.statements.push(ctx);
      }
    }
  }, {
    key: "enterCypherConsoleCommand",
    value: function enterCypherConsoleCommand(ctx) {
      var _this2 = this;

      this.queriesAndCommands.push(ctx);
      Object.keys(this.indexes).forEach(function (k) {
        return _this2.indexes[k].addQuery();
      });
      this.inConsoleCommand = true;
    }
  }, {
    key: "exitCypherConsoleCommand",
    value: function exitCypherConsoleCommand() {
      this.inConsoleCommand = false;
    }
  }, {
    key: "enterCypherQuery",
    value: function enterCypherQuery(ctx) {
      var _this3 = this;

      this.queries.push(ctx);
      this.queriesAndCommands.push(ctx);
      Object.keys(this.indexes).forEach(function (k) {
        return _this3.indexes[k].addQuery();
      });
    }
  }, {
    key: "exitVariable",
    value: function exitVariable(ctx) {
      if (this.inConsoleCommand) {
        return;
      }

      this.indexes[CypherTypes.VARIABLE_CONTEXT].addVariable(ctx);
    }
  }, {
    key: "exitLabelName",
    value: function exitLabelName(ctx) {
      if (this.inConsoleCommand) {
        return;
      }

      this.indexes[CypherTypes.LABEL_NAME_CONTEXT].add(ctx);
    }
  }, {
    key: "exitRelTypeName",
    value: function exitRelTypeName(ctx) {
      if (this.inConsoleCommand) {
        return;
      }

      this.indexes[CypherTypes.RELATIONSHIP_TYPE_NAME_CONTEXT].add(ctx);
    }
  }, {
    key: "exitPropertyKeyName",
    value: function exitPropertyKeyName(ctx) {
      if (this.inConsoleCommand) {
        return;
      }

      this.indexes[CypherTypes.PROPERTY_KEY_NAME_CONTEXT].add(ctx);
    }
  }, {
    key: "exitParameterName",
    value: function exitParameterName(ctx) {
      if (this.inConsoleCommand) {
        return;
      }

      this.indexes[CypherTypes.PARAMETER_NAME_CONTEXT].add(ctx);
    }
  }]);

  return ReferencesListener;
}(_CypherListener2.default);

exports.default = ReferencesListener;
//# sourceMappingURL=ReferencesListener.js.map