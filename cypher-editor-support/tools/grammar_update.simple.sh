#!/bin/bash

java \
    -Xmx500M \
    -cp "tools/antlr-4.9.2-complete.jar" \
    org.antlr.v4.Tool \
    -Dlanguage=JavaScript \
    src/_generated.simple/Cypher.g4

rm -f src/_generated.simple/Cypher.tokens
rm -f src/_generated.simple/CypherLexer.tokens
