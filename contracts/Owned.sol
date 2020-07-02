pragma solidity >=0.4.21 <0.7.0;

contract owned {
    // 编译器会自动为public的变量生成读取函数，
    // 因此在index.js文件中 const {owner} = this.coin.methods;
    address public owner;

    constructor() public {
        owner = msg.sender;
    }

    modifier onlyOwner {
        require(msg.sender == owner);
        _;
    }

    function transferOwnership(address newOwner) onlyOwner public {
        owner = newOwner;
    }
}