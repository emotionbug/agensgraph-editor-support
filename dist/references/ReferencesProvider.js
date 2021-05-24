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
var ReferencesProvider = /*#__PURE__*/function () {
  function ReferencesProvider(queries, index) {
    _classCallCheck(this, ReferencesProvider);

    _defineProperty(this, "queries", []);

    _defineProperty(this, "index", {});

    var names = index.names,
        namesByQuery = index.namesByQuery,
        referencesByName = index.referencesByName,
        referencesByQueryAndName = index.referencesByQueryAndName;
    this.queries = queries;
    this.index = {
      names: Object.keys(names),
      namesByQuery: namesByQuery.map(function (q) {
        return Object.keys(q);
      }),
      referencesByName: referencesByName,
      referencesByQueryAndName: referencesByQueryAndName
    };
  }

  _createClass(ReferencesProvider, [{
    key: "getReferences",
    value: function getReferences(name) {
      var query = arguments.length > 1 && arguments[1] !== undefined ? arguments[1] : null;

      if (query == null) {
        return this.index.referencesByName[name];
      }

      var pos = this.queries.indexOf(query);
      return (this.index.referencesByQueryAndName[pos] || {})[name];
    }
  }, {
    key: "getNames",
    value: function getNames() {
      var query = arguments.length > 0 && arguments[0] !== undefined ? arguments[0] : null;

      if (query == null) {
        return this.index.names;
      }

      var pos = this.queries.indexOf(query);
      return this.index.namesByQuery[pos] || [];
    }
  }]);

  return ReferencesProvider;
}();

exports.default = ReferencesProvider;
//# sourceMappingURL=ReferencesProvider.js.map