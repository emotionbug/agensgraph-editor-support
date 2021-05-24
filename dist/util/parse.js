"use strict";

function _typeof(obj) { "@babel/helpers - typeof"; if (typeof Symbol === "function" && typeof Symbol.iterator === "symbol") { _typeof = function _typeof(obj) { return typeof obj; }; } else { _typeof = function _typeof(obj) { return obj && typeof Symbol === "function" && obj.constructor === Symbol && obj !== Symbol.prototype ? "symbol" : typeof obj; }; } return _typeof(obj); }

Object.defineProperty(exports, "__esModule", {
  value: true
});
exports.default = parse;

var _antlr = _interopRequireDefault(require("antlr4"));

var _ReferencesProvider = _interopRequireDefault(require("../references/ReferencesProvider"));

var CypherTypes = _interopRequireWildcard(require("../lang/CypherTypes"));

var _CypherParser = _interopRequireDefault(require("../_generated/CypherParser"));

var _CypherLexer = _interopRequireDefault(require("../_generated/CypherLexer"));

var _ErrorListener = _interopRequireDefault(require("../errors/ErrorListener"));

var _ReferencesListener = _interopRequireDefault(require("../references/ReferencesListener"));

function _getRequireWildcardCache(nodeInterop) { if (typeof WeakMap !== "function") return null; var cacheBabelInterop = new WeakMap(); var cacheNodeInterop = new WeakMap(); return (_getRequireWildcardCache = function _getRequireWildcardCache(nodeInterop) { return nodeInterop ? cacheNodeInterop : cacheBabelInterop; })(nodeInterop); }

function _interopRequireWildcard(obj, nodeInterop) { if (!nodeInterop && obj && obj.__esModule) { return obj; } if (obj === null || _typeof(obj) !== "object" && typeof obj !== "function") { return { default: obj }; } var cache = _getRequireWildcardCache(nodeInterop); if (cache && cache.has(obj)) { return cache.get(obj); } var newObj = {}; var hasPropertyDescriptor = Object.defineProperty && Object.getOwnPropertyDescriptor; for (var key in obj) { if (key !== "default" && Object.prototype.hasOwnProperty.call(obj, key)) { var desc = hasPropertyDescriptor ? Object.getOwnPropertyDescriptor(obj, key) : null; if (desc && (desc.get || desc.set)) { Object.defineProperty(newObj, key, desc); } else { newObj[key] = obj[key]; } } } newObj.default = obj; if (cache) { cache.set(obj, newObj); } return newObj; }

function _interopRequireDefault(obj) { return obj && obj.__esModule ? obj : { default: obj }; }

function ownKeys(object, enumerableOnly) { var keys = Object.keys(object); if (Object.getOwnPropertySymbols) { var symbols = Object.getOwnPropertySymbols(object); if (enumerableOnly) { symbols = symbols.filter(function (sym) { return Object.getOwnPropertyDescriptor(object, sym).enumerable; }); } keys.push.apply(keys, symbols); } return keys; }

function _objectSpread(target) { for (var i = 1; i < arguments.length; i++) { var source = arguments[i] != null ? arguments[i] : {}; if (i % 2) { ownKeys(Object(source), true).forEach(function (key) { _defineProperty(target, key, source[key]); }); } else if (Object.getOwnPropertyDescriptors) { Object.defineProperties(target, Object.getOwnPropertyDescriptors(source)); } else { ownKeys(Object(source)).forEach(function (key) { Object.defineProperty(target, key, Object.getOwnPropertyDescriptor(source, key)); }); } } return target; }

function _defineProperty(obj, key, value) { if (key in obj) { Object.defineProperty(obj, key, { value: value, enumerable: true, configurable: true, writable: true }); } else { obj[key] = value; } return obj; }

function parse(input) {
  var referencesListener = new _ReferencesListener.default();
  var errorListener = new _ErrorListener.default();
  var chars = new _antlr.default.InputStream(input);
  var lexer = new _CypherLexer.default(chars);
  lexer.removeErrorListeners();
  lexer.addErrorListener(errorListener);
  var tokens = new _antlr.default.CommonTokenStream(lexer);
  var parser = new _CypherParser.default(tokens);
  parser.buildParseTrees = true;
  parser.removeErrorListeners();
  parser.addErrorListener(errorListener);
  parser.addParseListener(referencesListener);
  var parseTree = parser.cypher();
  var queries = referencesListener.queries,
      indexes = referencesListener.indexes;
  var referencesProviders = CypherTypes.SYMBOLIC_CONTEXTS.reduce(function (acc, t) {
    return _objectSpread(_objectSpread({}, acc), {}, _defineProperty({}, t, new _ReferencesProvider.default(queries, indexes[t])));
  }, {});
  return {
    parseTree: parseTree,
    referencesListener: referencesListener,
    errorListener: errorListener,
    referencesProviders: referencesProviders
  };
}
//# sourceMappingURL=parse.js.map