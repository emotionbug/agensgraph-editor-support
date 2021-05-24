"use strict";

function _typeof(obj) { "@babel/helpers - typeof"; if (typeof Symbol === "function" && typeof Symbol.iterator === "symbol") { _typeof = function _typeof(obj) { return typeof obj; }; } else { _typeof = function _typeof(obj) { return obj && typeof Symbol === "function" && obj.constructor === Symbol && obj !== Symbol.prototype ? "symbol" : typeof obj; }; } return _typeof(obj); }

Object.defineProperty(exports, "__esModule", {
  value: true
});
exports.default = void 0;

var CompletionTypes = _interopRequireWildcard(require("./CompletionTypes"));

var rules = _interopRequireWildcard(require("./rules"));

function _getRequireWildcardCache(nodeInterop) { if (typeof WeakMap !== "function") return null; var cacheBabelInterop = new WeakMap(); var cacheNodeInterop = new WeakMap(); return (_getRequireWildcardCache = function _getRequireWildcardCache(nodeInterop) { return nodeInterop ? cacheNodeInterop : cacheBabelInterop; })(nodeInterop); }

function _interopRequireWildcard(obj, nodeInterop) { if (!nodeInterop && obj && obj.__esModule) { return obj; } if (obj === null || _typeof(obj) !== "object" && typeof obj !== "function") { return { default: obj }; } var cache = _getRequireWildcardCache(nodeInterop); if (cache && cache.has(obj)) { return cache.get(obj); } var newObj = {}; var hasPropertyDescriptor = Object.defineProperty && Object.getOwnPropertyDescriptor; for (var key in obj) { if (key !== "default" && Object.prototype.hasOwnProperty.call(obj, key)) { var desc = hasPropertyDescriptor ? Object.getOwnPropertyDescriptor(obj, key) : null; if (desc && (desc.get || desc.set)) { Object.defineProperty(newObj, key, desc); } else { newObj[key] = obj[key]; } } } newObj.default = obj; if (cache) { cache.set(obj, newObj); } return newObj; }

function _classCallCheck(instance, Constructor) { if (!(instance instanceof Constructor)) { throw new TypeError("Cannot call a class as a function"); } }

function _defineProperties(target, props) { for (var i = 0; i < props.length; i++) { var descriptor = props[i]; descriptor.enumerable = descriptor.enumerable || false; descriptor.configurable = true; if ("value" in descriptor) descriptor.writable = true; Object.defineProperty(target, descriptor.key, descriptor); } }

function _createClass(Constructor, protoProps, staticProps) { if (protoProps) _defineProperties(Constructor.prototype, protoProps); if (staticProps) _defineProperties(Constructor, staticProps); return Constructor; }

// Rules are sorted starting with specific ones, and finishing with more generic ones.
var orderedCompletionRules = [rules.ruleNoop, rules.ruleVariableInExpressionPossibleFunction, rules.ruleLiteralEntry, rules.rulePropInMapLiteral, rules.ruleParamStartsWithDollar, rules.ruleSpecificParent, rules.ruleNodePattern, rules.ruleRelationshipPattern, rules.ruleProcedureOutputsInCallClause, rules.ruleCallClauseBeginning, rules.ruleConsoleCommandSubcommands, rules.rulePropertyLookup, rules.rulePossibleKeyword];

function evaluateRules(element) {
  for (var i = 0; i < orderedCompletionRules.length; i += 1) {
    var rule = orderedCompletionRules[i];
    var types = rule(element);

    if (types.length > 0) {
      return types;
    }
  }

  return [];
}

var CompletionTypeResolver = /*#__PURE__*/function () {
  function CompletionTypeResolver() {
    _classCallCheck(this, CompletionTypeResolver);
  }

  _createClass(CompletionTypeResolver, null, [{
    key: "getTypes",
    value: function getTypes(element) {
      // If element is null, then no types
      if (element == null) {
        return {
          found: false,
          types: CompletionTypes.ALL
        };
      } // Retrieve types from rules


      var types = evaluateRules(element);

      if (types.length > 0) {
        return {
          found: true,
          types: types
        };
      } // If no types found, then no types


      return {
        found: false,
        types: CompletionTypes.ALL
      };
    }
  }]);

  return CompletionTypeResolver;
}();

exports.default = CompletionTypeResolver;
//# sourceMappingURL=CompletionTypeResolver.js.map