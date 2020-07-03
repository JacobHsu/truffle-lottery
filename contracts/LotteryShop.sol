// SPDX-License-Identifier: MIT
pragma solidity >=0.4.21 <0.7.0;

import "./Owned.sol";

interface token {
    function transfer(address receiver, uint amount) external returns(bool);
    function transferFrom(address from, address to, uint amount) external returns(bool);
    function balanceOf(address account) external view returns (uint);
}

contract LotteryShop is owned{

    token public tokenReward;
    bool public closed;

    struct BetItem{
        address bettor;
        bytes3  betStr;
        uint256 betNo;
    }
    BetItem[] private currentBets;
    mapping(address=>BetItem[]) betForUser;
    // 变量用来记录往期的中奖者信息和当前期的中奖者信息
    address[] public allWinners;
    address public currentWinner;
    // 声明需要记录在区块链上的日志
    event GetWinner(address winner, uint pahse, uint fee, uint rewards);
    event Bet(address bettor, bytes3 betStr, uint256 betNo);

    constructor(address addressOfTokenUsedAsReward) public{
        // 将该地址类型转换为token接口类型，该接口类型在第6～10行代码给出了定义，它描述了彩票token合约在本管理合约中需要暴露的函数原型
        tokenReward = token(addressOfTokenUsedAsReward);
        closed = false;
    }

    function bet(bytes3 betStr, uint256 sum) public {
        require(closed == false);

        BetItem memory item  = BetItem({
            bettor:msg.sender,
            betStr:betStr,
            betNo:sum
        });

        currentBets.push(item);

        betForUser[msg.sender].push(item);

        // tokenReward.transfer(address(this), sum);

        emit Bet(msg.sender, betStr, sum);
    }

    // 查询投注信息的合约
    function allMyBets()public view returns (bytes3[] memory, uint256[] memory, bool, address){
        // 根据当前账户地址查询出了该账户下所有的投注记录
        BetItem[] memory myBets = betForUser[msg.sender];

        // 然后通过新定义的2个数组返回给调用者
        uint length = myBets.length;
        bytes3[] memory strs = new bytes3[](length);
        uint256[] memory nos = new uint256[](length);

        for(uint i = 0; i <length; i++){
            BetItem memory item = myBets[i];
            strs[i]=(item.betStr);
            nos[i] = (item.betNo);
        }

        return (strs, nos, closed, currentWinner);
    }

    function myCurrentBetTimes() public view returns (uint){
        return betForUser[msg.sender].length;
    }

    function myBets(uint itemNo) public view returns(bytes3, uint256){
        BetItem[] storage items = betForUser[msg.sender];

        if (items.length < itemNo){
            return ("", 0);
        }

        BetItem memory item = items[itemNo];
        return (item.betStr, item.betNo);
    }

    function closeAndFindWinner() public onlyOwner{
        require(closed == false); //检查投注状态
        require(currentBets.length > 4);
        closed = true; //关闭投注

        currentWinner = random(); //选出投票人并记录下来
        allWinners.push(currentWinner);

        uint fee = tokenReward.balanceOf(address(this)) / 10; // 收取10%的手续费

        tokenReward.transferFrom(address(this), owner, fee);

        uint rewards =  tokenReward.balanceOf(address(this));  // 兑奖
        // 将剩余的token作为奖金发送给中奖者
        tokenReward.transferFrom(address(this), currentWinner, fee);
        // 将该开奖行为记录在区块链日志上。
        emit GetWinner(currentWinner, allWinners.length, fee, rewards);
    }

    // 选举中奖者
    function random() private view returns (address){
        uint randIdx = (block.number^block.timestamp) % currentBets.length;
        BetItem memory item = currentBets[randIdx];
        return item.bettor;
    }

    function reOpen() public onlyOwner{
        require(closed == true);
        closed = false;
        for (uint i = 0; i < currentBets.length; i++){
            delete betForUser[currentBets[i].bettor]; //删除旧的存储信息
        }
        delete currentBets; //清空中奖信息重新开始投注
        delete currentWinner;
    }
}