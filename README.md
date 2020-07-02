# truffle-lottery

`$ truffle unbox webpack`

`$ truffle compile`
`$ truffle migrate`  //clear build/contracts

當賬戶AAA成功部署合約之後，需要將賬戶下的token轉移到token合約地址下，

 Deploying 'LotteryCoin'
   -----------------------
   > transaction hash:    0xf53e1a86f660f5b3c854130bcb1f78e169eaadeb494e450310b5909f6692b54f
   > Blocks: 0            Seconds: 0
   > contract address:    0x70113250901c1D3992E1AA7EA1c3Bed51b8cD1a1 <--

複製提示中的合約地址信息，打開MetaMask界面，將該地址以token的形式添加到該賬戶下 (ETH.. LTC)

Run dev server:
`cd app`  
`npm run dev`  

## web3js

[getBalance](https://web3js.readthedocs.io/en/v1.2.0/web3-eth.html#getbalance)
[web3.utils](https://web3js.readthedocs.io/en/v1.2.0/web3-utils.html) [fromWei](https://web3js.readthedocs.io/en/v1.2.0/web3-utils.html#fromwei) [utf8ToHex](https://web3js.readthedocs.io/en/v1.2.0/web3-utils.html#utf8tohex)

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

> ALERT: 交易失敗。合約代碼拋出錯誤資訊

_transfer( 出問題

`require (balanceOf[_from] >= _value, 'Check if the sender has enough');`

"Overriding function is missing 'override' specifier."

移除前底線
`function transfer(address _from, address _to, uint _value) internal {`

## References

[Dapp-on-Ethereum](https://github.com/9992800/Dapp-on-Ethereum/) [lottery](https://github.com/9992800/Dapp-on-Ethereum/tree/master/chapter-6/lottery)
