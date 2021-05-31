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

  it('CREATE VLABEL', () => {
    const b = new CypherEditorSupport('CREATE VLABEL v0;');
    expect(b.parseErrors).to.deep.equal([]);
  });

  it('CREATE ELABEL', () => {
    const b = new CypherEditorSupport('CREATE ELABEL "e0";');
    expect(b.parseErrors).to.deep.equal([]);
  });

  it('CREATE VLABEL INHERITS', () => {
    const b = new CypherEditorSupport('CREATE VLABEL v00 INHERITS (v0);');
    expect(b.parseErrors).to.deep.equal([]);
  });

  it('CREATE ELABEL INHERITS', () => {
    const b = new CypherEditorSupport('CREATE ELABEL e00 INHERITS (e0);');
    expect(b.parseErrors).to.deep.equal([]);
  });

  it('ALTER VLABEL IF EXISTS label_name RENAME TO new_name', () => {
    const b = new CypherEditorSupport('ALTER VLABEL IF EXISTS label_name RENAME TO new_name;');
    expect(b.parseErrors).to.deep.equal([]);
  });

  it('ALTER VLABEL IF EXISTS label_name OWNER TO new_owner', () => {
    const b = new CypherEditorSupport('ALTER VLABEL IF EXISTS label_name OWNER TO new_owner');
    expect(b.parseErrors).to.deep.equal([]);
  });

  it('ALTER VLABEL IF EXISTS label_name SET TABLESPACE new_tablespace', () => {
    const b = new CypherEditorSupport('ALTER VLABEL IF EXISTS label_name SET TABLESPACE new_tablespace;');
    expect(b.parseErrors).to.deep.equal([]);
  });

  it('ALTER VLABEL IF EXISTS label_name CLUSTER ON idxname', () => {
    const b = new CypherEditorSupport('ALTER VLABEL IF EXISTS label_name CLUSTER ON idxname;');
    expect(b.parseErrors).to.deep.equal([]);
  });

  it('ALTER VLABEL IF EXISTS label_name SET LOGGED', () => {
    const b = new CypherEditorSupport('ALTER VLABEL IF EXISTS label_name SET LOGGED;');
    expect(b.parseErrors).to.deep.equal([]);
  });

  it('ALTER VLABEL IF EXISTS label_name SET UNLOGGED', () => {
    const b = new CypherEditorSupport('ALTER VLABEL IF EXISTS label_name SET UNLOGGED;');
    expect(b.parseErrors).to.deep.equal([]);
  });

  it('ALTER VLABEL IF EXISTS label_name INHERIT parent_label', () => {
    const b = new CypherEditorSupport('ALTER VLABEL IF EXISTS label_name INHERIT parent_label;');
    expect(b.parseErrors).to.deep.equal([]);
  });

  it('ALTER VLABEL IF EXISTS label_name NO INHERIT parent_label', () => {
    const b = new CypherEditorSupport('ALTER VLABEL IF EXISTS label_name NO INHERIT parent_label;');
    expect(b.parseErrors).to.deep.equal([]);
  });

  it('ALTER VLABEL IF EXISTS label_name DISABLE INDEX', () => {
    const b = new CypherEditorSupport('ALTER VLABEL IF EXISTS label_name DISABLE INDEX;');
    expect(b.parseErrors).to.deep.equal([]);
  });
});
