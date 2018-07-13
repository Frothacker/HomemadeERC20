const HDWalletProvider = require('truffle-hdwallet-provider');
const Web3 = require('web3');
const fs = require('fs-extra');

const contract = require('./build/Token.json'); // remember to change Token.json to the contract you want to deploy

const interface = contract.interface;
const bytecode = contract.bytecode;

const provider = new HDWalletProvider(
  'frog drift question patch century make female garment demand undo gentle unhappy',
  'https://rinkeby.infura.io/P9cWIMe0PO6n3SWQcYzE'
);
const web3 = new Web3(provider);

const deploy = async () => {
  const accounts = await web3.eth.getAccounts();

  console.log('Attempting to deploy from account', accounts[0]);

  const result = await new web3.eth.Contract(JSON.parse(interface))
    .deploy({ data: '0x' + bytecode })
    .send({ gas: '1000000', from: accounts[0] });

  console.log('Contract interface is', interface);
  console.log('Contract deployed to', result.options.address);
};
deploy();

// every time you deploy it creates a new contract address.
// that you need to create a javascript representation of the contract for front end
// using address + Abi => `await new web3.eth.Contract( interface, Bytecode )`
// remember to leave off the `.deploy`
