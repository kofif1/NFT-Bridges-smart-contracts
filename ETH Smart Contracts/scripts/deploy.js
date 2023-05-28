
async function main() {
    const Arties = await ethers.getContractFactory('BridgeManager');
    const arties = await Arties.deploy();
    await arties.deployed();
    console.log("Arties deployed to", arties.address, await ethers.getSigner().then(ret => ret.address));
}

main();