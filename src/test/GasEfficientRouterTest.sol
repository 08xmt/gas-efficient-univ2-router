// SPDX-License-Identifier: UNLICENSED
pragma solidity >=0.6.12;
pragma experimental ABIEncoderV2;

import "ds-test/test.sol";
import "../../lib/openzeppelin-contracts/contracts/token/ERC20/ERC20.sol";
import "src/UniswapV2Pair.sol";
import "src/GasEfficientRouter.sol";
import "src/UniswapV2Factory.sol";
import "src/interfaces/IERC20.sol";
import "src/HopStruct.sol";

contract TestToken is ERC20 {
    constructor(address receiver) public ERC20("Test","TST") {
        _mint(receiver, 100 ether);
    }
}

interface CheatCodes {
  function prank(address) external;
  function startPrank(address) external;
}

contract GasEfficientRouterTest is DSTest {
    CheatCodes cheats = CheatCodes(HEVM_ADDRESS);
    TestToken token1;
    TestToken token2;
    TestToken token3;
    UniswapV2Factory pairFactory;
    address pair;
    address pair2;
    address sender = msg.sender;
    GasEfficientRouter router;

    function setUp() public {
        cheats.startPrank(sender);
        pairFactory = new UniswapV2Factory(sender);
        router = new GasEfficientRouter();//Setting weth address to 0 addr for now
        token1 = new TestToken(sender);
        token2 = new TestToken(sender);
        token3 = new TestToken(sender);
        token1.approve(address(router), 100 ether);
        token2.approve(address(router), 100 ether);
        token3.approve(address(router), 100 ether);
        pair = pairFactory.createPair(address(token1), address(token2));
        pair2 = pairFactory.createPair(address(token2), address(token3));
        router.addLiquidity(address(token1),address(token2), pair, 1 ether, 5 ether, 0, 0, msg.sender);
        router.addLiquidity(address(token2),address(token3), pair2, 10 ether, 10 ether, 0, 0, msg.sender);
    }

    function testAddLiquidity() public {
        router.addLiquidity(address(token1),address(token2), pair, 1 ether, 5 ether, 0, 0, msg.sender);
    }

    function testRemoveLiquidity() public {
        router.addLiquidity(address(token1),address(token2), pair, 1 ether, 5 ether, 0, 0, msg.sender);
        uint balance = IERC20Uniswap(pair).balanceOf(msg.sender);
        IERC20Uniswap(pair).approve(address(router), balance);
        router.removeLiquidity(pair, IERC20Uniswap(pair).balanceOf(msg.sender), 0, 0, msg.sender);
    }
    function testSwapExactFor() public {
        uint before = token1.balanceOf(msg.sender);
        HopStruct.Hop[] memory path = new HopStruct.Hop[](1);
        path[0] = HopStruct.Hop(true, pair);
        router.swapExactTokensForTokens(1 ether, 1, path, msg.sender);
        uint afterSwap = token1.balanceOf(msg.sender);
        assertGt(afterSwap, before);
    }
    
    function testSwapExactForDoubleHop() public {
        HopStruct.Hop[] memory path = new HopStruct.Hop[](2);
        path[0] = HopStruct.Hop(false, pair);
        path[1] = HopStruct.Hop(true, pair2);
        router.swapExactTokensForTokens(1 ether, 1, path, msg.sender);
    }

    function testSwapForExact() public {
        HopStruct.Hop[] memory path = new HopStruct.Hop[](1);
        path[0] = HopStruct.Hop(true, pair);
        router.swapTokensForExactTokens(1 ether/2, 10 ether, path, msg.sender);
    }

    function testSwapForExactDoubleHop() public {
        HopStruct.Hop[] memory path = new HopStruct.Hop[](2);
        path[0] = HopStruct.Hop(false, pair);
        path[1] = HopStruct.Hop(true, pair2);
        router.swapTokensForExactTokens(1 ether/2, 10 ether, path, msg.sender);
    }
}
