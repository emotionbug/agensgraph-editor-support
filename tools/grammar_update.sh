#!/bin/bash

java \
    -Xmx500M \
    -cp "tools/antlr-4.9.2-complete.jar" \
    org.antlr.v4.Tool \
    -Dlanguage=JavaScript \
    src/_generated/AgensGraphLexer.g4 src/_generated/AgensGraphParser.g4

rm -f src/_generated/AgensGraphParser.tokens
rm -f src/_generated/AgensGraphLexer.tokens
