#!/usr/bin/env node

// Github Copilot:
// The code you provided is written in JavaScript and is
// intended to be executed using Node.js, not in a bash shell.
// In Node.js, the `console.log` function is asynchronous, which
// means it may not finish executing before the program exits.
// By logging the result before returning it, you ensure that
// the result is printed before the program terminates.The code
// you provided is written in JavaScript and is intended to be
// executed using Node.js, not in a bash shell. In Node.js, the
// `console.log` function is asynchronous, which means it may
// not finish executing before the program exits. By logging the
// result before returning it, you ensure that the result is
// printed before the program terminates.

(async (argv) => {
  let result = argv[2].replace(argv[3], argv[4]);
  console.log(result);
  return result;
})(process.argv);
