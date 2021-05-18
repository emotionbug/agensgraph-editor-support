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

import assert from 'assert';
import CypherEditorSupport from '../../src/CypherEditorSupport';

describe('Parser - special functions', () => {
  it('should successfully parse shortest path function', () => {
    const b = new CypherEditorSupport('RETURN shortestPath( ( f)-[]-( t) );');
    assert.deepStrictEqual(b.parseErrors, []);
  });

  it('should successfully parse all shortest path function', () => {
    const b = new CypherEditorSupport('RETURN allshortestPath((f)-[]-(t));');
    assert.deepStrictEqual(b.parseErrors, []);
  });

  it('should successfully parse exists function', () => {
    const b = new CypherEditorSupport('RETURN n.prop AS prop1, exists((n)-[:SOMETHING]->()) AS something;');
    assert.deepStrictEqual(b.parseErrors, []);
  });
  it('should successfully parse 3rd party functions', () => {
    const b = new CypherEditorSupport('RETURN a.b();');
    assert.deepStrictEqual(b.parseErrors, []);
  });
});
