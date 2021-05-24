"use strict";

function _typeof(obj) { "@babel/helpers - typeof"; if (typeof Symbol === "function" && typeof Symbol.iterator === "symbol") { _typeof = function _typeof(obj) { return typeof obj; }; } else { _typeof = function _typeof(obj) { return obj && typeof Symbol === "function" && obj.constructor === Symbol && obj !== Symbol.prototype ? "symbol" : typeof obj; }; } return _typeof(obj); }

Object.defineProperty(exports, "__esModule", {
  value: true
});
exports.default = void 0;

var _TreeUtils = _interopRequireDefault(require("../util/TreeUtils"));

var CypherTypes = _interopRequireWildcard(require("../lang/CypherTypes"));

function _getRequireWildcardCache(nodeInterop) { if (typeof WeakMap !== "function") return null; var cacheBabelInterop = new WeakMap(); var cacheNodeInterop = new WeakMap(); return (_getRequireWildcardCache = function _getRequireWildcardCache(nodeInterop) { return nodeInterop ? cacheNodeInterop : cacheBabelInterop; })(nodeInterop); }

function _interopRequireWildcard(obj, nodeInterop) { if (!nodeInterop && obj && obj.__esModule) { return obj; } if (obj === null || _typeof(obj) !== "object" && typeof obj !== "function") { return { default: obj }; } var cache = _getRequireWildcardCache(nodeInterop); if (cache && cache.has(obj)) { return cache.get(obj); } var newObj = {}; var hasPropertyDescriptor = Object.defineProperty && Object.getOwnPropertyDescriptor; for (var key in obj) { if (key !== "default" && Object.prototype.hasOwnProperty.call(obj, key)) { var desc = hasPropertyDescriptor ? Object.getOwnPropertyDescriptor(obj, key) : null; if (desc && (desc.get || desc.set)) { Object.defineProperty(newObj, key, desc); } else { newObj[key] = obj[key]; } } } newObj.default = obj; if (cache) { cache.set(obj, newObj); } return newObj; }

function _interopRequireDefault(obj) { return obj && obj.__esModule ? obj : { default: obj }; }

function _classCallCheck(instance, Constructor) { if (!(instance instanceof Constructor)) { throw new TypeError("Cannot call a class as a function"); } }

function _defineProperties(target, props) { for (var i = 0; i < props.length; i++) { var descriptor = props[i]; descriptor.enumerable = descriptor.enumerable || false; descriptor.configurable = true; if ("value" in descriptor) descriptor.writable = true; Object.defineProperty(target, descriptor.key, descriptor); } }

function _createClass(Constructor, protoProps, staticProps) { if (protoProps) _defineProperties(Constructor.prototype, protoProps); if (staticProps) _defineProperties(Constructor, staticProps); return Constructor; }

function traverse(element, callback) {
  if (callback(element)) {
    // found, no need to go deeper
    return;
  }

  var c = element.getChildCount();

  if (c === 0) {
    return;
  }

  for (var i = 0; i < c; i += 1) {
    traverse(element.getChild(i), callback);
  }
}

var CypherSyntaxHighlight = /*#__PURE__*/function () {
  function CypherSyntaxHighlight() {
    _classCallCheck(this, CypherSyntaxHighlight);
  }

  _createClass(CypherSyntaxHighlight, null, [{
    key: "process",
    value: function process(parseTree, callback) {
      traverse(parseTree, function (e) {
        var _ref = _TreeUtils.default.getPosition(e) || {
          start: 0,
          stop: 0
        },
            start = _ref.start,
            stop = _ref.stop;

        if (start > stop) {
          return false;
        }

        if (e.constructor.name === CypherTypes.VARIABLE_CONTEXT) {
          callback(e, 'variable');
          return true;
        }

        if (e.constructor.name === CypherTypes.NODE_LABEL_CONTEXT) {
          callback(e, 'label');
          return true;
        }

        if (e.constructor.name === CypherTypes.RELATIONSHIP_TYPE_CONTEXT || e.constructor.name === CypherTypes.RELATIONSHIP_TYPE_OPTIONAL_COLON_CONTEXT) {
          callback(e, 'relationshipType');
          return true;
        }

        if (e.constructor.name === CypherTypes.PROPERTY_KEY_NAME_CONTEXT) {
          callback(e, 'property');
          return true;
        }

        if (e.constructor.name === CypherTypes.PROCEDURE_NAME_CONTEXT) {
          callback(e, 'procedure');
          return true;
        }

        if (e.constructor.name === CypherTypes.PROCEDURE_OUTPUT_CONTEXT) {
          callback(e, 'procedureOutput');
          return true;
        }

        if (e.constructor.name === CypherTypes.FUNCTION_NAME_CONTEXT) {
          callback(e, 'function');
          return true;
        }

        if (e.constructor.name === CypherTypes.ALL_FUNCTION_NAME_CONTEXT || e.constructor.name === CypherTypes.REDUCE_FUNCTION_NAME_CONTEXT || e.constructor.name === CypherTypes.FILTER_FUNCTION_NAME_CONTEXT || e.constructor.name === CypherTypes.NONE_FUNCTION_NAME_CONTEXT || e.constructor.name === CypherTypes.EXTRACT_FUNCTION_NAME_CONTEXT || e.constructor.name === CypherTypes.SHORTEST_PATH_FUNCTION_NAME_CONTEXT || e.constructor.name === CypherTypes.ALL_SHORTEST_PATH_FUNCTION_NAME_CONTEXT || e.constructor.name === CypherTypes.SINGLE_FUNCTION_NAME_CONTEXT || e.constructor.name === CypherTypes.EXISTS_FUNCTION_NAME_CONTEXT || e.constructor.name === CypherTypes.ANY_FUNCTION_NAME_CONTEXT) {
          callback(e, 'function');
          return true;
        }

        if (e.constructor.name === CypherTypes.PARAMETER_CONTEXT) {
          callback(e, 'parameter');
          return true;
        }

        if (e.constructor.name === CypherTypes.CONSOLE_COMMAND_NAME_CONTEXT) {
          callback(e, 'consoleCommand');
          return true;
        }

        if (e.constructor.name === CypherTypes.CONSOLE_COMMAND_SUBCOMMAND_CONTEXT || e.constructor.name === CypherTypes.CONSOLE_COMMAND_PATH_CONTEXT) {
          callback(e, 'property');
          return true;
        }

        return false;
      });
    }
  }]);

  return CypherSyntaxHighlight;
}();

exports.default = CypherSyntaxHighlight;
//# sourceMappingURL=CypherSyntaxHighlight.js.map