// import fs from "fs";

// const reset = "\x1b[0m";
// const dim = "\x1b[2m";
// const green = "\x1b[32m";

// console.log("node", process.argv[0]);
// console.log("curr", process.argv[1]);
const line = process.argv[2]; // Was `filePath`
// console.log("temp", process.argv[2]);
const target = process.argv[3];
// console.log("targ", process.argv[3]);
const replacement = process.argv[4];
// console.log("repl", process.argv[4]);
// console.log("null", process.argv[5]);

(async (...argv) => {
  try {
    console.log("Called with args: ", argv);
    const result = await line.replace(target, replacement);
    return result;
  } catch (err) {
    console.error("Error replacing text: ", err);
    throw err;
  }
})(process.argv);

// (async (...argv) => {
//   console.log("Called with args: ", argv);
//   // Your existing code here
//   let result;

//   return await fs.readFile(
//     filePath,
//     "utf8",
//     async (err, data) => {
//       if (err) {
//         console.error("Error reading file: ", err);
//         throw err;
//       }

//       // console.log("File read");

//       // console.log("Data", data);

//       try {
//         result = await data.replace(target, replacement);
//       } catch (err) {
//         console.error("Error replacing text: ", err);
//         throw err;
//       }

//       // console.log("Text replaced", result);
//       return await fs.writeFile(
//         filePath,
//         result,
//         "utf8",
//         (err) => {
//           if (err) {
//             console.error("Error writing file: ", err);
//             throw err;
//           }
//           console.log("File written.");
//           return result;
//         }
//       );
//     }
//   );
// })(process.argv);
