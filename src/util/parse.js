import antlr4 from 'antlr4';
import ReferencesProvider from '../references/ReferencesProvider';
import * as CypherTypes from '../lang/CypherTypes';
import AgensGraphParser from '../_generated/AgensGraphParser';
import AgensGraphLexer from '../_generated/AgensGraphLexer';
import ErrorListener from '../errors/ErrorListener';
import ReferencesListener from '../references/ReferencesListener';

export default function parse(input) {
  const referencesListener = new ReferencesListener();
  const errorListener = new ErrorListener();
  const chars = new antlr4.InputStream(input);
  const lexer = new AgensGraphLexer(chars);
  lexer.removeErrorListeners();
  lexer.addErrorListener(errorListener);
  const tokens = new antlr4.CommonTokenStream(lexer);
  const parser = new AgensGraphParser(tokens);
  parser.buildParseTrees = true;
  parser.removeErrorListeners();
  parser.addErrorListener(errorListener);
  parser.addParseListener(referencesListener);
  const parseTree = parser.pg_sql();
  const { queries, indexes } = referencesListener;

  const referencesProviders = CypherTypes.SYMBOLIC_CONTEXTS.reduce(
    (acc, t) => ({
      ...acc,
      [t]: new ReferencesProvider(queries, indexes[t]),
    }),
    {},
  );

  return {
    parseTree, referencesListener, errorListener, referencesProviders,
  };
}
