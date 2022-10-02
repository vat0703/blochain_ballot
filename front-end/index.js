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
        var voter = document.createElement('button');
        voter.id=element.name;
        voter.className = "btn btn-success vote "+element.name;
        voter.innerText = "Vote";
        voter.style= "width:200px; text-align:center; margin-top:10px";
        container.prepend(voter);
        container.prepend(image);
        container.prepend(name);
        voter.addEventListener('click', e=>{
            vote(voter.id);
        })
        candidatesEl.append(container)

      


    });

}



const vote = async(id) => {
    const accountToShow = await web3.eth.requestAccounts();
    accountView = accountToShow.toString();

   
        const centers = await contract.methods.getVotingCenter(accountView).call({gas:343434});
    console.log(centers);
    var finalID;
    switch(id){
        case "ND":
            finalID=0;
            break;
        case "PASOK":
            finalID=1;
            break;
        case "SYRIZA":
            finalID=2;
            break;
        case "KKE":
            finalID=3;
            break;
        case "MERA25":
            finalID=4;
            break;
        default: break;                    
    }
    
     await contract.methods.vote(centers, finalID).send({from: accountView,gas: 6721975});
          
}



const  getResults = async() => {
    const nd = document.getElementById('ND');
    const pasok = document.getElementById('PASOK');
    const syriza = document.getElementById('SYRIZA');
    const kke = document.getElementById('KKE');
    const mera25 = document.getElementById('MERA25');
    const ndParent = $(nd).parent('div');
    const pasokParent = $(pasok).parent('div');
    const syrizaParent = $(syriza).parent('div');
    const kkeParent = $(kke).parent('div');
    const mera25Parent = $(mera25).parent('div');

    var col0 = document.getElementsByClassName('col0');
    if(col0!=null){
        $(col0).remove();
    }

    var col1 = document.getElementsByClassName('col1');
    if(col1!=null){
        $(col1).remove();
    }

    var col2 = document.getElementsByClassName('col2');
    if(col2!=null){
        $(col2).remove();
    }

    var col3 = document.getElementsByClassName('col3');
    if(col3!=null){
        $(col3).remove();
    }

    var col4 = document.getElementsByClassName('col4');
    if(col4!=null){
        $(col4).remove();
    }

    const results = await contract.methods.getResults().call({gas:6721975});
    results.forEach((element, index) => {
        var container = document.createElement('div');
        container.className = 'col'+index;
        container.style ="margin-top: 10px;"
        var name = document.createElement('div');
        name.className = 'name';
        name.style = "width:200px; text-align:center";
        name.innerText ="Total Votes: " +element;
        container.prepend(name);
        switch(index){
            case 0: ndParent.append(container);
                break;
            case 1: pasokParent.append(container);
                break;
            case 2: syrizaParent.append(container);
                break;
            case 3: kkeParent.append(container);
                break;
            case 4: mera25Parent.append(container);       
                break;
            default:
                break;             
        }
    });    }


const registerUser = async() =>{
    const accountToShow = await (await web3.eth.requestAccounts()).toString();
    console.log(accountToShow)
    var _from =accountsInit[0];

 
    await contract.methods.registerVoters(accountsInit).send({
        from: _from,gas: 6721975   });
    
}
const voteReady = async () =>{
    await main();
}

const main = async () =>{
    const accounts = await web3Init.eth.getAccounts();
    accountsInit = accounts;
  

    const accountToShow = await web3.eth.requestAccounts();
    accountView = accountToShow.toString();


    accountEl.innerHTML = accountView;
   
    await refreshCandidates();
    await getCenters();

    }





document.getElementById("results").onclick = getResults;
document.getElementById("register").onclick = registerUser;
voteReady();


