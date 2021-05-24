"use strict";

Object.defineProperty(exports, "__esModule", {
  value: true
});
exports.SYMBOLIC_CONTEXTS = exports.COMPLETION_CANDIDATES = exports.SYMBOLIC_NAME_CONTEXT = exports.QUERY_CONTEXT = exports.ATOM_CONTEXT = exports.STRING_LITERAL_CONTEXT = exports.MAP_LITERAL_ENTRY = exports.PROPERTIES_CONTEXT = exports.MAP_LITERAL_CONTEXT = exports.PROPERTY_LOOKUP_CONTEXT = exports.RELATIONSHIP_PATTERN_CONTEXT = exports.RELATIONSHIP_TYPES_CONTEXT = exports.RELATIONSHIP_TYPE_OPTIONAL_COLON_CONTEXT = exports.RELATIONSHIP_TYPE_CONTEXT = exports.NODE_LABELS_CONTEXT = exports.NODE_LABEL_CONTEXT = exports.NODE_PATTERN_CONTEXT = exports.PATTERN_ELEMENT_CONTEXT = exports.EXPRESSION_CONTEXT = exports.CALL_CONTEXT = exports.EXISTS_FUNCTION_NAME_CONTEXT = exports.FILTER_FUNCTION_NAME_CONTEXT = exports.ALL_SHORTEST_PATH_FUNCTION_NAME_CONTEXT = exports.SHORTEST_PATH_FUNCTION_NAME_CONTEXT = exports.REDUCE_FUNCTION_NAME_CONTEXT = exports.EXTRACT_FUNCTION_NAME_CONTEXT = exports.NONE_FUNCTION_NAME_CONTEXT = exports.SINGLE_FUNCTION_NAME_CONTEXT = exports.ANY_FUNCTION_NAME_CONTEXT = exports.ALL_FUNCTION_NAME_CONTEXT = exports.PROCEDURE_RESULTS_CONTEXT = exports.PROCEDURE_OUTPUT_CONTEXT = exports.CONSOLE_COMMAND_PATH_CONTEXT = exports.CONSOLE_COMMAND_SUBCOMMAND_CONTEXT = exports.CONSOLE_COMMAND_PARAMETER_CONTEXT = exports.CONSOLE_COMMAND_PARAMETERS_CONTEXT = exports.CONSOLE_COMMAND_CONTEXT = exports.CONSOLE_COMMAND_NAME_CONTEXT = exports.PROCEDURE_NAME_CONTEXT = exports.FUNCTION_NAME_CONTEXT = exports.PARAMETER_CONTEXT = exports.PARAMETER_NAME_CONTEXT = exports.PROPERTY_KEY_NAME_CONTEXT = exports.RELATIONSHIP_TYPE_NAME_CONTEXT = exports.LABEL_NAME_CONTEXT = exports.VARIABLE_CONTEXT = void 0;

var _CypherParser = _interopRequireDefault(require("../_generated/CypherParser"));

function _interopRequireDefault(obj) { return obj && obj.__esModule ? obj : { default: obj }; }

/*
 * Copyright (c) 2002-2017 "Neo Technology,"
 * Network Engine for Objects in Lund AB [http://neotechnology.com]
 *
 * This file is part of Neo4j.
 *
 * Neo4j is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */

/* eslint-disable max-len */
var VARIABLE_CONTEXT = _CypherParser.default.VariableContext.prototype.constructor.name;
exports.VARIABLE_CONTEXT = VARIABLE_CONTEXT;
var LABEL_NAME_CONTEXT = _CypherParser.default.LabelNameContext.prototype.constructor.name;
exports.LABEL_NAME_CONTEXT = LABEL_NAME_CONTEXT;
var RELATIONSHIP_TYPE_NAME_CONTEXT = _CypherParser.default.RelTypeNameContext.prototype.constructor.name;
exports.RELATIONSHIP_TYPE_NAME_CONTEXT = RELATIONSHIP_TYPE_NAME_CONTEXT;
var PROPERTY_KEY_NAME_CONTEXT = _CypherParser.default.PropertyKeyNameContext.prototype.constructor.name;
exports.PROPERTY_KEY_NAME_CONTEXT = PROPERTY_KEY_NAME_CONTEXT;
var PARAMETER_NAME_CONTEXT = _CypherParser.default.ParameterNameContext.prototype.constructor.name;
exports.PARAMETER_NAME_CONTEXT = PARAMETER_NAME_CONTEXT;
var PARAMETER_CONTEXT = _CypherParser.default.ParameterContext.prototype.constructor.name;
exports.PARAMETER_CONTEXT = PARAMETER_CONTEXT;
var FUNCTION_NAME_CONTEXT = _CypherParser.default.FunctionInvocationBodyContext.prototype.constructor.name;
exports.FUNCTION_NAME_CONTEXT = FUNCTION_NAME_CONTEXT;
var PROCEDURE_NAME_CONTEXT = _CypherParser.default.ProcedureInvocationBodyContext.prototype.constructor.name;
exports.PROCEDURE_NAME_CONTEXT = PROCEDURE_NAME_CONTEXT;
var CONSOLE_COMMAND_NAME_CONTEXT = _CypherParser.default.CypherConsoleCommandNameContext.prototype.constructor.name;
exports.CONSOLE_COMMAND_NAME_CONTEXT = CONSOLE_COMMAND_NAME_CONTEXT;
var CONSOLE_COMMAND_CONTEXT = _CypherParser.default.CypherConsoleCommandContext.prototype.constructor.name;
exports.CONSOLE_COMMAND_CONTEXT = CONSOLE_COMMAND_CONTEXT;
var CONSOLE_COMMAND_PARAMETERS_CONTEXT = _CypherParser.default.CypherConsoleCommandParametersContext.prototype.constructor.name;
exports.CONSOLE_COMMAND_PARAMETERS_CONTEXT = CONSOLE_COMMAND_PARAMETERS_CONTEXT;
var CONSOLE_COMMAND_PARAMETER_CONTEXT = _CypherParser.default.CypherConsoleCommandParameterContext.prototype.constructor.name;
exports.CONSOLE_COMMAND_PARAMETER_CONTEXT = CONSOLE_COMMAND_PARAMETER_CONTEXT;
var CONSOLE_COMMAND_SUBCOMMAND_CONTEXT = _CypherParser.default.SubCommandContext.prototype.constructor.name;
exports.CONSOLE_COMMAND_SUBCOMMAND_CONTEXT = CONSOLE_COMMAND_SUBCOMMAND_CONTEXT;
var CONSOLE_COMMAND_PATH_CONTEXT = _CypherParser.default.CommandPathContext.prototype.constructor.name;
exports.CONSOLE_COMMAND_PATH_CONTEXT = CONSOLE_COMMAND_PATH_CONTEXT;
var PROCEDURE_OUTPUT_CONTEXT = _CypherParser.default.ProcedureOutputContext.prototype.constructor.name;
exports.PROCEDURE_OUTPUT_CONTEXT = PROCEDURE_OUTPUT_CONTEXT;
var PROCEDURE_RESULTS_CONTEXT = _CypherParser.default.ProcedureResultsContext.prototype.constructor.name;
exports.PROCEDURE_RESULTS_CONTEXT = PROCEDURE_RESULTS_CONTEXT;
var ALL_FUNCTION_NAME_CONTEXT = _CypherParser.default.AllFunctionNameContext.prototype.constructor.name;
exports.ALL_FUNCTION_NAME_CONTEXT = ALL_FUNCTION_NAME_CONTEXT;
var ANY_FUNCTION_NAME_CONTEXT = _CypherParser.default.AnyFunctionNameContext.prototype.constructor.name;
exports.ANY_FUNCTION_NAME_CONTEXT = ANY_FUNCTION_NAME_CONTEXT;
var SINGLE_FUNCTION_NAME_CONTEXT = _CypherParser.default.SingleFunctionNameContext.prototype.constructor.name;
exports.SINGLE_FUNCTION_NAME_CONTEXT = SINGLE_FUNCTION_NAME_CONTEXT;
var NONE_FUNCTION_NAME_CONTEXT = _CypherParser.default.NoneFunctionNameContext.prototype.constructor.name;
exports.NONE_FUNCTION_NAME_CONTEXT = NONE_FUNCTION_NAME_CONTEXT;
var EXTRACT_FUNCTION_NAME_CONTEXT = _CypherParser.default.ExtractFunctionNameContext.prototype.constructor.name;
exports.EXTRACT_FUNCTION_NAME_CONTEXT = EXTRACT_FUNCTION_NAME_CONTEXT;
var REDUCE_FUNCTION_NAME_CONTEXT = _CypherParser.default.ReduceFunctionNameContext.prototype.constructor.name;
exports.REDUCE_FUNCTION_NAME_CONTEXT = REDUCE_FUNCTION_NAME_CONTEXT;
var SHORTEST_PATH_FUNCTION_NAME_CONTEXT = _CypherParser.default.ShortestPathFunctionNameContext.prototype.constructor.name;
exports.SHORTEST_PATH_FUNCTION_NAME_CONTEXT = SHORTEST_PATH_FUNCTION_NAME_CONTEXT;
var ALL_SHORTEST_PATH_FUNCTION_NAME_CONTEXT = _CypherParser.default.AllShortestPathFunctionNameContext.prototype.constructor.name;
exports.ALL_SHORTEST_PATH_FUNCTION_NAME_CONTEXT = ALL_SHORTEST_PATH_FUNCTION_NAME_CONTEXT;
var FILTER_FUNCTION_NAME_CONTEXT = _CypherParser.default.FilterFunctionNameContext.prototype.constructor.name;
exports.FILTER_FUNCTION_NAME_CONTEXT = FILTER_FUNCTION_NAME_CONTEXT;
var EXISTS_FUNCTION_NAME_CONTEXT = _CypherParser.default.ExistsFunctionNameContext.prototype.constructor.name;
exports.EXISTS_FUNCTION_NAME_CONTEXT = EXISTS_FUNCTION_NAME_CONTEXT;
var CALL_CONTEXT = _CypherParser.default.CallContext.prototype.constructor.name;
exports.CALL_CONTEXT = CALL_CONTEXT;
var EXPRESSION_CONTEXT = _CypherParser.default.ExpressionContext.prototype.constructor.name;
exports.EXPRESSION_CONTEXT = EXPRESSION_CONTEXT;
var PATTERN_ELEMENT_CONTEXT = _CypherParser.default.PatternElementContext.prototype.constructor.name;
exports.PATTERN_ELEMENT_CONTEXT = PATTERN_ELEMENT_CONTEXT;
var NODE_PATTERN_CONTEXT = _CypherParser.default.NodePatternContext.prototype.constructor.name;
exports.NODE_PATTERN_CONTEXT = NODE_PATTERN_CONTEXT;
var NODE_LABEL_CONTEXT = _CypherParser.default.NodeLabelContext.prototype.constructor.name;
exports.NODE_LABEL_CONTEXT = NODE_LABEL_CONTEXT;
var NODE_LABELS_CONTEXT = _CypherParser.default.NodeLabelsContext.prototype.constructor.name;
exports.NODE_LABELS_CONTEXT = NODE_LABELS_CONTEXT;
var RELATIONSHIP_TYPE_CONTEXT = _CypherParser.default.RelationshipTypeContext.prototype.constructor.name;
exports.RELATIONSHIP_TYPE_CONTEXT = RELATIONSHIP_TYPE_CONTEXT;
var RELATIONSHIP_TYPE_OPTIONAL_COLON_CONTEXT = _CypherParser.default.RelationshipTypeOptionalColonContext.prototype.constructor.name;
exports.RELATIONSHIP_TYPE_OPTIONAL_COLON_CONTEXT = RELATIONSHIP_TYPE_OPTIONAL_COLON_CONTEXT;
var RELATIONSHIP_TYPES_CONTEXT = _CypherParser.default.RelationshipTypesContext.prototype.constructor.name;
exports.RELATIONSHIP_TYPES_CONTEXT = RELATIONSHIP_TYPES_CONTEXT;
var RELATIONSHIP_PATTERN_CONTEXT = _CypherParser.default.RelationshipPatternContext.prototype.constructor.name;
exports.RELATIONSHIP_PATTERN_CONTEXT = RELATIONSHIP_PATTERN_CONTEXT;
var PROPERTY_LOOKUP_CONTEXT = _CypherParser.default.PropertyLookupContext.prototype.constructor.name;
exports.PROPERTY_LOOKUP_CONTEXT = PROPERTY_LOOKUP_CONTEXT;
var MAP_LITERAL_CONTEXT = _CypherParser.default.MapLiteralContext.prototype.constructor.name;
exports.MAP_LITERAL_CONTEXT = MAP_LITERAL_CONTEXT;
var PROPERTIES_CONTEXT = _CypherParser.default.PropertiesContext.prototype.constructor.name;
exports.PROPERTIES_CONTEXT = PROPERTIES_CONTEXT;
var MAP_LITERAL_ENTRY = _CypherParser.default.LiteralEntryContext.prototype.constructor.name;
exports.MAP_LITERAL_ENTRY = MAP_LITERAL_ENTRY;
var STRING_LITERAL_CONTEXT = _CypherParser.default.StringLiteralContext.prototype.constructor.name;
exports.STRING_LITERAL_CONTEXT = STRING_LITERAL_CONTEXT;
var ATOM_CONTEXT = _CypherParser.default.AtomContext.prototype.constructor.name;
exports.ATOM_CONTEXT = ATOM_CONTEXT;
var QUERY_CONTEXT = _CypherParser.default.CypherQueryContext.prototype.constructor.name;
exports.QUERY_CONTEXT = QUERY_CONTEXT;
var SYMBOLIC_NAME_CONTEXT = _CypherParser.default.SymbolicNameContext.prototype.constructor.name;
exports.SYMBOLIC_NAME_CONTEXT = SYMBOLIC_NAME_CONTEXT;
var COMPLETION_CANDIDATES = [STRING_LITERAL_CONTEXT, VARIABLE_CONTEXT, PROCEDURE_NAME_CONTEXT, FUNCTION_NAME_CONTEXT, CONSOLE_COMMAND_NAME_CONTEXT, NODE_LABEL_CONTEXT, RELATIONSHIP_TYPE_CONTEXT, RELATIONSHIP_TYPE_OPTIONAL_COLON_CONTEXT];
exports.COMPLETION_CANDIDATES = COMPLETION_CANDIDATES;
var SYMBOLIC_CONTEXTS = [VARIABLE_CONTEXT, LABEL_NAME_CONTEXT, RELATIONSHIP_TYPE_NAME_CONTEXT, PROPERTY_KEY_NAME_CONTEXT, PARAMETER_NAME_CONTEXT];
exports.SYMBOLIC_CONTEXTS = SYMBOLIC_CONTEXTS;
//# sourceMappingURL=CypherTypes.js.map