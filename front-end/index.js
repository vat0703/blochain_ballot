import Web3 from "web3";
import 'bootstrap/dist/css/bootstrap.css'
import $ from 'jquery'

import configuration from '../build/contracts/Ballot.json';
import { Button } from "bootstrap";

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


const getCenters = async() =>{
    const centers = await contract.methods.getVotingCenters().call({gas:343434});
console.log(centers)
}

const refreshCandidates = async () =>{
    candidatesEl.innerHTML = "";
    const candidates = await contract.methods.getCandidateList().call({gas:6721975});
    console.log(candidates) 
    candidates.forEach(element => {
        var container = document.createElement('div');
        container.className = 'col';
        var name = document.createElement('div');
        name.className = 'name';
        name.innerText = element.name;
       
        var image = document.createElement('img');
        image.src = element.partyFlag;
        image.style = "width:200px; height:200px"
        var vote = document.createElement('button');
        vote.id=element.nominationNumber;
        vote.className = "btn btn-success vote";
        vote.innerText = "Vote";
        vote.style= "width:200px; text-align:center; margin-top:10px";
        container.prepend(vote);
        container.prepend(image);
        container.prepend(name);

        candidatesEl.append(container)
    });

}

const vote = async(id) => {
    const accountToShow = await web3.eth.requestAccounts();
    accountView = accountToShow.toString();

   
        const centers = await contract.methods.getVotingCenter(accountToShow).call({gas:343434});
    console.log(centers);
    
    // await contract.methods.vote(id, centers[2].centerId).send({
    //     from: accountsInit[0],gas: 6721975   });
}



const  getResults = async() => {
    const test = await contract.methods.getResults().call({gas:343434});
    console.log(test)
}


const registerUser = async() =>{
    const accountToShow = await (await web3.eth.requestAccounts()).toString();
    console.log(accountToShow)
    var _from =accountsInit[0];

 
    await contract.methods.registerVoters(accountsInit).send({
        from: _from,gas: 6721975   });
    
}

const main = async () =>{
    const accounts = await web3Init.eth.getAccounts();
    accountsInit = accounts;
  

    const accountToShow = await web3.eth.requestAccounts();
    accountView = accountToShow.toString();


    accountEl.innerHTML = accountView;
   
    await refreshCandidates();
    await registerUser();
    await getCenters();
    


    }




main();


var test = document.getElementsByClassName('.vote');

$('button').each(function(index){
  
    $(this).trigger("click",vote(index+1));
    /* Do your stuffs here */
 
});
