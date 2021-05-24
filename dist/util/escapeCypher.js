"use strict";

Object.defineProperty(exports, "__esModule", {
  value: true
});
exports.default = escapeCypher;

function escapeCypher(str) {
  var prefix = str.startsWith(':') ? ':' : '';
  var content = str;

  if (prefix.length > 0) {
    content = str.substring(1);
  }

  return /^[A-Za-z][A-Za-z0-9_]*$/.test(content) ? prefix + content : "".concat(prefix, "`").concat(content.replace(/`/g, '``'), "`");
}
//# sourceMappingURL=escapeCypher.js.map