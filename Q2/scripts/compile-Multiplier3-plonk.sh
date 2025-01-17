#!/bin/bash

# [assignment] create your own bash script to compile Multipler3.circom modeling after compile-HelloWorld.sh below
cd contracts/circuits


mkdir Multiplier3_plonk

if [ -f ./powersOfTau28_hez_final_10.ptau ]; then
    echo "powersOfTau28_hez_final_10 already exists. Skipping."
else
    echo 'Downloading powersOfTau28_hez_final_10.ptau'
    wget https://hermez.s3-eu-west-1.amazonaws.com/powersOfTau28_hez_final_10.ptau
fi

echo "Compiling Multiplier3_plonk.circom..."

# compile circuit

circom Multiplier3.circom --r1cs --wasm --sym -o Multiplier3_plonk
snarkjs r1cs info Multiplier3_plonk/Multiplier3.r1cs

# Start a new zkey and make a contribution

# snarkjs groth16 setup Multiplier3_plonk/Multiplier3_plonk.r1cs powersOfTau28_hez_final_10.ptau Multiplier3_plonk/circuit_0000.zkey
snarkjs plonk setup Multiplier3_plonk/Multiplier3.r1cs powersOfTau28_hez_final_10.ptau Multiplier3_plonk/circuit_final.zkey

# snarkjs zkey contribute Multiplier3_plonk/circuit_0000.zkey Multiplier3_plonk/circuit_final.zkey --name="1st Contributor Name" -v -e="random text"
# snarkjs zkey export verificationkey Multiplier3_plonk/circuit_final.zkey Multiplier3_plonk/verification_key.json

# snarkjs zkey verify Multiplier3_plonk/Multiplier3.r1cs powersOfTau28_hez_final_10.ptau Multiplier3_plonk/circuit_final.zkey

# generate solidity contract
snarkjs zkey export solidityverifier Multiplier3_plonk/circuit_final.zkey ../Multiplier3_plonkVerifier.sol

cd ../..