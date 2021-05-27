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

import { expect } from 'chai';
import CypherEditorSupport from '../../src/CypherEditorSupport';

describe('Parser - AgensGraph DML', () => {
  it('CREATE GRAPH', () => {
    const b = new CypherEditorSupport('CREATE GRAPH t');
    expect(b.parseErrors).to.deep.equal([]);
  });

  it('CREATE GRAPH IF NOT EXISTS', () => {
    const b = new CypherEditorSupport('CREATE GRAPH IF NOT EXISTS t');
    expect(b.parseErrors).to.deep.equal([]);
  });

  it('SHOW GRAPH', () => {
    const b = new CypherEditorSupport('SHOW graph_path;');
    expect(b.parseErrors).to.deep.equal([]);
  });

  it('ALTER GRAPH NAME', () => {
    const b = new CypherEditorSupport('ALTER GRAPH ddl RENAME TO p;');
    expect(b.parseErrors).to.deep.equal([]);
  });

  it('ALTER GRAPH OWNER', () => {
    const b = new CypherEditorSupport('ALTER GRAPH ddl OWNER TO temp;');
    expect(b.parseErrors).to.deep.equal([]);
  });

  it('should successfully past call where string contains cypher with new lines', () => {
    const b = new CypherEditorSupport('CALL foo.bar("MATCH (n) \nRETURN n")');
    expect(b.parseErrors).to.deep.equal([]);
  });
});
