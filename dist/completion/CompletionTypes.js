"use strict";

Object.defineProperty(exports, "__esModule", {
  value: true
});
exports.ALL = exports.NOOP = exports.PROCEDURE_OUTPUT = exports.CONSOLE_COMMAND_SUBCOMMAND = exports.CONSOLE_COMMAND_NAME = exports.PROCEDURE_NAME = exports.FUNCTION_NAME = exports.RELATIONSHIP_TYPE = exports.PROPERTY_KEY = exports.PARAMETER = exports.VARIABLE = exports.LABEL = exports.KEYWORD = void 0;

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
var KEYWORD = 'keyword';
exports.KEYWORD = KEYWORD;
var LABEL = 'label';
exports.LABEL = LABEL;
var VARIABLE = 'variable';
exports.VARIABLE = VARIABLE;
var PARAMETER = 'parameter';
exports.PARAMETER = PARAMETER;
var PROPERTY_KEY = 'propertyKey';
exports.PROPERTY_KEY = PROPERTY_KEY;
var RELATIONSHIP_TYPE = 'relationshipType';
exports.RELATIONSHIP_TYPE = RELATIONSHIP_TYPE;
var FUNCTION_NAME = 'function';
exports.FUNCTION_NAME = FUNCTION_NAME;
var PROCEDURE_NAME = 'procedure';
exports.PROCEDURE_NAME = PROCEDURE_NAME;
var CONSOLE_COMMAND_NAME = 'consoleCommand';
exports.CONSOLE_COMMAND_NAME = CONSOLE_COMMAND_NAME;
var CONSOLE_COMMAND_SUBCOMMAND = 'consoleCommandSubcommand';
exports.CONSOLE_COMMAND_SUBCOMMAND = CONSOLE_COMMAND_SUBCOMMAND;
var PROCEDURE_OUTPUT = 'procedureOutput'; // Return no autocompletion

exports.PROCEDURE_OUTPUT = PROCEDURE_OUTPUT;
var NOOP = 'noop'; // Default

exports.NOOP = NOOP;
var ALL = [VARIABLE, PARAMETER, PROPERTY_KEY, FUNCTION_NAME, KEYWORD].map(function (type) {
  return {
    type: type
  };
});
exports.ALL = ALL;
//# sourceMappingURL=CompletionTypes.js.map