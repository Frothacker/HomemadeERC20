const path = require('path');
const fs = require('fs-extra');
const solc = require('solc');

// delete build folder
const buildPath = path.resolve(__dirname, 'build');
fs.removeSync(buildPath);

// read content from contract files in contract folder
const filepath = path.resolve(__dirname, 'contracts', 'Token.sol');
const source = fs.readFileSync(filepath, 'utf8');

// compile that content using solc
const output = solc.compile(source, 1).contracts;

//re-create build directory.
fs.ensureDirSync(buildPath);

console.log(output);
// write each contract into build folder
for (let contract in output) {
  // outputJsonSync takes arguments of (path/file, content)
  fs.outputJsonSync(
    path.resolve(buildPath, contract.replace(':', '') + '.json'), // makes file in build folder
    output[contract] // writes in compiled contract
  );
}

// from video 131, 7:21, Udemny ethreum course
