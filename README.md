# truffle-lottery

`$ truffle unbox webpack`

`$ truffle compile`
`$ truffle migrate`  //clear build/contracts

Run dev server:
`cd app`  
`npm run dev`  

## web3js

[getBalance](https://web3js.readthedocs.io/en/v1.2.0/web3-eth.html#getbalance)
[web3.utils](https://web3js.readthedocs.io/en/v1.2.0/web3-utils.html) [fromWei](https://web3js.readthedocs.io/en/v1.2.0/web3-utils.html#fromwei)

## Migrations.sol

```js
contract Migrations {
    function upgrade(address new_address) public restricted {
        Migrations upgraded = Migrations(new_address);
        upgraded.setCompleted(last_completed_migration);
    }
```

## debug

> Could not connect to contract or chain.

檢查切換網路 metamask網路  RPC URL http://127.0.0.1:7545

truffle PRIVATE KEY  
metamask 匯入帳戶 > 私鑰  (存入 ETH)

> Error: LotteryCoin has no network configuration for its current network id (5777).

[Truffle migrate success but contract address is not displayed](https://stackoverflow.com/questions/49785667/truffle-migrate-success-but-contract-address-is-not-displayed)

```js
module.exports = function(deployer) {
  // deployer.deploy(LotteryCoin);
  // deployer.deploy(LotteryShop, LotteryCoin.address);

  deployer.deploy(LotteryCoin).then(function() {
    return deployer.deploy(LotteryShop, LotteryCoin.address);
  });
};
```

## note

输入投注序列组合 需要充值ETH

## References

[Dapp-on-Ethereum](https://github.com/9992800/Dapp-on-Ethereum/) [lottery](https://github.com/9992800/Dapp-on-Ethereum/tree/master/chapter-6/lottery)
