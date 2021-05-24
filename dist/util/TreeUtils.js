"use strict";

Object.defineProperty(exports, "__esModule", {
  value: true
});
exports.default = void 0;

function _classCallCheck(instance, Constructor) { if (!(instance instanceof Constructor)) { throw new TypeError("Cannot call a class as a function"); } }

function _defineProperties(target, props) { for (var i = 0; i < props.length; i++) { var descriptor = props[i]; descriptor.enumerable = descriptor.enumerable || false; descriptor.configurable = true; if ("value" in descriptor) descriptor.writable = true; Object.defineProperty(target, descriptor.key, descriptor); } }

function _createClass(Constructor, protoProps, staticProps) { if (protoProps) _defineProperties(Constructor.prototype, protoProps); if (staticProps) _defineProperties(Constructor, staticProps); return Constructor; }

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
var TreeUtils = /*#__PURE__*/function () {
  function TreeUtils() {
    _classCallCheck(this, TreeUtils);
  }

  _createClass(TreeUtils, null, [{
    key: "findParent",
    value: function findParent(pt, type) {
      var el = pt;

      while (true) {
        // eslint-disable-line no-constant-condition
        if (el == null) {
          return null;
        }

        if (el.constructor.name === type) {
          return el;
        }

        el = el.parentCtx;
      }
    }
  }, {
    key: "findAnyParent",
    value: function findAnyParent(pt) {
      var types = arguments.length > 1 && arguments[1] !== undefined ? arguments[1] : [];
      var el = pt;

      while (true) {
        // eslint-disable-line no-constant-condition
        if (el == null) {
          return null;
        }

        if (types.indexOf(el.constructor.name) > -1) {
          return el;
        }

        el = el.parentCtx;
      }
    }
  }, {
    key: "findChild",
    value: function findChild(element, type) {
      if (element == null) {
        return null;
      }

      if (element.constructor.name === type) {
        return element;
      }

      if (element.children != null) {
        for (var i = 0; i < element.children.length; i += 1) {
          var e = element.children[i];
          var result = TreeUtils.findChild(e, type);

          if (result != null) {
            return result;
          }
        }
      }

      return null;
    }
  }, {
    key: "getPosition",
    value: function getPosition(el) {
      if (el != null) {
        var start = el.start,
            stop = el.stop,
            symbol = el.symbol;

        if (symbol != null) {
          return {
            start: symbol.start,
            stop: symbol.stop
          };
        } else if (start != null && stop != null) {
          return {
            start: start.start,
            stop: stop.stop
          };
        }
      }

      return null;
    }
  }, {
    key: "hasErrorNode",
    value: function hasErrorNode(element) {
      if (element == null) {
        return false;
      }

      if (element.isErrorNode && element.isErrorNode()) {
        return true;
      }

      if (element.children != null) {
        for (var i = 0; i < element.children.length; i += 1) {
          var e = element.children[i];
          var childHasErrorNode = TreeUtils.hasErrorNode(e);

          if (childHasErrorNode) {
            return true;
          }
        }
      }

      return false;
    }
  }]);

  return TreeUtils;
}();

exports.default = TreeUtils;
//# sourceMappingURL=TreeUtils.js.map