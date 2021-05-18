#!/bin/bash

java \
    -Xmx500M \
    -cp "tools/antlr-4.9.2-complete.jar" \
    org.antlr.v4.Tool \
    -Dlanguage=JavaScript \
    src/_generated/Cypher.g4

rm -f src/_generated/Cypher.tokens
rm -f src/_generated/CypherLexer.tokens
