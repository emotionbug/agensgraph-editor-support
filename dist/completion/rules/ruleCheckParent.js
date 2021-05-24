"use strict";

function _typeof(obj) { "@babel/helpers - typeof"; if (typeof Symbol === "function" && typeof Symbol.iterator === "symbol") { _typeof = function _typeof(obj) { return typeof obj; }; } else { _typeof = function _typeof(obj) { return obj && typeof Symbol === "function" && obj.constructor === Symbol && obj !== Symbol.prototype ? "symbol" : typeof obj; }; } return _typeof(obj); }

Object.defineProperty(exports, "__esModule", {
  value: true
});
exports.default = void 0;

var CypherTypes = _interopRequireWildcard(require("../../lang/CypherTypes"));

var CompletionTypes = _interopRequireWildcard(require("../CompletionTypes"));

var _TreeUtils = _interopRequireDefault(require("../../util/TreeUtils"));

var _childToParentTypeMap;

function _interopRequireDefault(obj) { return obj && obj.__esModule ? obj : { default: obj }; }

function _getRequireWildcardCache(nodeInterop) { if (typeof WeakMap !== "function") return null; var cacheBabelInterop = new WeakMap(); var cacheNodeInterop = new WeakMap(); return (_getRequireWildcardCache = function _getRequireWildcardCache(nodeInterop) { return nodeInterop ? cacheNodeInterop : cacheBabelInterop; })(nodeInterop); }

function _interopRequireWildcard(obj, nodeInterop) { if (!nodeInterop && obj && obj.__esModule) { return obj; } if (obj === null || _typeof(obj) !== "object" && typeof obj !== "function") { return { default: obj }; } var cache = _getRequireWildcardCache(nodeInterop); if (cache && cache.has(obj)) { return cache.get(obj); } var newObj = {}; var hasPropertyDescriptor = Object.defineProperty && Object.getOwnPropertyDescriptor; for (var key in obj) { if (key !== "default" && Object.prototype.hasOwnProperty.call(obj, key)) { var desc = hasPropertyDescriptor ? Object.getOwnPropertyDescriptor(obj, key) : null; if (desc && (desc.get || desc.set)) { Object.defineProperty(newObj, key, desc); } else { newObj[key] = obj[key]; } } } newObj.default = obj; if (cache) { cache.set(obj, newObj); } return newObj; }

function _defineProperty(obj, key, value) { if (key in obj) { Object.defineProperty(obj, key, { value: value, enumerable: true, configurable: true, writable: true }); } else { obj[key] = value; } return obj; }

var childToParentTypeMapping = (_childToParentTypeMap = {}, _defineProperty(_childToParentTypeMap, CypherTypes.VARIABLE_CONTEXT, [{
  type: CompletionTypes.VARIABLE
}]), _defineProperty(_childToParentTypeMap, CypherTypes.PARAMETER_NAME_CONTEXT, [{
  type: CompletionTypes.PARAMETER
}]), _defineProperty(_childToParentTypeMap, CypherTypes.PROPERTY_KEY_NAME_CONTEXT, [{
  type: CompletionTypes.PROPERTY_KEY
}]), _defineProperty(_childToParentTypeMap, CypherTypes.FUNCTION_NAME_CONTEXT, [{
  type: CompletionTypes.FUNCTION_NAME
}]), _defineProperty(_childToParentTypeMap, CypherTypes.PROCEDURE_NAME_CONTEXT, [{
  type: CompletionTypes.PROCEDURE_NAME
}]), _defineProperty(_childToParentTypeMap, CypherTypes.NODE_LABEL_CONTEXT, [{
  type: CompletionTypes.LABEL
}]), _defineProperty(_childToParentTypeMap, CypherTypes.RELATIONSHIP_TYPE_CONTEXT, [{
  type: CompletionTypes.RELATIONSHIP_TYPE
}]), _defineProperty(_childToParentTypeMap, CypherTypes.RELATIONSHIP_TYPE_OPTIONAL_COLON_CONTEXT, [{
  type: CompletionTypes.RELATIONSHIP_TYPE
}]), _defineProperty(_childToParentTypeMap, CypherTypes.CONSOLE_COMMAND_NAME_CONTEXT, [{
  type: CompletionTypes.CONSOLE_COMMAND_NAME
}]), _defineProperty(_childToParentTypeMap, CypherTypes.NODE_LABELS_CONTEXT, [{
  type: CompletionTypes.LABEL
}]), _defineProperty(_childToParentTypeMap, CypherTypes.RELATIONSHIP_TYPES_CONTEXT, [{
  type: CompletionTypes.RELATIONSHIP_TYPE
}]), _childToParentTypeMap); // Check that element is inside specific parent context

var _default = function _default(element) {
  var parent = _TreeUtils.default.findAnyParent(element, Object.keys(childToParentTypeMapping));

  return parent != null ? childToParentTypeMapping[parent.constructor.name] : [];
};

exports.default = _default;
//# sourceMappingURL=ruleCheckParent.js.map