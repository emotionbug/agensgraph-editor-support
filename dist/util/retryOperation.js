"use strict";

Object.defineProperty(exports, "__esModule", {
  value: true
});
exports.default = retryOperation;

var wait = function wait(ms) {
  return new Promise(function (r) {
    return setTimeout(r, ms);
  });
};

function retryOperation(operation, delay, times) {
  return new Promise(function (resolve, reject) {
    return operation().then(resolve).catch(function (reason) {
      if (times - 1 > 0) {
        return wait(delay).then(retryOperation.bind(null, operation, delay, times - 1)).then(resolve).catch(reject);
      }

      return reject(reason);
    });
  });
}
//# sourceMappingURL=retryOperation.js.map