pragma circom 2.0.0;

include "../../node_modules/circomlib/circuits/comparators.circom";

template RangeProof(n) {
    assert(n <= 252);
    signal input in; // this is the number to be proved inside the range
    signal input range[2]; // the two elements should be the range, i.e. [lower bound, upper bound]
    signal output out;

    component low = LessEqThan(n);
    component high = GreaterEqThan(n);

    // [assignment] insert your code here
    // "in" should be equal or greater than first number from range
    high.in[0] <== in;
    high.in[1] <== range[0];
    // "in" should be equal or lesser than the second number from range
    low.in[0] <== in;
    low.in[1] <== range[1];
    // assert that both constraints are true (1 and 1 which product is 1)
    assert(1 == low.out * high.out);
    // output the result
    out <== low.out * high.out;
}

// component main = RangeProof(32);