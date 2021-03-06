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

import { filter as fuzzySearch } from 'fuzzaldrin';
import _ from 'lodash';
import * as CypherTypes from '../lang/CypherTypes';
import * as CompletionTypes from './CompletionTypes';
import CypherKeywords from '../lang/CypherKeywords';
import TreeUtils from '../util/TreeUtils';
import escapeCypher from '../util/escapeCypher';

export const KEYWORD_ITEMS = CypherKeywords.map((keyword) => ({
  type: CompletionTypes.KEYWORD,
  view: keyword,
  content: keyword,
  postfix: null,
}));

class AbstractCachingCompletion {
  cache = {};

  constructor(cache = {}) {
    this.cache = cache;
  }

  // eslint-disable-next-line class-methods-use-this, no-unused-vars
  calculateItems(type, query = null) {
    return [];
  }

  complete(types, query) {
    return types
      .map((typeData) => {
        const cached = this.cache[typeData.type];
        if (cached != null) {
          return cached;
        }
        return this.calculateItems(typeData, query);
      })
      .reduce((acc, items) => [...acc, ...items], []);
  }
}

class SchemaBasedCompletion extends AbstractCachingCompletion {
  schema = {};

  static providers = {
    [CompletionTypes.PROCEDURE_OUTPUT]: (schema, typeData) => {
      const findByName = (e) => e.name === typeData.name && e.returnItems !== [];
      const procedure = _.find(schema.procedures, findByName);
      if (procedure) {
        return procedure.returnItems.map(({ name, signature }) => ({
          type: CompletionTypes.PROCEDURE_OUTPUT,
          view: name,
          content: name,
          postfix: ` :: ${signature}`,
        }));
      }
      return [];
    },
  };

  constructor(schema = {}) {
    super({
      [CompletionTypes.KEYWORD]: KEYWORD_ITEMS,
      [CompletionTypes.LABEL]: (schema.labels || [])
        .map((label) => ({
          type: CompletionTypes.LABEL,
          view: label,
          content: escapeCypher(label),
          postfix: null,
        })),
      [CompletionTypes.RELATIONSHIP_TYPE]: (schema.relationshipTypes || [])
        .map((relType) => ({
          type: CompletionTypes.RELATIONSHIP_TYPE,
          view: relType,
          content: escapeCypher(relType),
          postfix: null,
        })),
      [CompletionTypes.PROPERTY_KEY]: (schema.propertyKeys || [])
        .map((propKey) => ({
          type: CompletionTypes.PROPERTY_KEY,
          view: propKey,
          content: escapeCypher(propKey),
          postfix: null,
        })),
      [CompletionTypes.FUNCTION_NAME]: (schema.functions || [])
        .map(({ name, signature }) => ({
          type: CompletionTypes.FUNCTION_NAME,
          view: name,
          content: escapeCypher(name),
          postfix: signature,
        })),
      [CompletionTypes.PROCEDURE_NAME]: (schema.procedures || [])
        .map(({ name, signature }) => ({
          type: CompletionTypes.PROCEDURE_NAME,
          view: name,
          content: name,
          postfix: signature,
        })),
      [CompletionTypes.PARAMETER]: (schema.parameters || [])
        .map((parameter) => ({
          type: CompletionTypes.PARAMETER,
          view: parameter,
          content: parameter,
          postfix: null,
        })),
    });
    this.schema = schema;
  }

  calculateItems(typeData) {
    return (SchemaBasedCompletion.providers[typeData.type] || (() => []))(this.schema, typeData);
  }
}

class QueryBasedCompletion extends AbstractCachingCompletion {
  providers = {};

  emptyProvider = { getNames: () => [] };

  constructor(referenceProviders = {}) {
    super();
    this.providers = {
      [CompletionTypes.VARIABLE]:
        (query) => (referenceProviders[CypherTypes.VARIABLE_CONTEXT] || this.emptyProvider)
          .getNames(query)
          .map((name) => ({
            type: CompletionTypes.VARIABLE,
            view: name,
            content: name,
            postfix: null,
          })),
    };
  }

  calculateItems(typeData, query) {
    return (this.providers[typeData.type] || (() => []))(query);
  }
}

export class AutoCompletion {
  queryBased = null;

  schemaBased = null;

  constructor() {
    this.updateSchema({});
  }

  getItems(types, { query = null, filter = '' }) {
    const text = filter.toLowerCase();
    const filteredText = AutoCompletion.filterText(text);

    const completionItemFilter = () => true;

    const list = [this.queryBased, this.schemaBased]
      .filter((s) => s != null)
      .map((t) => t.complete(types, query))
      .reduce((acc, items) => [...acc, ...items], [])
      .filter(completionItemFilter);

    if (filteredText) {
      return fuzzySearch(list, filteredText, { key: 'view' });
    }
    if (text) {
      return fuzzySearch(list, text, { key: 'view' });
    }
    return list;
  }

  updateSchema(schema) {
    this.schemaBased = new SchemaBasedCompletion(schema);
  }

  updateReferenceProviders(referenceProviders) {
    this.queryBased = new QueryBasedCompletion(referenceProviders);
  }

  /**
   * Define whether element should be replaced or not.
   */
  static shouldBeReplaced(element) {
    if (element == null) {
      return false;
    }

    const text = element.getText();
    const parent = element.parentCtx;

    // If element is whitespace
    if (/^\s+$/.test(text)) {
      return false;
    }
    // If element is opening bracket (e.g. start of relationship pattern)
    if (text === '[') {
      return false;
    }
    // If element is opening brace (e.g. start of node pattern)
    if (text === '(') {
      return false;
    }

    if (text === '.') {
      return false;
    }

    if (text === '{') {
      return false;
    }
    if (text === '$') {
      return false;
    }
    return !(text === ':' && parent != null && parent.constructor.name === CypherTypes.MAP_LITERAL_ENTRY);
  }

  static filterText(text) {
    if (text.startsWith('$')) {
      return text.slice(1);
    }
    return text;
  }

  // eslint-disable-next-line no-unused-vars
  static calculateSmartReplaceRange(element, start) {
    // If we are in relationship type or label and we have error nodes in there.
    // This means that we typed in just ':' and Antlr consumed other tokens in element
    // In this case replace only ':'
    if (element.constructor.name === CypherTypes.RELATIONSHIP_TYPE_CONTEXT
      || element.constructor.name === CypherTypes.NODE_LABEL_CONTEXT) {
      if (TreeUtils.hasErrorNode(element)) {
        return { filterText: ':', start, stop: start };
      }
    }

    return null;
  }
}
