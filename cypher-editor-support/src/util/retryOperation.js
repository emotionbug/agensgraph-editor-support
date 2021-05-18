const wait = (ms) => new Promise((r) => setTimeout(r, ms));

export default function retryOperation(operation, delay, times) {
  return new Promise((resolve, reject) => operation()
    .then(resolve)
    .catch((reason) => {
      if (times - 1 > 0) {
        return wait(delay)
          .then(retryOperation.bind(null, operation, delay, times - 1))
          .then(resolve)
          .catch(reject);
      }
      return reject(reason);
    }));
}
