// SPDX-License-Identifier: UNLICENSED
pragma solidity >=0.6.0;

import "ds-test/test.sol";
import "../../lib/openzeppelin-contracts/contracts/token/ERC20/ERC20.sol";
import "src/UniswapV2Pair.sol";
import "src/UniswapV2Router02.sol";
import "src/UniswapV2Factory.sol";
import "src/interfaces/IERC20.sol";

contract TestToken is ERC20 {
    constructor(address receiver) public ERC20("Test","TST") {
        _mint(receiver, 100 ether);
    }
}

interface CheatCodes {
  function prank(address) external;
  function startPrank(address) external;
}

contract BasicRouterTest is DSTest {
    CheatCodes cheats = CheatCodes(HEVM_ADDRESS);
    TestToken token1;
    TestToken token2;
    UniswapV2Factory pairFactory;
    address pair;
    address sender = msg.sender;
    UniswapV2Router02 router;
        
    function setUp() public {
        cheats.startPrank(sender);
        pairFactory = new UniswapV2Factory(sender);
        router = new UniswapV2Router02(address(pairFactory), address(0));//Setting weth address to 0 addr for now
        token1 = new TestToken(sender);
        token2 = new TestToken(sender);
        token1.approve(address(router), 100 ether);
        token2.approve(address(router), 100 ether);
        router.addLiquidity(address(token1),address(token2),1 ether, 5 ether, 0, 0, msg.sender, block.number+100);
        pair = pairFactory.getPair(address(token1), address(token2));
    }

    function testAddLiquidity() public {
        router.addLiquidity(address(token1),address(token2),1 ether, 5 ether, 0, 0, msg.sender, block.number+100);
    }

    function testRemoveLiquidity() public {
        router.addLiquidity(address(token1),address(token2),1 ether, 5 ether, 0, 0, msg.sender, block.number+100);
        uint balance = IERC20Uniswap(pair).balanceOf(msg.sender);
        IERC20Uniswap(pair).approve(address(router), balance);
        router.removeLiquidity(address(token1),address(token2),IERC20Uniswap(pair).balanceOf(msg.sender), 0, 0, msg.sender, block.number+100);
    }

    function testSwapExactFor() public {
        address[] memory path = new address[](2);
        path[0] = address(token1);
        path[1] = address(token2);
        router.swapExactTokensForTokens(1 ether, 0, path, msg.sender, block.number);
    }

    function testSwapForExact() public {
        address[] memory path = new address[](2);
        path[0] = address(token1);
        path[1] = address(token2);
        router.swapTokensForExactTokens(1 ether / 2, 2 ether, path, msg.sender, block.number);
    }
}
