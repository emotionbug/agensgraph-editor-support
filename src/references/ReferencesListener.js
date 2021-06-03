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

import AgensGraphListener from '../_generated/AgensGraphParserListener';
import * as CypherTypes from '../lang/CypherTypes';

class Index {
  names = {};

  namesByQuery = [];

  referencesByName = {};

  referencesByQueryAndName = [];

  addQuery() {
    this.namesByQuery.push([]);
    this.referencesByQueryAndName.push({});
  }

  add(ctx, addName = true) {
    const queryIndex = this.namesByQuery.length - 1;
    const text = ctx.getText();
    if (addName) {
      this.names[text] = true;
      this.namesByQuery[queryIndex][text] = true;
    }
    this.referencesByName[text] = [...(this.referencesByName[text] || []), ctx];
    const index = this.referencesByQueryAndName[queryIndex];
    index[text] = [...(index[text] || []), ctx];
  }

  /**
   * Variables have specific rules, because they participate in autocompletion.
   * We should not add to the names list variables that are in expression.
   */
  addVariable(ctx) {
    let addName = true;

    // If variable is inside atom, then variable is inside expression.
    // Therefore, variables is node defined here.
    const parent = ctx.parentCtx;
    if (parent && parent.constructor.name === CypherTypes.ATOM_CONTEXT) {
      addName = false;
    }
    this.add(ctx, addName);
  }
}

export default class ReferencesListener extends AgensGraphListener {
  queries = [];

  queriesAndCommands = [];

  statements = [];

  raw = [];

  indexes = CypherTypes.SYMBOLIC_CONTEXTS.reduce(
    (acc, t) => ({
      ...acc,
      [t]: new Index(t),
    }),
    {},
  );

  enterRaw(ctx) {
    this.raw.push(ctx);
  }

  exitRaw(ctx) {
    if (this.raw.length === 0) {
      this.raw.push(ctx);
    }
  }

  // eslint-disable-next-line camelcase
  exitPg_statement(ctx) {
    this.statements.push(ctx);
  }

  // eslint-disable-next-line camelcase
  enterPg_sql(ctx) {
    this.queries.push(ctx);
    this.queriesAndCommands.push(ctx);
    Object.keys(this.indexes)
      .forEach((k) => this.indexes[k].addQuery());
  }

  exitVariable(ctx) {
    this.indexes[CypherTypes.VARIABLE_CONTEXT].addVariable(ctx);
  }

  exitLabelName(ctx) {
    this.indexes[CypherTypes.LABEL_NAME_CONTEXT].add(ctx);
  }

  exitRelTypeName(ctx) {
    this.indexes[CypherTypes.RELATIONSHIP_TYPE_NAME_CONTEXT].add(ctx);
  }

  exitPropertyKeyName(ctx) {
    this.indexes[CypherTypes.PROPERTY_KEY_NAME_CONTEXT].add(ctx);
  }

  exitParameterName(ctx) {
    this.indexes[CypherTypes.PARAMETER_NAME_CONTEXT].add(ctx);
  }
}
