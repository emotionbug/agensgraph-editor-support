"use strict";

function _typeof(obj) { "@babel/helpers - typeof"; if (typeof Symbol === "function" && typeof Symbol.iterator === "symbol") { _typeof = function _typeof(obj) { return typeof obj; }; } else { _typeof = function _typeof(obj) { return obj && typeof Symbol === "function" && obj.constructor === Symbol && obj !== Symbol.prototype ? "symbol" : typeof obj; }; } return _typeof(obj); }

Object.defineProperty(exports, "__esModule", {
  value: true
});
exports.default = void 0;

var _antlr = _interopRequireDefault(require("antlr4"));

function _interopRequireDefault(obj) { return obj && obj.__esModule ? obj : { default: obj }; }

function _classCallCheck(instance, Constructor) { if (!(instance instanceof Constructor)) { throw new TypeError("Cannot call a class as a function"); } }

function _defineProperties(target, props) { for (var i = 0; i < props.length; i++) { var descriptor = props[i]; descriptor.enumerable = descriptor.enumerable || false; descriptor.configurable = true; if ("value" in descriptor) descriptor.writable = true; Object.defineProperty(target, descriptor.key, descriptor); } }

function _createClass(Constructor, protoProps, staticProps) { if (protoProps) _defineProperties(Constructor.prototype, protoProps); if (staticProps) _defineProperties(Constructor, staticProps); return Constructor; }

function _inherits(subClass, superClass) { if (typeof superClass !== "function" && superClass !== null) { throw new TypeError("Super expression must either be null or a function"); } subClass.prototype = Object.create(superClass && superClass.prototype, { constructor: { value: subClass, writable: true, configurable: true } }); if (superClass) _setPrototypeOf(subClass, superClass); }

function _setPrototypeOf(o, p) { _setPrototypeOf = Object.setPrototypeOf || function _setPrototypeOf(o, p) { o.__proto__ = p; return o; }; return _setPrototypeOf(o, p); }

function _createSuper(Derived) { var hasNativeReflectConstruct = _isNativeReflectConstruct(); return function _createSuperInternal() { var Super = _getPrototypeOf(Derived), result; if (hasNativeReflectConstruct) { var NewTarget = _getPrototypeOf(this).constructor; result = Reflect.construct(Super, arguments, NewTarget); } else { result = Super.apply(this, arguments); } return _possibleConstructorReturn(this, result); }; }

function _possibleConstructorReturn(self, call) { if (call && (_typeof(call) === "object" || typeof call === "function")) { return call; } return _assertThisInitialized(self); }

function _assertThisInitialized(self) { if (self === void 0) { throw new ReferenceError("this hasn't been initialised - super() hasn't been called"); } return self; }

function _isNativeReflectConstruct() { if (typeof Reflect === "undefined" || !Reflect.construct) return false; if (Reflect.construct.sham) return false; if (typeof Proxy === "function") return true; try { Boolean.prototype.valueOf.call(Reflect.construct(Boolean, [], function () {})); return true; } catch (e) { return false; } }

function _getPrototypeOf(o) { _getPrototypeOf = Object.setPrototypeOf ? Object.getPrototypeOf : function _getPrototypeOf(o) { return o.__proto__ || Object.getPrototypeOf(o); }; return _getPrototypeOf(o); }

// This class defines a complete listener for a parse tree produced by CypherParser.
var CypherListener = /*#__PURE__*/function (_antlr4$tree$ParseTre) {
  _inherits(CypherListener, _antlr4$tree$ParseTre);

  var _super = _createSuper(CypherListener);

  function CypherListener() {
    _classCallCheck(this, CypherListener);

    return _super.apply(this, arguments);
  }

  _createClass(CypherListener, [{
    key: "enterRaw",
    value: // Enter a parse tree produced by CypherParser#raw.
    function enterRaw(ctx) {} // Exit a parse tree produced by CypherParser#raw.

  }, {
    key: "exitRaw",
    value: function exitRaw(ctx) {} // Enter a parse tree produced by CypherParser#cypher.

  }, {
    key: "enterCypher",
    value: function enterCypher(ctx) {} // Exit a parse tree produced by CypherParser#cypher.

  }, {
    key: "exitCypher",
    value: function exitCypher(ctx) {} // Enter a parse tree produced by CypherParser#cypherPart.

  }, {
    key: "enterCypherPart",
    value: function enterCypherPart(ctx) {} // Exit a parse tree produced by CypherParser#cypherPart.

  }, {
    key: "exitCypherPart",
    value: function exitCypherPart(ctx) {} // Enter a parse tree produced by CypherParser#cypherConsoleCommand.

  }, {
    key: "enterCypherConsoleCommand",
    value: function enterCypherConsoleCommand(ctx) {} // Exit a parse tree produced by CypherParser#cypherConsoleCommand.

  }, {
    key: "exitCypherConsoleCommand",
    value: function exitCypherConsoleCommand(ctx) {} // Enter a parse tree produced by CypherParser#cypherConsoleCommandName.

  }, {
    key: "enterCypherConsoleCommandName",
    value: function enterCypherConsoleCommandName(ctx) {} // Exit a parse tree produced by CypherParser#cypherConsoleCommandName.

  }, {
    key: "exitCypherConsoleCommandName",
    value: function exitCypherConsoleCommandName(ctx) {} // Enter a parse tree produced by CypherParser#cypherConsoleCommandParameters.

  }, {
    key: "enterCypherConsoleCommandParameters",
    value: function enterCypherConsoleCommandParameters(ctx) {} // Exit a parse tree produced by CypherParser#cypherConsoleCommandParameters.

  }, {
    key: "exitCypherConsoleCommandParameters",
    value: function exitCypherConsoleCommandParameters(ctx) {} // Enter a parse tree produced by CypherParser#cypherConsoleCommandParameter.

  }, {
    key: "enterCypherConsoleCommandParameter",
    value: function enterCypherConsoleCommandParameter(ctx) {} // Exit a parse tree produced by CypherParser#cypherConsoleCommandParameter.

  }, {
    key: "exitCypherConsoleCommandParameter",
    value: function exitCypherConsoleCommandParameter(ctx) {} // Enter a parse tree produced by CypherParser#arrowExpression.

  }, {
    key: "enterArrowExpression",
    value: function enterArrowExpression(ctx) {} // Exit a parse tree produced by CypherParser#arrowExpression.

  }, {
    key: "exitArrowExpression",
    value: function exitArrowExpression(ctx) {} // Enter a parse tree produced by CypherParser#url.

  }, {
    key: "enterUrl",
    value: function enterUrl(ctx) {} // Exit a parse tree produced by CypherParser#url.

  }, {
    key: "exitUrl",
    value: function exitUrl(ctx) {} // Enter a parse tree produced by CypherParser#uri.

  }, {
    key: "enterUri",
    value: function enterUri(ctx) {} // Exit a parse tree produced by CypherParser#uri.

  }, {
    key: "exitUri",
    value: function exitUri(ctx) {} // Enter a parse tree produced by CypherParser#scheme.

  }, {
    key: "enterScheme",
    value: function enterScheme(ctx) {} // Exit a parse tree produced by CypherParser#scheme.

  }, {
    key: "exitScheme",
    value: function exitScheme(ctx) {} // Enter a parse tree produced by CypherParser#host.

  }, {
    key: "enterHost",
    value: function enterHost(ctx) {} // Exit a parse tree produced by CypherParser#host.

  }, {
    key: "exitHost",
    value: function exitHost(ctx) {} // Enter a parse tree produced by CypherParser#hostname.

  }, {
    key: "enterHostname",
    value: function enterHostname(ctx) {} // Exit a parse tree produced by CypherParser#hostname.

  }, {
    key: "exitHostname",
    value: function exitHostname(ctx) {} // Enter a parse tree produced by CypherParser#hostnumber.

  }, {
    key: "enterHostnumber",
    value: function enterHostnumber(ctx) {} // Exit a parse tree produced by CypherParser#hostnumber.

  }, {
    key: "exitHostnumber",
    value: function exitHostnumber(ctx) {} // Enter a parse tree produced by CypherParser#port.

  }, {
    key: "enterPort",
    value: function enterPort(ctx) {} // Exit a parse tree produced by CypherParser#port.

  }, {
    key: "exitPort",
    value: function exitPort(ctx) {} // Enter a parse tree produced by CypherParser#path.

  }, {
    key: "enterPath",
    value: function enterPath(ctx) {} // Exit a parse tree produced by CypherParser#path.

  }, {
    key: "exitPath",
    value: function exitPath(ctx) {} // Enter a parse tree produced by CypherParser#user.

  }, {
    key: "enterUser",
    value: function enterUser(ctx) {} // Exit a parse tree produced by CypherParser#user.

  }, {
    key: "exitUser",
    value: function exitUser(ctx) {} // Enter a parse tree produced by CypherParser#login.

  }, {
    key: "enterLogin",
    value: function enterLogin(ctx) {} // Exit a parse tree produced by CypherParser#login.

  }, {
    key: "exitLogin",
    value: function exitLogin(ctx) {} // Enter a parse tree produced by CypherParser#password.

  }, {
    key: "enterPassword",
    value: function enterPassword(ctx) {} // Exit a parse tree produced by CypherParser#password.

  }, {
    key: "exitPassword",
    value: function exitPassword(ctx) {} // Enter a parse tree produced by CypherParser#frag.

  }, {
    key: "enterFrag",
    value: function enterFrag(ctx) {} // Exit a parse tree produced by CypherParser#frag.

  }, {
    key: "exitFrag",
    value: function exitFrag(ctx) {} // Enter a parse tree produced by CypherParser#urlQuery.

  }, {
    key: "enterUrlQuery",
    value: function enterUrlQuery(ctx) {} // Exit a parse tree produced by CypherParser#urlQuery.

  }, {
    key: "exitUrlQuery",
    value: function exitUrlQuery(ctx) {} // Enter a parse tree produced by CypherParser#search.

  }, {
    key: "enterSearch",
    value: function enterSearch(ctx) {} // Exit a parse tree produced by CypherParser#search.

  }, {
    key: "exitSearch",
    value: function exitSearch(ctx) {} // Enter a parse tree produced by CypherParser#searchparameter.

  }, {
    key: "enterSearchparameter",
    value: function enterSearchparameter(ctx) {} // Exit a parse tree produced by CypherParser#searchparameter.

  }, {
    key: "exitSearchparameter",
    value: function exitSearchparameter(ctx) {} // Enter a parse tree produced by CypherParser#string.

  }, {
    key: "enterString",
    value: function enterString(ctx) {} // Exit a parse tree produced by CypherParser#string.

  }, {
    key: "exitString",
    value: function exitString(ctx) {} // Enter a parse tree produced by CypherParser#urlDigits.

  }, {
    key: "enterUrlDigits",
    value: function enterUrlDigits(ctx) {} // Exit a parse tree produced by CypherParser#urlDigits.

  }, {
    key: "exitUrlDigits",
    value: function exitUrlDigits(ctx) {} // Enter a parse tree produced by CypherParser#json.

  }, {
    key: "enterJson",
    value: function enterJson(ctx) {} // Exit a parse tree produced by CypherParser#json.

  }, {
    key: "exitJson",
    value: function exitJson(ctx) {} // Enter a parse tree produced by CypherParser#obj.

  }, {
    key: "enterObj",
    value: function enterObj(ctx) {} // Exit a parse tree produced by CypherParser#obj.

  }, {
    key: "exitObj",
    value: function exitObj(ctx) {} // Enter a parse tree produced by CypherParser#pair.

  }, {
    key: "enterPair",
    value: function enterPair(ctx) {} // Exit a parse tree produced by CypherParser#pair.

  }, {
    key: "exitPair",
    value: function exitPair(ctx) {} // Enter a parse tree produced by CypherParser#array.

  }, {
    key: "enterArray",
    value: function enterArray(ctx) {} // Exit a parse tree produced by CypherParser#array.

  }, {
    key: "exitArray",
    value: function exitArray(ctx) {} // Enter a parse tree produced by CypherParser#value.

  }, {
    key: "enterValue",
    value: function enterValue(ctx) {} // Exit a parse tree produced by CypherParser#value.

  }, {
    key: "exitValue",
    value: function exitValue(ctx) {} // Enter a parse tree produced by CypherParser#keyValueLiteral.

  }, {
    key: "enterKeyValueLiteral",
    value: function enterKeyValueLiteral(ctx) {} // Exit a parse tree produced by CypherParser#keyValueLiteral.

  }, {
    key: "exitKeyValueLiteral",
    value: function exitKeyValueLiteral(ctx) {} // Enter a parse tree produced by CypherParser#commandPath.

  }, {
    key: "enterCommandPath",
    value: function enterCommandPath(ctx) {} // Exit a parse tree produced by CypherParser#commandPath.

  }, {
    key: "exitCommandPath",
    value: function exitCommandPath(ctx) {} // Enter a parse tree produced by CypherParser#subCommand.

  }, {
    key: "enterSubCommand",
    value: function enterSubCommand(ctx) {} // Exit a parse tree produced by CypherParser#subCommand.

  }, {
    key: "exitSubCommand",
    value: function exitSubCommand(ctx) {} // Enter a parse tree produced by CypherParser#cypherQuery.

  }, {
    key: "enterCypherQuery",
    value: function enterCypherQuery(ctx) {} // Exit a parse tree produced by CypherParser#cypherQuery.

  }, {
    key: "exitCypherQuery",
    value: function exitCypherQuery(ctx) {} // Enter a parse tree produced by CypherParser#queryOptions.

  }, {
    key: "enterQueryOptions",
    value: function enterQueryOptions(ctx) {} // Exit a parse tree produced by CypherParser#queryOptions.

  }, {
    key: "exitQueryOptions",
    value: function exitQueryOptions(ctx) {} // Enter a parse tree produced by CypherParser#anyCypherOption.

  }, {
    key: "enterAnyCypherOption",
    value: function enterAnyCypherOption(ctx) {} // Exit a parse tree produced by CypherParser#anyCypherOption.

  }, {
    key: "exitAnyCypherOption",
    value: function exitAnyCypherOption(ctx) {} // Enter a parse tree produced by CypherParser#cypherOption.

  }, {
    key: "enterCypherOption",
    value: function enterCypherOption(ctx) {} // Exit a parse tree produced by CypherParser#cypherOption.

  }, {
    key: "exitCypherOption",
    value: function exitCypherOption(ctx) {} // Enter a parse tree produced by CypherParser#versionNumber.

  }, {
    key: "enterVersionNumber",
    value: function enterVersionNumber(ctx) {} // Exit a parse tree produced by CypherParser#versionNumber.

  }, {
    key: "exitVersionNumber",
    value: function exitVersionNumber(ctx) {} // Enter a parse tree produced by CypherParser#explain.

  }, {
    key: "enterExplain",
    value: function enterExplain(ctx) {} // Exit a parse tree produced by CypherParser#explain.

  }, {
    key: "exitExplain",
    value: function exitExplain(ctx) {} // Enter a parse tree produced by CypherParser#profile.

  }, {
    key: "enterProfile",
    value: function enterProfile(ctx) {} // Exit a parse tree produced by CypherParser#profile.

  }, {
    key: "exitProfile",
    value: function exitProfile(ctx) {} // Enter a parse tree produced by CypherParser#configurationOption.

  }, {
    key: "enterConfigurationOption",
    value: function enterConfigurationOption(ctx) {} // Exit a parse tree produced by CypherParser#configurationOption.

  }, {
    key: "exitConfigurationOption",
    value: function exitConfigurationOption(ctx) {} // Enter a parse tree produced by CypherParser#statement.

  }, {
    key: "enterStatement",
    value: function enterStatement(ctx) {} // Exit a parse tree produced by CypherParser#statement.

  }, {
    key: "exitStatement",
    value: function exitStatement(ctx) {} // Enter a parse tree produced by CypherParser#query.

  }, {
    key: "enterQuery",
    value: function enterQuery(ctx) {} // Exit a parse tree produced by CypherParser#query.

  }, {
    key: "exitQuery",
    value: function exitQuery(ctx) {} // Enter a parse tree produced by CypherParser#regularQuery.

  }, {
    key: "enterRegularQuery",
    value: function enterRegularQuery(ctx) {} // Exit a parse tree produced by CypherParser#regularQuery.

  }, {
    key: "exitRegularQuery",
    value: function exitRegularQuery(ctx) {} // Enter a parse tree produced by CypherParser#bulkImportQuery.

  }, {
    key: "enterBulkImportQuery",
    value: function enterBulkImportQuery(ctx) {} // Exit a parse tree produced by CypherParser#bulkImportQuery.

  }, {
    key: "exitBulkImportQuery",
    value: function exitBulkImportQuery(ctx) {} // Enter a parse tree produced by CypherParser#singleQuery.

  }, {
    key: "enterSingleQuery",
    value: function enterSingleQuery(ctx) {} // Exit a parse tree produced by CypherParser#singleQuery.

  }, {
    key: "exitSingleQuery",
    value: function exitSingleQuery(ctx) {} // Enter a parse tree produced by CypherParser#periodicCommitHint.

  }, {
    key: "enterPeriodicCommitHint",
    value: function enterPeriodicCommitHint(ctx) {} // Exit a parse tree produced by CypherParser#periodicCommitHint.

  }, {
    key: "exitPeriodicCommitHint",
    value: function exitPeriodicCommitHint(ctx) {} // Enter a parse tree produced by CypherParser#loadCSVQuery.

  }, {
    key: "enterLoadCSVQuery",
    value: function enterLoadCSVQuery(ctx) {} // Exit a parse tree produced by CypherParser#loadCSVQuery.

  }, {
    key: "exitLoadCSVQuery",
    value: function exitLoadCSVQuery(ctx) {} // Enter a parse tree produced by CypherParser#union.

  }, {
    key: "enterUnion",
    value: function enterUnion(ctx) {} // Exit a parse tree produced by CypherParser#union.

  }, {
    key: "exitUnion",
    value: function exitUnion(ctx) {} // Enter a parse tree produced by CypherParser#clause.

  }, {
    key: "enterClause",
    value: function enterClause(ctx) {} // Exit a parse tree produced by CypherParser#clause.

  }, {
    key: "exitClause",
    value: function exitClause(ctx) {} // Enter a parse tree produced by CypherParser#command.

  }, {
    key: "enterCommand",
    value: function enterCommand(ctx) {} // Exit a parse tree produced by CypherParser#command.

  }, {
    key: "exitCommand",
    value: function exitCommand(ctx) {} // Enter a parse tree produced by CypherParser#createUniqueConstraint.

  }, {
    key: "enterCreateUniqueConstraint",
    value: function enterCreateUniqueConstraint(ctx) {} // Exit a parse tree produced by CypherParser#createUniqueConstraint.

  }, {
    key: "exitCreateUniqueConstraint",
    value: function exitCreateUniqueConstraint(ctx) {} // Enter a parse tree produced by CypherParser#createNodeKeyConstraint.

  }, {
    key: "enterCreateNodeKeyConstraint",
    value: function enterCreateNodeKeyConstraint(ctx) {} // Exit a parse tree produced by CypherParser#createNodeKeyConstraint.

  }, {
    key: "exitCreateNodeKeyConstraint",
    value: function exitCreateNodeKeyConstraint(ctx) {} // Enter a parse tree produced by CypherParser#createNodePropertyExistenceConstraint.

  }, {
    key: "enterCreateNodePropertyExistenceConstraint",
    value: function enterCreateNodePropertyExistenceConstraint(ctx) {} // Exit a parse tree produced by CypherParser#createNodePropertyExistenceConstraint.

  }, {
    key: "exitCreateNodePropertyExistenceConstraint",
    value: function exitCreateNodePropertyExistenceConstraint(ctx) {} // Enter a parse tree produced by CypherParser#createRelationshipPropertyExistenceConstraint.

  }, {
    key: "enterCreateRelationshipPropertyExistenceConstraint",
    value: function enterCreateRelationshipPropertyExistenceConstraint(ctx) {} // Exit a parse tree produced by CypherParser#createRelationshipPropertyExistenceConstraint.

  }, {
    key: "exitCreateRelationshipPropertyExistenceConstraint",
    value: function exitCreateRelationshipPropertyExistenceConstraint(ctx) {} // Enter a parse tree produced by CypherParser#createIndex.

  }, {
    key: "enterCreateIndex",
    value: function enterCreateIndex(ctx) {} // Exit a parse tree produced by CypherParser#createIndex.

  }, {
    key: "exitCreateIndex",
    value: function exitCreateIndex(ctx) {} // Enter a parse tree produced by CypherParser#dropUniqueConstraint.

  }, {
    key: "enterDropUniqueConstraint",
    value: function enterDropUniqueConstraint(ctx) {} // Exit a parse tree produced by CypherParser#dropUniqueConstraint.

  }, {
    key: "exitDropUniqueConstraint",
    value: function exitDropUniqueConstraint(ctx) {} // Enter a parse tree produced by CypherParser#dropNodeKeyConstraint.

  }, {
    key: "enterDropNodeKeyConstraint",
    value: function enterDropNodeKeyConstraint(ctx) {} // Exit a parse tree produced by CypherParser#dropNodeKeyConstraint.

  }, {
    key: "exitDropNodeKeyConstraint",
    value: function exitDropNodeKeyConstraint(ctx) {} // Enter a parse tree produced by CypherParser#dropNodePropertyExistenceConstraint.

  }, {
    key: "enterDropNodePropertyExistenceConstraint",
    value: function enterDropNodePropertyExistenceConstraint(ctx) {} // Exit a parse tree produced by CypherParser#dropNodePropertyExistenceConstraint.

  }, {
    key: "exitDropNodePropertyExistenceConstraint",
    value: function exitDropNodePropertyExistenceConstraint(ctx) {} // Enter a parse tree produced by CypherParser#dropRelationshipPropertyExistenceConstraint.

  }, {
    key: "enterDropRelationshipPropertyExistenceConstraint",
    value: function enterDropRelationshipPropertyExistenceConstraint(ctx) {} // Exit a parse tree produced by CypherParser#dropRelationshipPropertyExistenceConstraint.

  }, {
    key: "exitDropRelationshipPropertyExistenceConstraint",
    value: function exitDropRelationshipPropertyExistenceConstraint(ctx) {} // Enter a parse tree produced by CypherParser#dropIndex.

  }, {
    key: "enterDropIndex",
    value: function enterDropIndex(ctx) {} // Exit a parse tree produced by CypherParser#dropIndex.

  }, {
    key: "exitDropIndex",
    value: function exitDropIndex(ctx) {} // Enter a parse tree produced by CypherParser#index.

  }, {
    key: "enterIndex",
    value: function enterIndex(ctx) {} // Exit a parse tree produced by CypherParser#index.

  }, {
    key: "exitIndex",
    value: function exitIndex(ctx) {} // Enter a parse tree produced by CypherParser#uniqueConstraint.

  }, {
    key: "enterUniqueConstraint",
    value: function enterUniqueConstraint(ctx) {} // Exit a parse tree produced by CypherParser#uniqueConstraint.

  }, {
    key: "exitUniqueConstraint",
    value: function exitUniqueConstraint(ctx) {} // Enter a parse tree produced by CypherParser#nodeKeyConstraint.

  }, {
    key: "enterNodeKeyConstraint",
    value: function enterNodeKeyConstraint(ctx) {} // Exit a parse tree produced by CypherParser#nodeKeyConstraint.

  }, {
    key: "exitNodeKeyConstraint",
    value: function exitNodeKeyConstraint(ctx) {} // Enter a parse tree produced by CypherParser#nodePropertyExistenceConstraint.

  }, {
    key: "enterNodePropertyExistenceConstraint",
    value: function enterNodePropertyExistenceConstraint(ctx) {} // Exit a parse tree produced by CypherParser#nodePropertyExistenceConstraint.

  }, {
    key: "exitNodePropertyExistenceConstraint",
    value: function exitNodePropertyExistenceConstraint(ctx) {} // Enter a parse tree produced by CypherParser#relationshipPropertyExistenceConstraint.

  }, {
    key: "enterRelationshipPropertyExistenceConstraint",
    value: function enterRelationshipPropertyExistenceConstraint(ctx) {} // Exit a parse tree produced by CypherParser#relationshipPropertyExistenceConstraint.

  }, {
    key: "exitRelationshipPropertyExistenceConstraint",
    value: function exitRelationshipPropertyExistenceConstraint(ctx) {} // Enter a parse tree produced by CypherParser#relationshipPatternSyntax.

  }, {
    key: "enterRelationshipPatternSyntax",
    value: function enterRelationshipPatternSyntax(ctx) {} // Exit a parse tree produced by CypherParser#relationshipPatternSyntax.

  }, {
    key: "exitRelationshipPatternSyntax",
    value: function exitRelationshipPatternSyntax(ctx) {} // Enter a parse tree produced by CypherParser#loadCSVClause.

  }, {
    key: "enterLoadCSVClause",
    value: function enterLoadCSVClause(ctx) {} // Exit a parse tree produced by CypherParser#loadCSVClause.

  }, {
    key: "exitLoadCSVClause",
    value: function exitLoadCSVClause(ctx) {} // Enter a parse tree produced by CypherParser#matchClause.

  }, {
    key: "enterMatchClause",
    value: function enterMatchClause(ctx) {} // Exit a parse tree produced by CypherParser#matchClause.

  }, {
    key: "exitMatchClause",
    value: function exitMatchClause(ctx) {} // Enter a parse tree produced by CypherParser#unwindClause.

  }, {
    key: "enterUnwindClause",
    value: function enterUnwindClause(ctx) {} // Exit a parse tree produced by CypherParser#unwindClause.

  }, {
    key: "exitUnwindClause",
    value: function exitUnwindClause(ctx) {} // Enter a parse tree produced by CypherParser#mergeClause.

  }, {
    key: "enterMergeClause",
    value: function enterMergeClause(ctx) {} // Exit a parse tree produced by CypherParser#mergeClause.

  }, {
    key: "exitMergeClause",
    value: function exitMergeClause(ctx) {} // Enter a parse tree produced by CypherParser#mergeAction.

  }, {
    key: "enterMergeAction",
    value: function enterMergeAction(ctx) {} // Exit a parse tree produced by CypherParser#mergeAction.

  }, {
    key: "exitMergeAction",
    value: function exitMergeAction(ctx) {} // Enter a parse tree produced by CypherParser#createClause.

  }, {
    key: "enterCreateClause",
    value: function enterCreateClause(ctx) {} // Exit a parse tree produced by CypherParser#createClause.

  }, {
    key: "exitCreateClause",
    value: function exitCreateClause(ctx) {} // Enter a parse tree produced by CypherParser#createUniqueClause.

  }, {
    key: "enterCreateUniqueClause",
    value: function enterCreateUniqueClause(ctx) {} // Exit a parse tree produced by CypherParser#createUniqueClause.

  }, {
    key: "exitCreateUniqueClause",
    value: function exitCreateUniqueClause(ctx) {} // Enter a parse tree produced by CypherParser#setClause.

  }, {
    key: "enterSetClause",
    value: function enterSetClause(ctx) {} // Exit a parse tree produced by CypherParser#setClause.

  }, {
    key: "exitSetClause",
    value: function exitSetClause(ctx) {} // Enter a parse tree produced by CypherParser#setItem.

  }, {
    key: "enterSetItem",
    value: function enterSetItem(ctx) {} // Exit a parse tree produced by CypherParser#setItem.

  }, {
    key: "exitSetItem",
    value: function exitSetItem(ctx) {} // Enter a parse tree produced by CypherParser#deleteClause.

  }, {
    key: "enterDeleteClause",
    value: function enterDeleteClause(ctx) {} // Exit a parse tree produced by CypherParser#deleteClause.

  }, {
    key: "exitDeleteClause",
    value: function exitDeleteClause(ctx) {} // Enter a parse tree produced by CypherParser#removeClause.

  }, {
    key: "enterRemoveClause",
    value: function enterRemoveClause(ctx) {} // Exit a parse tree produced by CypherParser#removeClause.

  }, {
    key: "exitRemoveClause",
    value: function exitRemoveClause(ctx) {} // Enter a parse tree produced by CypherParser#removeItem.

  }, {
    key: "enterRemoveItem",
    value: function enterRemoveItem(ctx) {} // Exit a parse tree produced by CypherParser#removeItem.

  }, {
    key: "exitRemoveItem",
    value: function exitRemoveItem(ctx) {} // Enter a parse tree produced by CypherParser#foreachClause.

  }, {
    key: "enterForeachClause",
    value: function enterForeachClause(ctx) {} // Exit a parse tree produced by CypherParser#foreachClause.

  }, {
    key: "exitForeachClause",
    value: function exitForeachClause(ctx) {} // Enter a parse tree produced by CypherParser#withClause.

  }, {
    key: "enterWithClause",
    value: function enterWithClause(ctx) {} // Exit a parse tree produced by CypherParser#withClause.

  }, {
    key: "exitWithClause",
    value: function exitWithClause(ctx) {} // Enter a parse tree produced by CypherParser#returnClause.

  }, {
    key: "enterReturnClause",
    value: function enterReturnClause(ctx) {} // Exit a parse tree produced by CypherParser#returnClause.

  }, {
    key: "exitReturnClause",
    value: function exitReturnClause(ctx) {} // Enter a parse tree produced by CypherParser#returnBody.

  }, {
    key: "enterReturnBody",
    value: function enterReturnBody(ctx) {} // Exit a parse tree produced by CypherParser#returnBody.

  }, {
    key: "exitReturnBody",
    value: function exitReturnBody(ctx) {} // Enter a parse tree produced by CypherParser#func.

  }, {
    key: "enterFunc",
    value: function enterFunc(ctx) {} // Exit a parse tree produced by CypherParser#func.

  }, {
    key: "exitFunc",
    value: function exitFunc(ctx) {} // Enter a parse tree produced by CypherParser#returnItems.

  }, {
    key: "enterReturnItems",
    value: function enterReturnItems(ctx) {} // Exit a parse tree produced by CypherParser#returnItems.

  }, {
    key: "exitReturnItems",
    value: function exitReturnItems(ctx) {} // Enter a parse tree produced by CypherParser#returnItem.

  }, {
    key: "enterReturnItem",
    value: function enterReturnItem(ctx) {} // Exit a parse tree produced by CypherParser#returnItem.

  }, {
    key: "exitReturnItem",
    value: function exitReturnItem(ctx) {} // Enter a parse tree produced by CypherParser#call.

  }, {
    key: "enterCall",
    value: function enterCall(ctx) {} // Exit a parse tree produced by CypherParser#call.

  }, {
    key: "exitCall",
    value: function exitCall(ctx) {} // Enter a parse tree produced by CypherParser#procedureInvocation.

  }, {
    key: "enterProcedureInvocation",
    value: function enterProcedureInvocation(ctx) {} // Exit a parse tree produced by CypherParser#procedureInvocation.

  }, {
    key: "exitProcedureInvocation",
    value: function exitProcedureInvocation(ctx) {} // Enter a parse tree produced by CypherParser#procedureInvocationBody.

  }, {
    key: "enterProcedureInvocationBody",
    value: function enterProcedureInvocationBody(ctx) {} // Exit a parse tree produced by CypherParser#procedureInvocationBody.

  }, {
    key: "exitProcedureInvocationBody",
    value: function exitProcedureInvocationBody(ctx) {} // Enter a parse tree produced by CypherParser#procedureArguments.

  }, {
    key: "enterProcedureArguments",
    value: function enterProcedureArguments(ctx) {} // Exit a parse tree produced by CypherParser#procedureArguments.

  }, {
    key: "exitProcedureArguments",
    value: function exitProcedureArguments(ctx) {} // Enter a parse tree produced by CypherParser#procedureResults.

  }, {
    key: "enterProcedureResults",
    value: function enterProcedureResults(ctx) {} // Exit a parse tree produced by CypherParser#procedureResults.

  }, {
    key: "exitProcedureResults",
    value: function exitProcedureResults(ctx) {} // Enter a parse tree produced by CypherParser#procedureResult.

  }, {
    key: "enterProcedureResult",
    value: function enterProcedureResult(ctx) {} // Exit a parse tree produced by CypherParser#procedureResult.

  }, {
    key: "exitProcedureResult",
    value: function exitProcedureResult(ctx) {} // Enter a parse tree produced by CypherParser#aliasedProcedureResult.

  }, {
    key: "enterAliasedProcedureResult",
    value: function enterAliasedProcedureResult(ctx) {} // Exit a parse tree produced by CypherParser#aliasedProcedureResult.

  }, {
    key: "exitAliasedProcedureResult",
    value: function exitAliasedProcedureResult(ctx) {} // Enter a parse tree produced by CypherParser#simpleProcedureResult.

  }, {
    key: "enterSimpleProcedureResult",
    value: function enterSimpleProcedureResult(ctx) {} // Exit a parse tree produced by CypherParser#simpleProcedureResult.

  }, {
    key: "exitSimpleProcedureResult",
    value: function exitSimpleProcedureResult(ctx) {} // Enter a parse tree produced by CypherParser#procedureOutput.

  }, {
    key: "enterProcedureOutput",
    value: function enterProcedureOutput(ctx) {} // Exit a parse tree produced by CypherParser#procedureOutput.

  }, {
    key: "exitProcedureOutput",
    value: function exitProcedureOutput(ctx) {} // Enter a parse tree produced by CypherParser#order.

  }, {
    key: "enterOrder",
    value: function enterOrder(ctx) {} // Exit a parse tree produced by CypherParser#order.

  }, {
    key: "exitOrder",
    value: function exitOrder(ctx) {} // Enter a parse tree produced by CypherParser#skip.

  }, {
    key: "enterSkip",
    value: function enterSkip(ctx) {} // Exit a parse tree produced by CypherParser#skip.

  }, {
    key: "exitSkip",
    value: function exitSkip(ctx) {} // Enter a parse tree produced by CypherParser#limit.

  }, {
    key: "enterLimit",
    value: function enterLimit(ctx) {} // Exit a parse tree produced by CypherParser#limit.

  }, {
    key: "exitLimit",
    value: function exitLimit(ctx) {} // Enter a parse tree produced by CypherParser#sortItem.

  }, {
    key: "enterSortItem",
    value: function enterSortItem(ctx) {} // Exit a parse tree produced by CypherParser#sortItem.

  }, {
    key: "exitSortItem",
    value: function exitSortItem(ctx) {} // Enter a parse tree produced by CypherParser#hint.

  }, {
    key: "enterHint",
    value: function enterHint(ctx) {} // Exit a parse tree produced by CypherParser#hint.

  }, {
    key: "exitHint",
    value: function exitHint(ctx) {} // Enter a parse tree produced by CypherParser#startClause.

  }, {
    key: "enterStartClause",
    value: function enterStartClause(ctx) {} // Exit a parse tree produced by CypherParser#startClause.

  }, {
    key: "exitStartClause",
    value: function exitStartClause(ctx) {} // Enter a parse tree produced by CypherParser#startPoint.

  }, {
    key: "enterStartPoint",
    value: function enterStartPoint(ctx) {} // Exit a parse tree produced by CypherParser#startPoint.

  }, {
    key: "exitStartPoint",
    value: function exitStartPoint(ctx) {} // Enter a parse tree produced by CypherParser#lookup.

  }, {
    key: "enterLookup",
    value: function enterLookup(ctx) {} // Exit a parse tree produced by CypherParser#lookup.

  }, {
    key: "exitLookup",
    value: function exitLookup(ctx) {} // Enter a parse tree produced by CypherParser#nodeLookup.

  }, {
    key: "enterNodeLookup",
    value: function enterNodeLookup(ctx) {} // Exit a parse tree produced by CypherParser#nodeLookup.

  }, {
    key: "exitNodeLookup",
    value: function exitNodeLookup(ctx) {} // Enter a parse tree produced by CypherParser#relationshipLookup.

  }, {
    key: "enterRelationshipLookup",
    value: function enterRelationshipLookup(ctx) {} // Exit a parse tree produced by CypherParser#relationshipLookup.

  }, {
    key: "exitRelationshipLookup",
    value: function exitRelationshipLookup(ctx) {} // Enter a parse tree produced by CypherParser#identifiedIndexLookup.

  }, {
    key: "enterIdentifiedIndexLookup",
    value: function enterIdentifiedIndexLookup(ctx) {} // Exit a parse tree produced by CypherParser#identifiedIndexLookup.

  }, {
    key: "exitIdentifiedIndexLookup",
    value: function exitIdentifiedIndexLookup(ctx) {} // Enter a parse tree produced by CypherParser#indexQuery.

  }, {
    key: "enterIndexQuery",
    value: function enterIndexQuery(ctx) {} // Exit a parse tree produced by CypherParser#indexQuery.

  }, {
    key: "exitIndexQuery",
    value: function exitIndexQuery(ctx) {} // Enter a parse tree produced by CypherParser#idLookup.

  }, {
    key: "enterIdLookup",
    value: function enterIdLookup(ctx) {} // Exit a parse tree produced by CypherParser#idLookup.

  }, {
    key: "exitIdLookup",
    value: function exitIdLookup(ctx) {} // Enter a parse tree produced by CypherParser#literalIds.

  }, {
    key: "enterLiteralIds",
    value: function enterLiteralIds(ctx) {} // Exit a parse tree produced by CypherParser#literalIds.

  }, {
    key: "exitLiteralIds",
    value: function exitLiteralIds(ctx) {} // Enter a parse tree produced by CypherParser#where.

  }, {
    key: "enterWhere",
    value: function enterWhere(ctx) {} // Exit a parse tree produced by CypherParser#where.

  }, {
    key: "exitWhere",
    value: function exitWhere(ctx) {} // Enter a parse tree produced by CypherParser#pattern.

  }, {
    key: "enterPattern",
    value: function enterPattern(ctx) {} // Exit a parse tree produced by CypherParser#pattern.

  }, {
    key: "exitPattern",
    value: function exitPattern(ctx) {} // Enter a parse tree produced by CypherParser#patternPart.

  }, {
    key: "enterPatternPart",
    value: function enterPatternPart(ctx) {} // Exit a parse tree produced by CypherParser#patternPart.

  }, {
    key: "exitPatternPart",
    value: function exitPatternPart(ctx) {} // Enter a parse tree produced by CypherParser#anonymousPatternPart.

  }, {
    key: "enterAnonymousPatternPart",
    value: function enterAnonymousPatternPart(ctx) {} // Exit a parse tree produced by CypherParser#anonymousPatternPart.

  }, {
    key: "exitAnonymousPatternPart",
    value: function exitAnonymousPatternPart(ctx) {} // Enter a parse tree produced by CypherParser#patternElement.

  }, {
    key: "enterPatternElement",
    value: function enterPatternElement(ctx) {} // Exit a parse tree produced by CypherParser#patternElement.

  }, {
    key: "exitPatternElement",
    value: function exitPatternElement(ctx) {} // Enter a parse tree produced by CypherParser#nodePattern.

  }, {
    key: "enterNodePattern",
    value: function enterNodePattern(ctx) {} // Exit a parse tree produced by CypherParser#nodePattern.

  }, {
    key: "exitNodePattern",
    value: function exitNodePattern(ctx) {} // Enter a parse tree produced by CypherParser#patternElementChain.

  }, {
    key: "enterPatternElementChain",
    value: function enterPatternElementChain(ctx) {} // Exit a parse tree produced by CypherParser#patternElementChain.

  }, {
    key: "exitPatternElementChain",
    value: function exitPatternElementChain(ctx) {} // Enter a parse tree produced by CypherParser#relationshipPattern.

  }, {
    key: "enterRelationshipPattern",
    value: function enterRelationshipPattern(ctx) {} // Exit a parse tree produced by CypherParser#relationshipPattern.

  }, {
    key: "exitRelationshipPattern",
    value: function exitRelationshipPattern(ctx) {} // Enter a parse tree produced by CypherParser#relationshipPatternStart.

  }, {
    key: "enterRelationshipPatternStart",
    value: function enterRelationshipPatternStart(ctx) {} // Exit a parse tree produced by CypherParser#relationshipPatternStart.

  }, {
    key: "exitRelationshipPatternStart",
    value: function exitRelationshipPatternStart(ctx) {} // Enter a parse tree produced by CypherParser#relationshipPatternEnd.

  }, {
    key: "enterRelationshipPatternEnd",
    value: function enterRelationshipPatternEnd(ctx) {} // Exit a parse tree produced by CypherParser#relationshipPatternEnd.

  }, {
    key: "exitRelationshipPatternEnd",
    value: function exitRelationshipPatternEnd(ctx) {} // Enter a parse tree produced by CypherParser#relationshipDetail.

  }, {
    key: "enterRelationshipDetail",
    value: function enterRelationshipDetail(ctx) {} // Exit a parse tree produced by CypherParser#relationshipDetail.

  }, {
    key: "exitRelationshipDetail",
    value: function exitRelationshipDetail(ctx) {} // Enter a parse tree produced by CypherParser#properties.

  }, {
    key: "enterProperties",
    value: function enterProperties(ctx) {} // Exit a parse tree produced by CypherParser#properties.

  }, {
    key: "exitProperties",
    value: function exitProperties(ctx) {} // Enter a parse tree produced by CypherParser#relType.

  }, {
    key: "enterRelType",
    value: function enterRelType(ctx) {} // Exit a parse tree produced by CypherParser#relType.

  }, {
    key: "exitRelType",
    value: function exitRelType(ctx) {} // Enter a parse tree produced by CypherParser#relationshipTypes.

  }, {
    key: "enterRelationshipTypes",
    value: function enterRelationshipTypes(ctx) {} // Exit a parse tree produced by CypherParser#relationshipTypes.

  }, {
    key: "exitRelationshipTypes",
    value: function exitRelationshipTypes(ctx) {} // Enter a parse tree produced by CypherParser#relationshipType.

  }, {
    key: "enterRelationshipType",
    value: function enterRelationshipType(ctx) {} // Exit a parse tree produced by CypherParser#relationshipType.

  }, {
    key: "exitRelationshipType",
    value: function exitRelationshipType(ctx) {} // Enter a parse tree produced by CypherParser#relationshipTypeOptionalColon.

  }, {
    key: "enterRelationshipTypeOptionalColon",
    value: function enterRelationshipTypeOptionalColon(ctx) {} // Exit a parse tree produced by CypherParser#relationshipTypeOptionalColon.

  }, {
    key: "exitRelationshipTypeOptionalColon",
    value: function exitRelationshipTypeOptionalColon(ctx) {} // Enter a parse tree produced by CypherParser#nodeLabels.

  }, {
    key: "enterNodeLabels",
    value: function enterNodeLabels(ctx) {} // Exit a parse tree produced by CypherParser#nodeLabels.

  }, {
    key: "exitNodeLabels",
    value: function exitNodeLabels(ctx) {} // Enter a parse tree produced by CypherParser#nodeLabel.

  }, {
    key: "enterNodeLabel",
    value: function enterNodeLabel(ctx) {} // Exit a parse tree produced by CypherParser#nodeLabel.

  }, {
    key: "exitNodeLabel",
    value: function exitNodeLabel(ctx) {} // Enter a parse tree produced by CypherParser#rangeLiteral.

  }, {
    key: "enterRangeLiteral",
    value: function enterRangeLiteral(ctx) {} // Exit a parse tree produced by CypherParser#rangeLiteral.

  }, {
    key: "exitRangeLiteral",
    value: function exitRangeLiteral(ctx) {} // Enter a parse tree produced by CypherParser#labelName.

  }, {
    key: "enterLabelName",
    value: function enterLabelName(ctx) {} // Exit a parse tree produced by CypherParser#labelName.

  }, {
    key: "exitLabelName",
    value: function exitLabelName(ctx) {} // Enter a parse tree produced by CypherParser#relTypeName.

  }, {
    key: "enterRelTypeName",
    value: function enterRelTypeName(ctx) {} // Exit a parse tree produced by CypherParser#relTypeName.

  }, {
    key: "exitRelTypeName",
    value: function exitRelTypeName(ctx) {} // Enter a parse tree produced by CypherParser#expression.

  }, {
    key: "enterExpression",
    value: function enterExpression(ctx) {} // Exit a parse tree produced by CypherParser#expression.

  }, {
    key: "exitExpression",
    value: function exitExpression(ctx) {} // Enter a parse tree produced by CypherParser#orExpression.

  }, {
    key: "enterOrExpression",
    value: function enterOrExpression(ctx) {} // Exit a parse tree produced by CypherParser#orExpression.

  }, {
    key: "exitOrExpression",
    value: function exitOrExpression(ctx) {} // Enter a parse tree produced by CypherParser#xorExpression.

  }, {
    key: "enterXorExpression",
    value: function enterXorExpression(ctx) {} // Exit a parse tree produced by CypherParser#xorExpression.

  }, {
    key: "exitXorExpression",
    value: function exitXorExpression(ctx) {} // Enter a parse tree produced by CypherParser#andExpression.

  }, {
    key: "enterAndExpression",
    value: function enterAndExpression(ctx) {} // Exit a parse tree produced by CypherParser#andExpression.

  }, {
    key: "exitAndExpression",
    value: function exitAndExpression(ctx) {} // Enter a parse tree produced by CypherParser#notExpression.

  }, {
    key: "enterNotExpression",
    value: function enterNotExpression(ctx) {} // Exit a parse tree produced by CypherParser#notExpression.

  }, {
    key: "exitNotExpression",
    value: function exitNotExpression(ctx) {} // Enter a parse tree produced by CypherParser#comparisonExpression.

  }, {
    key: "enterComparisonExpression",
    value: function enterComparisonExpression(ctx) {} // Exit a parse tree produced by CypherParser#comparisonExpression.

  }, {
    key: "exitComparisonExpression",
    value: function exitComparisonExpression(ctx) {} // Enter a parse tree produced by CypherParser#addOrSubtractExpression.

  }, {
    key: "enterAddOrSubtractExpression",
    value: function enterAddOrSubtractExpression(ctx) {} // Exit a parse tree produced by CypherParser#addOrSubtractExpression.

  }, {
    key: "exitAddOrSubtractExpression",
    value: function exitAddOrSubtractExpression(ctx) {} // Enter a parse tree produced by CypherParser#multiplyDivideModuloExpression.

  }, {
    key: "enterMultiplyDivideModuloExpression",
    value: function enterMultiplyDivideModuloExpression(ctx) {} // Exit a parse tree produced by CypherParser#multiplyDivideModuloExpression.

  }, {
    key: "exitMultiplyDivideModuloExpression",
    value: function exitMultiplyDivideModuloExpression(ctx) {} // Enter a parse tree produced by CypherParser#powerOfExpression.

  }, {
    key: "enterPowerOfExpression",
    value: function enterPowerOfExpression(ctx) {} // Exit a parse tree produced by CypherParser#powerOfExpression.

  }, {
    key: "exitPowerOfExpression",
    value: function exitPowerOfExpression(ctx) {} // Enter a parse tree produced by CypherParser#unaryAddOrSubtractExpression.

  }, {
    key: "enterUnaryAddOrSubtractExpression",
    value: function enterUnaryAddOrSubtractExpression(ctx) {} // Exit a parse tree produced by CypherParser#unaryAddOrSubtractExpression.

  }, {
    key: "exitUnaryAddOrSubtractExpression",
    value: function exitUnaryAddOrSubtractExpression(ctx) {} // Enter a parse tree produced by CypherParser#stringListNullOperatorExpression.

  }, {
    key: "enterStringListNullOperatorExpression",
    value: function enterStringListNullOperatorExpression(ctx) {} // Exit a parse tree produced by CypherParser#stringListNullOperatorExpression.

  }, {
    key: "exitStringListNullOperatorExpression",
    value: function exitStringListNullOperatorExpression(ctx) {} // Enter a parse tree produced by CypherParser#propertyOrLabelsExpression.

  }, {
    key: "enterPropertyOrLabelsExpression",
    value: function enterPropertyOrLabelsExpression(ctx) {} // Exit a parse tree produced by CypherParser#propertyOrLabelsExpression.

  }, {
    key: "exitPropertyOrLabelsExpression",
    value: function exitPropertyOrLabelsExpression(ctx) {} // Enter a parse tree produced by CypherParser#filterFunction.

  }, {
    key: "enterFilterFunction",
    value: function enterFilterFunction(ctx) {} // Exit a parse tree produced by CypherParser#filterFunction.

  }, {
    key: "exitFilterFunction",
    value: function exitFilterFunction(ctx) {} // Enter a parse tree produced by CypherParser#filterFunctionName.

  }, {
    key: "enterFilterFunctionName",
    value: function enterFilterFunctionName(ctx) {} // Exit a parse tree produced by CypherParser#filterFunctionName.

  }, {
    key: "exitFilterFunctionName",
    value: function exitFilterFunctionName(ctx) {} // Enter a parse tree produced by CypherParser#existsFunction.

  }, {
    key: "enterExistsFunction",
    value: function enterExistsFunction(ctx) {} // Exit a parse tree produced by CypherParser#existsFunction.

  }, {
    key: "exitExistsFunction",
    value: function exitExistsFunction(ctx) {} // Enter a parse tree produced by CypherParser#existsFunctionName.

  }, {
    key: "enterExistsFunctionName",
    value: function enterExistsFunctionName(ctx) {} // Exit a parse tree produced by CypherParser#existsFunctionName.

  }, {
    key: "exitExistsFunctionName",
    value: function exitExistsFunctionName(ctx) {} // Enter a parse tree produced by CypherParser#allFunction.

  }, {
    key: "enterAllFunction",
    value: function enterAllFunction(ctx) {} // Exit a parse tree produced by CypherParser#allFunction.

  }, {
    key: "exitAllFunction",
    value: function exitAllFunction(ctx) {} // Enter a parse tree produced by CypherParser#allFunctionName.

  }, {
    key: "enterAllFunctionName",
    value: function enterAllFunctionName(ctx) {} // Exit a parse tree produced by CypherParser#allFunctionName.

  }, {
    key: "exitAllFunctionName",
    value: function exitAllFunctionName(ctx) {} // Enter a parse tree produced by CypherParser#anyFunction.

  }, {
    key: "enterAnyFunction",
    value: function enterAnyFunction(ctx) {} // Exit a parse tree produced by CypherParser#anyFunction.

  }, {
    key: "exitAnyFunction",
    value: function exitAnyFunction(ctx) {} // Enter a parse tree produced by CypherParser#anyFunctionName.

  }, {
    key: "enterAnyFunctionName",
    value: function enterAnyFunctionName(ctx) {} // Exit a parse tree produced by CypherParser#anyFunctionName.

  }, {
    key: "exitAnyFunctionName",
    value: function exitAnyFunctionName(ctx) {} // Enter a parse tree produced by CypherParser#noneFunction.

  }, {
    key: "enterNoneFunction",
    value: function enterNoneFunction(ctx) {} // Exit a parse tree produced by CypherParser#noneFunction.

  }, {
    key: "exitNoneFunction",
    value: function exitNoneFunction(ctx) {} // Enter a parse tree produced by CypherParser#noneFunctionName.

  }, {
    key: "enterNoneFunctionName",
    value: function enterNoneFunctionName(ctx) {} // Exit a parse tree produced by CypherParser#noneFunctionName.

  }, {
    key: "exitNoneFunctionName",
    value: function exitNoneFunctionName(ctx) {} // Enter a parse tree produced by CypherParser#singleFunction.

  }, {
    key: "enterSingleFunction",
    value: function enterSingleFunction(ctx) {} // Exit a parse tree produced by CypherParser#singleFunction.

  }, {
    key: "exitSingleFunction",
    value: function exitSingleFunction(ctx) {} // Enter a parse tree produced by CypherParser#singleFunctionName.

  }, {
    key: "enterSingleFunctionName",
    value: function enterSingleFunctionName(ctx) {} // Exit a parse tree produced by CypherParser#singleFunctionName.

  }, {
    key: "exitSingleFunctionName",
    value: function exitSingleFunctionName(ctx) {} // Enter a parse tree produced by CypherParser#extractFunction.

  }, {
    key: "enterExtractFunction",
    value: function enterExtractFunction(ctx) {} // Exit a parse tree produced by CypherParser#extractFunction.

  }, {
    key: "exitExtractFunction",
    value: function exitExtractFunction(ctx) {} // Enter a parse tree produced by CypherParser#extractFunctionName.

  }, {
    key: "enterExtractFunctionName",
    value: function enterExtractFunctionName(ctx) {} // Exit a parse tree produced by CypherParser#extractFunctionName.

  }, {
    key: "exitExtractFunctionName",
    value: function exitExtractFunctionName(ctx) {} // Enter a parse tree produced by CypherParser#reduceFunction.

  }, {
    key: "enterReduceFunction",
    value: function enterReduceFunction(ctx) {} // Exit a parse tree produced by CypherParser#reduceFunction.

  }, {
    key: "exitReduceFunction",
    value: function exitReduceFunction(ctx) {} // Enter a parse tree produced by CypherParser#reduceFunctionName.

  }, {
    key: "enterReduceFunctionName",
    value: function enterReduceFunctionName(ctx) {} // Exit a parse tree produced by CypherParser#reduceFunctionName.

  }, {
    key: "exitReduceFunctionName",
    value: function exitReduceFunctionName(ctx) {} // Enter a parse tree produced by CypherParser#shortestPathPatternFunction.

  }, {
    key: "enterShortestPathPatternFunction",
    value: function enterShortestPathPatternFunction(ctx) {} // Exit a parse tree produced by CypherParser#shortestPathPatternFunction.

  }, {
    key: "exitShortestPathPatternFunction",
    value: function exitShortestPathPatternFunction(ctx) {} // Enter a parse tree produced by CypherParser#shortestPathFunctionName.

  }, {
    key: "enterShortestPathFunctionName",
    value: function enterShortestPathFunctionName(ctx) {} // Exit a parse tree produced by CypherParser#shortestPathFunctionName.

  }, {
    key: "exitShortestPathFunctionName",
    value: function exitShortestPathFunctionName(ctx) {} // Enter a parse tree produced by CypherParser#allShortestPathFunctionName.

  }, {
    key: "enterAllShortestPathFunctionName",
    value: function enterAllShortestPathFunctionName(ctx) {} // Exit a parse tree produced by CypherParser#allShortestPathFunctionName.

  }, {
    key: "exitAllShortestPathFunctionName",
    value: function exitAllShortestPathFunctionName(ctx) {} // Enter a parse tree produced by CypherParser#atom.

  }, {
    key: "enterAtom",
    value: function enterAtom(ctx) {} // Exit a parse tree produced by CypherParser#atom.

  }, {
    key: "exitAtom",
    value: function exitAtom(ctx) {} // Enter a parse tree produced by CypherParser#literal.

  }, {
    key: "enterLiteral",
    value: function enterLiteral(ctx) {} // Exit a parse tree produced by CypherParser#literal.

  }, {
    key: "exitLiteral",
    value: function exitLiteral(ctx) {} // Enter a parse tree produced by CypherParser#stringLiteral.

  }, {
    key: "enterStringLiteral",
    value: function enterStringLiteral(ctx) {} // Exit a parse tree produced by CypherParser#stringLiteral.

  }, {
    key: "exitStringLiteral",
    value: function exitStringLiteral(ctx) {} // Enter a parse tree produced by CypherParser#booleanLiteral.

  }, {
    key: "enterBooleanLiteral",
    value: function enterBooleanLiteral(ctx) {} // Exit a parse tree produced by CypherParser#booleanLiteral.

  }, {
    key: "exitBooleanLiteral",
    value: function exitBooleanLiteral(ctx) {} // Enter a parse tree produced by CypherParser#listLiteral.

  }, {
    key: "enterListLiteral",
    value: function enterListLiteral(ctx) {} // Exit a parse tree produced by CypherParser#listLiteral.

  }, {
    key: "exitListLiteral",
    value: function exitListLiteral(ctx) {} // Enter a parse tree produced by CypherParser#partialComparisonExpression.

  }, {
    key: "enterPartialComparisonExpression",
    value: function enterPartialComparisonExpression(ctx) {} // Exit a parse tree produced by CypherParser#partialComparisonExpression.

  }, {
    key: "exitPartialComparisonExpression",
    value: function exitPartialComparisonExpression(ctx) {} // Enter a parse tree produced by CypherParser#parenthesizedExpression.

  }, {
    key: "enterParenthesizedExpression",
    value: function enterParenthesizedExpression(ctx) {} // Exit a parse tree produced by CypherParser#parenthesizedExpression.

  }, {
    key: "exitParenthesizedExpression",
    value: function exitParenthesizedExpression(ctx) {} // Enter a parse tree produced by CypherParser#relationshipsPattern.

  }, {
    key: "enterRelationshipsPattern",
    value: function enterRelationshipsPattern(ctx) {} // Exit a parse tree produced by CypherParser#relationshipsPattern.

  }, {
    key: "exitRelationshipsPattern",
    value: function exitRelationshipsPattern(ctx) {} // Enter a parse tree produced by CypherParser#filterExpression.

  }, {
    key: "enterFilterExpression",
    value: function enterFilterExpression(ctx) {} // Exit a parse tree produced by CypherParser#filterExpression.

  }, {
    key: "exitFilterExpression",
    value: function exitFilterExpression(ctx) {} // Enter a parse tree produced by CypherParser#idInColl.

  }, {
    key: "enterIdInColl",
    value: function enterIdInColl(ctx) {} // Exit a parse tree produced by CypherParser#idInColl.

  }, {
    key: "exitIdInColl",
    value: function exitIdInColl(ctx) {} // Enter a parse tree produced by CypherParser#functionInvocation.

  }, {
    key: "enterFunctionInvocation",
    value: function enterFunctionInvocation(ctx) {} // Exit a parse tree produced by CypherParser#functionInvocation.

  }, {
    key: "exitFunctionInvocation",
    value: function exitFunctionInvocation(ctx) {} // Enter a parse tree produced by CypherParser#functionInvocationBody.

  }, {
    key: "enterFunctionInvocationBody",
    value: function enterFunctionInvocationBody(ctx) {} // Exit a parse tree produced by CypherParser#functionInvocationBody.

  }, {
    key: "exitFunctionInvocationBody",
    value: function exitFunctionInvocationBody(ctx) {} // Enter a parse tree produced by CypherParser#functionName.

  }, {
    key: "enterFunctionName",
    value: function enterFunctionName(ctx) {} // Exit a parse tree produced by CypherParser#functionName.

  }, {
    key: "exitFunctionName",
    value: function exitFunctionName(ctx) {} // Enter a parse tree produced by CypherParser#procedureName.

  }, {
    key: "enterProcedureName",
    value: function enterProcedureName(ctx) {} // Exit a parse tree produced by CypherParser#procedureName.

  }, {
    key: "exitProcedureName",
    value: function exitProcedureName(ctx) {} // Enter a parse tree produced by CypherParser#listComprehension.

  }, {
    key: "enterListComprehension",
    value: function enterListComprehension(ctx) {} // Exit a parse tree produced by CypherParser#listComprehension.

  }, {
    key: "exitListComprehension",
    value: function exitListComprehension(ctx) {} // Enter a parse tree produced by CypherParser#patternComprehension.

  }, {
    key: "enterPatternComprehension",
    value: function enterPatternComprehension(ctx) {} // Exit a parse tree produced by CypherParser#patternComprehension.

  }, {
    key: "exitPatternComprehension",
    value: function exitPatternComprehension(ctx) {} // Enter a parse tree produced by CypherParser#propertyLookup.

  }, {
    key: "enterPropertyLookup",
    value: function enterPropertyLookup(ctx) {} // Exit a parse tree produced by CypherParser#propertyLookup.

  }, {
    key: "exitPropertyLookup",
    value: function exitPropertyLookup(ctx) {} // Enter a parse tree produced by CypherParser#caseExpression.

  }, {
    key: "enterCaseExpression",
    value: function enterCaseExpression(ctx) {} // Exit a parse tree produced by CypherParser#caseExpression.

  }, {
    key: "exitCaseExpression",
    value: function exitCaseExpression(ctx) {} // Enter a parse tree produced by CypherParser#caseAlternatives.

  }, {
    key: "enterCaseAlternatives",
    value: function enterCaseAlternatives(ctx) {} // Exit a parse tree produced by CypherParser#caseAlternatives.

  }, {
    key: "exitCaseAlternatives",
    value: function exitCaseAlternatives(ctx) {} // Enter a parse tree produced by CypherParser#variable.

  }, {
    key: "enterVariable",
    value: function enterVariable(ctx) {} // Exit a parse tree produced by CypherParser#variable.

  }, {
    key: "exitVariable",
    value: function exitVariable(ctx) {} // Enter a parse tree produced by CypherParser#numberLiteral.

  }, {
    key: "enterNumberLiteral",
    value: function enterNumberLiteral(ctx) {} // Exit a parse tree produced by CypherParser#numberLiteral.

  }, {
    key: "exitNumberLiteral",
    value: function exitNumberLiteral(ctx) {} // Enter a parse tree produced by CypherParser#mapLiteral.

  }, {
    key: "enterMapLiteral",
    value: function enterMapLiteral(ctx) {} // Exit a parse tree produced by CypherParser#mapLiteral.

  }, {
    key: "exitMapLiteral",
    value: function exitMapLiteral(ctx) {} // Enter a parse tree produced by CypherParser#mapProjection.

  }, {
    key: "enterMapProjection",
    value: function enterMapProjection(ctx) {} // Exit a parse tree produced by CypherParser#mapProjection.

  }, {
    key: "exitMapProjection",
    value: function exitMapProjection(ctx) {} // Enter a parse tree produced by CypherParser#mapProjectionVariants.

  }, {
    key: "enterMapProjectionVariants",
    value: function enterMapProjectionVariants(ctx) {} // Exit a parse tree produced by CypherParser#mapProjectionVariants.

  }, {
    key: "exitMapProjectionVariants",
    value: function exitMapProjectionVariants(ctx) {} // Enter a parse tree produced by CypherParser#literalEntry.

  }, {
    key: "enterLiteralEntry",
    value: function enterLiteralEntry(ctx) {} // Exit a parse tree produced by CypherParser#literalEntry.

  }, {
    key: "exitLiteralEntry",
    value: function exitLiteralEntry(ctx) {} // Enter a parse tree produced by CypherParser#propertySelector.

  }, {
    key: "enterPropertySelector",
    value: function enterPropertySelector(ctx) {} // Exit a parse tree produced by CypherParser#propertySelector.

  }, {
    key: "exitPropertySelector",
    value: function exitPropertySelector(ctx) {} // Enter a parse tree produced by CypherParser#variableSelector.

  }, {
    key: "enterVariableSelector",
    value: function enterVariableSelector(ctx) {} // Exit a parse tree produced by CypherParser#variableSelector.

  }, {
    key: "exitVariableSelector",
    value: function exitVariableSelector(ctx) {} // Enter a parse tree produced by CypherParser#allPropertiesSelector.

  }, {
    key: "enterAllPropertiesSelector",
    value: function enterAllPropertiesSelector(ctx) {} // Exit a parse tree produced by CypherParser#allPropertiesSelector.

  }, {
    key: "exitAllPropertiesSelector",
    value: function exitAllPropertiesSelector(ctx) {} // Enter a parse tree produced by CypherParser#parameter.

  }, {
    key: "enterParameter",
    value: function enterParameter(ctx) {} // Exit a parse tree produced by CypherParser#parameter.

  }, {
    key: "exitParameter",
    value: function exitParameter(ctx) {} // Enter a parse tree produced by CypherParser#legacyParameter.

  }, {
    key: "enterLegacyParameter",
    value: function enterLegacyParameter(ctx) {} // Exit a parse tree produced by CypherParser#legacyParameter.

  }, {
    key: "exitLegacyParameter",
    value: function exitLegacyParameter(ctx) {} // Enter a parse tree produced by CypherParser#newParameter.

  }, {
    key: "enterNewParameter",
    value: function enterNewParameter(ctx) {} // Exit a parse tree produced by CypherParser#newParameter.

  }, {
    key: "exitNewParameter",
    value: function exitNewParameter(ctx) {} // Enter a parse tree produced by CypherParser#parameterName.

  }, {
    key: "enterParameterName",
    value: function enterParameterName(ctx) {} // Exit a parse tree produced by CypherParser#parameterName.

  }, {
    key: "exitParameterName",
    value: function exitParameterName(ctx) {} // Enter a parse tree produced by CypherParser#propertyExpressions.

  }, {
    key: "enterPropertyExpressions",
    value: function enterPropertyExpressions(ctx) {} // Exit a parse tree produced by CypherParser#propertyExpressions.

  }, {
    key: "exitPropertyExpressions",
    value: function exitPropertyExpressions(ctx) {} // Enter a parse tree produced by CypherParser#propertyExpression.

  }, {
    key: "enterPropertyExpression",
    value: function enterPropertyExpression(ctx) {} // Exit a parse tree produced by CypherParser#propertyExpression.

  }, {
    key: "exitPropertyExpression",
    value: function exitPropertyExpression(ctx) {} // Enter a parse tree produced by CypherParser#propertyKeys.

  }, {
    key: "enterPropertyKeys",
    value: function enterPropertyKeys(ctx) {} // Exit a parse tree produced by CypherParser#propertyKeys.

  }, {
    key: "exitPropertyKeys",
    value: function exitPropertyKeys(ctx) {} // Enter a parse tree produced by CypherParser#propertyKeyName.

  }, {
    key: "enterPropertyKeyName",
    value: function enterPropertyKeyName(ctx) {} // Exit a parse tree produced by CypherParser#propertyKeyName.

  }, {
    key: "exitPropertyKeyName",
    value: function exitPropertyKeyName(ctx) {} // Enter a parse tree produced by CypherParser#integerLiteral.

  }, {
    key: "enterIntegerLiteral",
    value: function enterIntegerLiteral(ctx) {} // Exit a parse tree produced by CypherParser#integerLiteral.

  }, {
    key: "exitIntegerLiteral",
    value: function exitIntegerLiteral(ctx) {} // Enter a parse tree produced by CypherParser#doubleLiteral.

  }, {
    key: "enterDoubleLiteral",
    value: function enterDoubleLiteral(ctx) {} // Exit a parse tree produced by CypherParser#doubleLiteral.

  }, {
    key: "exitDoubleLiteral",
    value: function exitDoubleLiteral(ctx) {} // Enter a parse tree produced by CypherParser#namespace.

  }, {
    key: "enterNamespace",
    value: function enterNamespace(ctx) {} // Exit a parse tree produced by CypherParser#namespace.

  }, {
    key: "exitNamespace",
    value: function exitNamespace(ctx) {} // Enter a parse tree produced by CypherParser#leftArrowHead.

  }, {
    key: "enterLeftArrowHead",
    value: function enterLeftArrowHead(ctx) {} // Exit a parse tree produced by CypherParser#leftArrowHead.

  }, {
    key: "exitLeftArrowHead",
    value: function exitLeftArrowHead(ctx) {} // Enter a parse tree produced by CypherParser#rightArrowHead.

  }, {
    key: "enterRightArrowHead",
    value: function enterRightArrowHead(ctx) {} // Exit a parse tree produced by CypherParser#rightArrowHead.

  }, {
    key: "exitRightArrowHead",
    value: function exitRightArrowHead(ctx) {} // Enter a parse tree produced by CypherParser#dash.

  }, {
    key: "enterDash",
    value: function enterDash(ctx) {} // Exit a parse tree produced by CypherParser#dash.

  }, {
    key: "exitDash",
    value: function exitDash(ctx) {} // Enter a parse tree produced by CypherParser#symbolicName.

  }, {
    key: "enterSymbolicName",
    value: function enterSymbolicName(ctx) {} // Exit a parse tree produced by CypherParser#symbolicName.

  }, {
    key: "exitSymbolicName",
    value: function exitSymbolicName(ctx) {} // Enter a parse tree produced by CypherParser#keyword.

  }, {
    key: "enterKeyword",
    value: function enterKeyword(ctx) {} // Exit a parse tree produced by CypherParser#keyword.

  }, {
    key: "exitKeyword",
    value: function exitKeyword(ctx) {}
  }]);

  return CypherListener;
}(_antlr.default.tree.ParseTreeListener);

exports.default = CypherListener;
//# sourceMappingURL=CypherListener.js.map