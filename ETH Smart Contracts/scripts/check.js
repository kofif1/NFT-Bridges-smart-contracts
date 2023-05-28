
async function main() {
    const Arties = await ethers.getContractFactory('BridgeManager');
    const arties = await Arties.deploy();
    await arties.deployed();
    console.log("Arties deployed to", arties.address, await ethers.getSigner().then(a => a.address));
    const tx = await arties.mint_collection('arties', 'art', 'baseurl', 'stacks');
    const result = await tx.wait();
    const collection_address = result.events.pop().args.addr;
    console.log('collection', collection_address);
    const signature = '0x7c1fad6358de70eb475024c12a6876129763c07bbfa2e03ce5f5d8a3f370e343325db1ec4c0ad897955da3ceb6ef0d4a6bb299d2504641c8dd516db448d5715a1b';
    await arties.bridge2Eth(collection_address, 1, false, signature);
}

main(); 