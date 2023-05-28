
async function main() {
    const odd = await(await ethers.getContractFactory('C')).deploy();
    // const contract = await(await ethers.getContractFactory('NumberContract')).deploy();
    // const ret = await contract.callerFunction(odd.address);
    // console.log("ret value:", ret);
}

main();