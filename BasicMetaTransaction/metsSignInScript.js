var Web3 = require('web3')
var web3 = new Web3()
const ethutil = require('ethereumjs-util')

let val = 'Hello,I am Meta-transaction'
let fnSignature = web3.utils.keccak256('setQuote(string)').substr(0, 10)
let fnParams = web3.eth.abi.encodeParameters(['string'], [val])

calldata = fnSignature + fnParams.substr(2)

console.log(calldata)


const createSignature = (params) => {
  params = {
    recipient: '0x3dB4d2aE9Ed244755A1544E7c7155a4163A1B6Ab',
    functionSignature: calldata,
    nonce: 0,
    chainID: 97,
    ...params,
  }
  const message = web3.utils
    .soliditySha3(
      { t: 'uint256', v: params.nonce },
      { t: 'address', v: params.recipient },
      { t: 'uint256', v: params.chainID },
      { t: 'bytes', v: params.functionSignature },
    )
    .toString('hex')
  const privKey =
    '0x77acff30743fe6db7e5cdbd00f9961939937ed7b40b33abfe3197b0435a4ba13'
  const signature = web3.eth.accounts.sign(message, privKey)
  console.log(signature)
  return { signature }
}

createSignature()
