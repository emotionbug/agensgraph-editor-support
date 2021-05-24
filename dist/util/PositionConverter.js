"use strict";

Object.defineProperty(exports, "__esModule", {
  value: true
});
exports.default = void 0;

function _classCallCheck(instance, Constructor) { if (!(instance instanceof Constructor)) { throw new TypeError("Cannot call a class as a function"); } }

function _defineProperties(target, props) { for (var i = 0; i < props.length; i++) { var descriptor = props[i]; descriptor.enumerable = descriptor.enumerable || false; descriptor.configurable = true; if ("value" in descriptor) descriptor.writable = true; Object.defineProperty(target, descriptor.key, descriptor); } }

function _createClass(Constructor, protoProps, staticProps) { if (protoProps) _defineProperties(Constructor.prototype, protoProps); if (staticProps) _defineProperties(Constructor, staticProps); return Constructor; }

function _defineProperty(obj, key, value) { if (key in obj) { Object.defineProperty(obj, key, { value: value, enumerable: true, configurable: true, writable: true }); } else { obj[key] = value; } return obj; }

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
var PositionConverter = /*#__PURE__*/function () {
  function PositionConverter(input) {
    _classCallCheck(this, PositionConverter);

    _defineProperty(this, "newLines", []);

    for (var i = 0; i < input.length; i += 1) {
      if (input[i] === '\n') {
        this.newLines.push(i);
      }
    }
  }

  _createClass(PositionConverter, [{
    key: "toAbsolute",
    value: function toAbsolute(line, column) {
      return (this.newLines[line - 2] || -1) + column + 1;
    }
  }, {
    key: "toRelative",
    value: function toRelative(abs) {
      for (var i = this.newLines.length - 1; i >= 0; i -= 1) {
        var column = abs - this.newLines[i];

        if (column >= 1) {
          return {
            line: i + 2,
            column: column - 1
          };
        }
      }

      return {
        line: 1,
        column: abs
      };
    }
  }]);

  return PositionConverter;
}();

exports.default = PositionConverter;
//# sourceMappingURL=PositionConverter.js.map