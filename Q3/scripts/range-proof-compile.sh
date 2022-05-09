#!/bin/bash

# [assignment] create your own bash script to compile Multipler3.circom modeling after compile-HelloWorld.sh below
cd contracts/circuits


mkdir RangeProof

if [ -f ./powersOfTau28_hez_final_10.ptau ]; then
    echo "powersOfTau28_hez_final_10 already exists. Skipping."
else
    echo 'Downloading powersOfTau28_hez_final_10.ptau'
    wget https://hermez.s3-eu-west-1.amazonaws.com/powersOfTau28_hez_final_10.ptau
fi

echo "Compiling RangeProof.circom..."

# compile circuit

circom RangeProof.circom --r1cs --wasm --sym -o RangeProof
snarkjs r1cs info RangeProof/RangeProof.r1cs

# Start a new zkey and make a contribution

snarkjs plonk setup RangeProof/RangeProof.r1cs powersOfTau28_hez_final_10.ptau RangeProof/circuit_final.zkey

# generate solidity contract
snarkjs zkey export solidityverifier RangeProof/circuit_final.zkey ../RangeProofVerifier.sol

cd ../..