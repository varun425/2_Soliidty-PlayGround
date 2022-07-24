const { sign } = require('crypto')
const {
  keccak256,
  defaultAbiCoder,
  toUtf8Bytes,
  solidityPack,
} = require('ethers/lib/utils')
const { ecsign } = require('ethereumjs-util')
const ethutil = require('ethereumjs-util')
var Web3 = require('web3')
var web3 = new Web3()

const nameOfToken = "MyToken"
const deployedAt = "0x718FAd810376be626b29166AD95dE03B9AB58acf"
const owner = "0x31D0A9A6C679598446245f0a01Ee09e26c1183E3"
const spender = "0x8b80805b94286ABb973cc0CDFE13d0e9f88dc394"
const chainid = 97
const approval = 1000000
const nonce = 5

const deadlineForSignature = Math.ceil(Date.now() / 1000) + 8600

const PERMIT_TYPEHASH = keccak256(
  toUtf8Bytes(
    'Permit(address owner,address spender,uint256 value,uint256 nonce,uint256 deadline)',
  ),
)

console.log('PERMIT_TYPEHASH:', PERMIT_TYPEHASH)
function getPermitDigest(
  name,
  address,
  chainId,
  owner,
  spender,
  value,
  nonce,
  deadline,
) {
  const DOMAIN_SEPARATOR = getDomainSeparator(name, address, chainId)
  console.log('DOMAIN_SEPARATOR:', DOMAIN_SEPARATOR)
  return keccak256(
    solidityPack(
      ['bytes1', 'bytes1', 'bytes32', 'bytes32'],
      [
        '0x19',
        '0x01',
        DOMAIN_SEPARATOR,
        keccak256(
          defaultAbiCoder.encode(
            ['bytes32', 'address', 'address', 'uint256', 'uint256', 'uint256'],
            [PERMIT_TYPEHASH, owner, spender, value, nonce, deadline],
          ),
        ),
      ],
    ),
  )
}

// Gets the EIP712 domain separator
function getDomainSeparator(name, contractAddress, chainId) {
  return keccak256(
    defaultAbiCoder.encode(
      ['bytes32', 'bytes32', 'bytes32', 'uint256', 'address'],
      [
        keccak256(
          toUtf8Bytes(
            'EIP712Domain(string name,string version,uint256 chainId,address verifyingContract)',
          ),
        ),
        keccak256(toUtf8Bytes(name)),
        keccak256(toUtf8Bytes('1')),
        chainId,
        contractAddress,
      ],
    ),
  )
}

const data = getPermitDigest(
  nameOfToken,
  deployedAt,
  chainid,
  owner,
  spender,
  approval,
  nonce,
  deadlineForSignature,
)
console.log("hashed-data",data)

const ownerPrivateKey = Buffer.from(
  '----------prtivate-key----------------',
  'hex',
)

const signature2 = ecsign(Buffer.from(data.slice(2), 'hex'), ownerPrivateKey)
console.log("deadline: ",deadlineForSignature)
console.log("nonce: ",0)
console.log('v: ', web3.utils.hexToNumber(ethutil.bufferToHex(signature2.v)))
console.log('r: ', ethutil.bufferToHex(signature2.r))
console.log('s: ', ethutil.bufferToHex(signature2.s))
