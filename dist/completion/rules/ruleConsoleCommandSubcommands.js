"use strict";

function _typeof(obj) { "@babel/helpers - typeof"; if (typeof Symbol === "function" && typeof Symbol.iterator === "symbol") { _typeof = function _typeof(obj) { return typeof obj; }; } else { _typeof = function _typeof(obj) { return obj && typeof Symbol === "function" && obj.constructor === Symbol && obj !== Symbol.prototype ? "symbol" : typeof obj; }; } return _typeof(obj); }

Object.defineProperty(exports, "__esModule", {
  value: true
});
exports.default = void 0;

var CypherTypes = _interopRequireWildcard(require("../../lang/CypherTypes"));

var CompletionTypes = _interopRequireWildcard(require("../CompletionTypes"));

var _TreeUtils = _interopRequireDefault(require("../../util/TreeUtils"));

function _interopRequireDefault(obj) { return obj && obj.__esModule ? obj : { default: obj }; }

function _getRequireWildcardCache(nodeInterop) { if (typeof WeakMap !== "function") return null; var cacheBabelInterop = new WeakMap(); var cacheNodeInterop = new WeakMap(); return (_getRequireWildcardCache = function _getRequireWildcardCache(nodeInterop) { return nodeInterop ? cacheNodeInterop : cacheBabelInterop; })(nodeInterop); }

function _interopRequireWildcard(obj, nodeInterop) { if (!nodeInterop && obj && obj.__esModule) { return obj; } if (obj === null || _typeof(obj) !== "object" && typeof obj !== "function") { return { default: obj }; } var cache = _getRequireWildcardCache(nodeInterop); if (cache && cache.has(obj)) { return cache.get(obj); } var newObj = {}; var hasPropertyDescriptor = Object.defineProperty && Object.getOwnPropertyDescriptor; for (var key in obj) { if (key !== "default" && Object.prototype.hasOwnProperty.call(obj, key)) { var desc = hasPropertyDescriptor ? Object.getOwnPropertyDescriptor(obj, key) : null; if (desc && (desc.get || desc.set)) { Object.defineProperty(newObj, key, desc); } else { newObj[key] = obj[key]; } } } newObj.default = obj; if (cache) { cache.set(obj, newObj); } return newObj; }

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
// If we are in console command, and not in console command name, return path
var _default = function _default(element) {
  var consoleCommand = _TreeUtils.default.findParent(element.parentCtx, CypherTypes.CONSOLE_COMMAND_CONTEXT);

  var isAtTheEndOfConsoleCommand = false;

  if (!consoleCommand) {
    // We are not in console command. But maybe we are on a space at the end of console command?
    // If first child of parent contains console command
    // and second child is our current element
    // then we are at the space at the end of console command
    var parent = element.parentCtx;

    var child1 = _TreeUtils.default.findChild(parent.children[0], CypherTypes.CONSOLE_COMMAND_CONTEXT);

    var child2 = parent.children[1];

    if (child1 && child2 && child2 === element) {
      consoleCommand = child1;
      isAtTheEndOfConsoleCommand = true;
    } else {
      return [];
    }
  } // Find current parameter or space


  var currentElement = _TreeUtils.default.findParent(element, CypherTypes.CONSOLE_COMMAND_PARAMETER_CONTEXT) || element;
  var path = [];
  var currentElementInParameter = false; // Iterate over parameters, and stop when we found current one.

  for (var i = 0; i < consoleCommand.children.length; i += 1) {
    var child = consoleCommand.children[i];

    if (child.constructor.name === CypherTypes.CONSOLE_COMMAND_NAME_CONTEXT) {
      path.push(child.getText());
    }

    if (child.constructor.name === CypherTypes.CONSOLE_COMMAND_PARAMETERS_CONTEXT) {
      for (var j = 0; j < child.children.length; j += 1) {
        var parameterChild = child.children[j];

        if (parameterChild.constructor.name === CypherTypes.CONSOLE_COMMAND_PARAMETER_CONTEXT) {
          path.push(parameterChild.getText());
          currentElementInParameter = true;
        } else {
          currentElementInParameter = false;
        }

        if (parameterChild === currentElement) {
          break;
        }
      }
    }
  } // If we are at the end of console command, nothing to filter.


  var filterLastElement;

  if (isAtTheEndOfConsoleCommand) {
    filterLastElement = false;
  } else {
    // If we are in parameter, filter, otherwise not
    filterLastElement = currentElementInParameter;
  }

  return [{
    type: CompletionTypes.CONSOLE_COMMAND_SUBCOMMAND,
    path: path,
    filterLastElement: filterLastElement
  }];
};

exports.default = _default;
//# sourceMappingURL=ruleConsoleCommandSubcommands.js.map