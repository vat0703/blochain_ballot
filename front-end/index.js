import Web3 from "web3";
import 'bootstrap/dist/css/bootstrap.css'

import configuration from '../build/contracts/Ballot.json';

const CONTRACT_ADDRESS = configuration.networks['5777'].address;
const CONTRACT_ABI = configuration.abi;

const web3Init = new Web3(
    'http://127.0.0.1:7545'
);

const web3 = new Web3(
    Web3.givenProvider || 'http://127.0.0.1:7545'
);


const contract  = new web3.eth.Contract(CONTRACT_ABI, CONTRACT_ADDRESS);

const TOTAL_CANDIDATES = 5;


let accountsInit;

let accountView;

const accountEl = document.getElementById('account');
const candidatesEl = document.getElementById('candidates');

const refreshCandidates = async () =>{
    candidatesEl.innerHTML = "";
    debugger
    const candidates = await contract.methods.getCandidateList().call({gas:6721975});
    debugger
    candidatesEl.innerText = candidates;
    console.log(candidates) 

}

const main = async () =>{
    const accounts = await web3Init.eth.getAccounts();
    accountsInit = accounts;

    const accountToShow = await web3.eth.requestAccounts();
    accountView = accountToShow;

    accountEl.innerHTML = accountView;

    await refreshCandidates();


}

main();

