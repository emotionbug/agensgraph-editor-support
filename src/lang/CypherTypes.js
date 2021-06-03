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
import AgensGraphParser from '../_generated/AgensGraphParser';

export const VARIABLE_CONTEXT = AgensGraphParser.VariableContext.prototype.constructor.name;
export const LABEL_NAME_CONTEXT = AgensGraphParser.LabelNameContext.prototype.constructor.name;
export const RELATIONSHIP_TYPE_NAME_CONTEXT = AgensGraphParser.RelTypeNameContext.prototype.constructor.name;
export const PROPERTY_KEY_NAME_CONTEXT = AgensGraphParser.PropertyKeyNameContext.prototype.constructor.name;
export const PARAMETER_NAME_CONTEXT = AgensGraphParser.ParameterNameContext.prototype.constructor.name;
export const PARAMETER_CONTEXT = AgensGraphParser.ParameterContext.prototype.constructor.name;
export const FUNCTION_NAME_CONTEXT = AgensGraphParser.FunctionInvocationBodyContext.prototype.constructor.name;
export const PROCEDURE_NAME_CONTEXT = AgensGraphParser.ProcedureInvocationBodyContext.prototype.constructor.name;
export const PROCEDURE_OUTPUT_CONTEXT = AgensGraphParser.ProcedureOutputContext.prototype.constructor.name;
export const PROCEDURE_RESULTS_CONTEXT = AgensGraphParser.ProcedureResultsContext.prototype.constructor.name;

export const ALL_FUNCTION_NAME_CONTEXT = AgensGraphParser.AllFunctionNameContext.prototype.constructor.name;
export const ANY_FUNCTION_NAME_CONTEXT = AgensGraphParser.AnyFunctionNameContext.prototype.constructor.name;
export const SINGLE_FUNCTION_NAME_CONTEXT = AgensGraphParser.SingleFunctionNameContext.prototype.constructor.name;
export const NONE_FUNCTION_NAME_CONTEXT = AgensGraphParser.NoneFunctionNameContext.prototype.constructor.name;
export const EXTRACT_FUNCTION_NAME_CONTEXT = AgensGraphParser.ExtractFunctionNameContext.prototype.constructor.name;
export const REDUCE_FUNCTION_NAME_CONTEXT = AgensGraphParser.ReduceFunctionNameContext.prototype.constructor.name;
export const SHORTEST_PATH_FUNCTION_NAME_CONTEXT = AgensGraphParser.ShortestPathFunctionNameContext.prototype.constructor.name;
export const ALL_SHORTEST_PATH_FUNCTION_NAME_CONTEXT = AgensGraphParser.AllShortestPathFunctionNameContext.prototype.constructor.name;
export const FILTER_FUNCTION_NAME_CONTEXT = AgensGraphParser.FilterFunctionNameContext.prototype.constructor.name;
export const EXISTS_FUNCTION_NAME_CONTEXT = AgensGraphParser.ExistsFunctionNameContext.prototype.constructor.name;

export const EXPRESSION_CONTEXT = AgensGraphParser.CypherExpressionContext.prototype.constructor.name;
export const PATTERN_ELEMENT_CONTEXT = AgensGraphParser.PatternElementContext.prototype.constructor.name;
export const NODE_PATTERN_CONTEXT = AgensGraphParser.NodePatternContext.prototype.constructor.name;
export const NODE_LABEL_CONTEXT = AgensGraphParser.NodeLabelContext.prototype.constructor.name;
export const NODE_LABELS_CONTEXT = AgensGraphParser.NodeLabelsContext.prototype.constructor.name;
export const RELATIONSHIP_TYPE_CONTEXT = AgensGraphParser.RelationshipTypeContext.prototype.constructor.name;
export const RELATIONSHIP_TYPE_OPTIONAL_COLON_CONTEXT = AgensGraphParser.RelationshipTypeOptionalColonContext.prototype.constructor.name;
export const RELATIONSHIP_TYPES_CONTEXT = AgensGraphParser.RelationshipTypesContext.prototype.constructor.name;
export const RELATIONSHIP_PATTERN_CONTEXT = AgensGraphParser.RelationshipPatternContext.prototype.constructor.name;
export const PROPERTY_LOOKUP_CONTEXT = AgensGraphParser.PropertyLookupContext.prototype.constructor.name;
export const MAP_LITERAL_CONTEXT = AgensGraphParser.MapLiteralContext.prototype.constructor.name;
export const PROPERTIES_CONTEXT = AgensGraphParser.PropertiesContext.prototype.constructor.name;
export const MAP_LITERAL_ENTRY = AgensGraphParser.LiteralEntryContext.prototype.constructor.name;
export const STRING_LITERAL_CONTEXT = AgensGraphParser.StringLiteralContext.prototype.constructor.name;
export const ATOM_CONTEXT = AgensGraphParser.AtomContext.prototype.constructor.name;

export const QUERY_CONTEXT = AgensGraphParser.CypherQueryContext.prototype.constructor.name;

export const COMPLETION_CANDIDATES = [
  STRING_LITERAL_CONTEXT,
  VARIABLE_CONTEXT,
  PROCEDURE_NAME_CONTEXT,
  FUNCTION_NAME_CONTEXT,
  NODE_LABEL_CONTEXT,
  RELATIONSHIP_TYPE_CONTEXT,
  RELATIONSHIP_TYPE_OPTIONAL_COLON_CONTEXT,
];

export const SYMBOLIC_CONTEXTS = [
  VARIABLE_CONTEXT,
  LABEL_NAME_CONTEXT,
  RELATIONSHIP_TYPE_NAME_CONTEXT,
  PROPERTY_KEY_NAME_CONTEXT,
  PARAMETER_NAME_CONTEXT,
];
