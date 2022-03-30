pragma solidity >=0.6.6;
pragma experimental ABIEncoderV2;

import './interfaces/IUniswapV2Factory.sol';
import './libraries/TransferHelper.sol';

//import './libraries/UniswapV2Library.sol';
import './interfaces/IUniswapV2Router01.sol';
import './interfaces/IERC20.sol';
import './interfaces/IUniswapV2Pair.sol';
import "src/HopStruct.sol";


contract GasEfficientRouter {
    /* Deadlines are unnecessary for most use cases.
    modifier ensure(uint deadline) {
        require(deadline >= block.timestamp, 'UniswapV2Router: EXPIRED');
        _;
    }
    */
    // **** ADD LIQUIDITY ****
    function _addLiquidity(
        address tokenA,
        address tokenB,
        address pair, //Added pair parameter to allow for removal of factory
        uint amountADesired,
        uint amountBDesired,
        uint amountAMin,
        uint amountBMin
    ) private returns (uint amountA, uint amountB) {
        /* We're not interested in creating new pairs, so the following statement is unnecessary
        if (IUniswapV2Factory(factory).getPair(tokenA, tokenB) == address(0)) {
            IUniswapV2Factory(factory).createPair(tokenA, tokenB);
        }
        */
        /* It is more gas efficient to go straight to the source
        (uint reserveA, uint reserveB) = UniswapV2Library.getReserves(factory, tokenA, tokenB);
        */
        (uint reserveA, uint reserveB,) = IUniswapV2Pair(pair).getReserves();
        if (reserveA == 0 && reserveB == 0) {
            (amountA, amountB) = (amountADesired, amountBDesired);
        } else {
            /* The quote function checks for the following:
                1. ReserveA and reserve B == 0
                2. AmountDesired > 0
            Both of these checks are unnecessary as:
                1. Has already been checked when entering the if-else
                2. Will not cause a failure, even if the result may be a bit weird.
            uint amountBOptimal = UniswapV2Library.quote(amountADesired, reserveA, reserveB);
           */
            uint amountBOptimal = amountADesired * reserveB / reserveA;
            if (amountBOptimal <= amountBDesired) {
                require(amountBOptimal >= amountBMin, 'UniswapV2Router: INSUFFICIENT_B_AMOUNT');
                (amountA, amountB) = (amountADesired, amountBOptimal);
            } else {
                //uint amountAOptimal = UniswapV2Library.quote(amountBDesired, reserveB, reserveA);
                uint amountAOptimal = amountBDesired * reserveA / reserveB;
                //assert(amountAOptimal <= amountADesired);
                require(amountAOptimal >= amountAMin, 'UniswapV2Router: INSUFFICIENT_A_AMOUNT');
                (amountA, amountB) = (amountAOptimal, amountBDesired);
            }
        }
    }
    function addLiquidity(
        address tokenA,
        address tokenB,
        address pair,
        uint amountADesired,
        uint amountBDesired,
        uint amountAMin,
        uint amountBMin,
        address to
        /* We remove the deadline parameter, as a deadline is hardly necessary for every transaction
            - If deadline is interesting, then building a simple contract on top of the router to enforce
           them is better.
        uint deadline
        */
    ) external /*ensure(deadline)*/ returns (uint amountA, uint amountB, uint liquidity) {
        (amountA, amountB) = _addLiquidity(tokenA, tokenB, pair, amountADesired, amountBDesired, amountAMin, amountBMin);
        /* Pair is given in input parameters
        address pair = UniswapV2Library.pairFor(factory, tokenA, tokenB);

       The success of the transfer is left unchecked, as a 0 token transfer, will result in a revert
       */
        IERC20Uniswap(tokenA).transferFrom(msg.sender, pair, amountA);
        IERC20Uniswap(tokenB).transferFrom(msg.sender, pair, amountB);
        liquidity = IUniswapV2Pair(pair).mint(to);
    }

    // **** REMOVE LIQUIDITY ****
    function removeLiquidity(
        /*
        Token addresses are unnecessary, as we supply the pair address
        address tokenA,
        address tokenB,
        */
        address pair,
        uint liquidity,
        uint amount0Min,
        uint amount1Min,
        address to
        //uint deadline
    ) public  /*ensure(deadline) */ returns  (uint amountA, uint amountB) {
        //address pair = UniswapV2Library.pairFor(factory, tokenA, tokenB);
        IUniswapV2Pair(pair).transferFrom(msg.sender, pair, liquidity); // send liquidity to pair
        (uint amount0, uint amount1) = IUniswapV2Pair(pair).burn(to);
        /* No need to check which amount corresponds to which token, if we do it off chain
        (address token0,) = UniswapV2Library.sortTokens(tokenA, tokenB);
        (amountA, amountB) = tokenA == token0 ? (amount0, amount1) : (amount1, amount0);
        */
        require(amount0 >= amount0Min, 'UniswapV2Router: INSUFFICIENT_0_AMOUNT');
        require(amount1 >= amount1Min, 'UniswapV2Router: INSUFFICIENT_1_AMOUNT');
    }

    // **** SWAP ****
    // requires the initial amount to have already been sent to the first pair
    /*
    We remove the amounts parameter replacing it with _amountIn, as we only really care about the first amount, and can calculate the rest
    The address array of path is changed to an array of the Hop struct, which is a (bool, address), the address is the address of the pair
    while the bool flags whether token0 or token1 is the input token.
    The Hop struct uses the same word size as an address, but we can cut the size of the array in half, by using Hops.

    Finally, the swap now returns the last amountOut, so we can compare it to amountOutMin
    */
    function _swap(/*uint[] memory amounts,*/uint _amountIn, HopStruct.Hop[] memory path, address _to) private returns(uint amountOut){
        amountOut = _amountIn;
        for (uint i; i < path.length; i++) {
            //(address input, address output) = (path[i], path[i + 1]);
            IUniswapV2Pair pair = IUniswapV2Pair(path[i].pair);
            if(path[i].token0In){
                //uint amountOut = amounts[i + 1];
                (uint reserve0, uint reserve1,) = pair.getReserves();
                //Parameters for getAmountOut is amountIn, reserve0, reserve1
                //When doing multiple Hops, amountOut becomes amountIn in next hop
                amountOut = getAmountOut(amountOut, reserve0, reserve1);
                address to = i < path.length - 1 ? path[i + 1].pair : _to;
                //IUniswapV2Pair(UniswapV2Library.pairFor(factory, input, output)).swap(amount0Out, amount1Out, to, new bytes(0));
                pair.swap(0, amountOut, to, new bytes(0));
            } else {
                //uint amountOut = amounts[i + 1];
                (uint reserve0, uint reserve1,) = pair.getReserves();
                amountOut = getAmountOut(amountOut, reserve1, reserve0);
                //amountOut becomes amountIn in next loop
                address to = i < path.length - 1 ? path[i + 1].pair : _to;
                //IUniswapV2Pair(UniswapV2Library.pairFor(factory, input, output)).swap(amount0Out, amount1Out, to, new bytes(0));
                pair.swap(amountOut, 0, to, new bytes(0));           
            }
        }
    }
    function swapExactTokensForTokens(
        uint amountIn,
        uint amountOutMin,
        HopStruct.Hop[] calldata path,
        address to
        //uint deadline
    ) external  /*ensure(deadline) returns (uint[] memory amounts)*/ {
        /*
        There's no need to calculate the amounts out. We can simply make sure the balance is above amountOutMin

        amounts = UniswapV2Library.getAmountsOut(factory, amountIn, path);
        require(amounts[amounts.length - 1] >= amountOutMin, 'UniswapV2Router: INSUFFICIENT_OUTPUT_AMOUNT');
        */
        IUniswapV2Pair pair = IUniswapV2Pair(path[0].pair);
        if(path[0].token0In){
            IERC20Uniswap(pair.token0()).transferFrom(msg.sender, address(pair), amountIn);
        } else {
            IERC20Uniswap(pair.token1()).transferFrom(msg.sender, address(pair), amountIn);
        }
        require(_swap(amountIn, path, to) >= amountOutMin);
    }
    
    function swapTokensForExactTokens(
        uint amountOut,
        uint amountInMax,
        HopStruct.Hop[] calldata path,
        address to
        //uint deadline
    ) external  /*ensure(deadline) returns (uint[] memory amounts)*/ {
        uint amountIn = getAmountsIn(amountOut, path);
        require(amountIn <= amountInMax, 'UniswapV2Router: EXCESSIVE_INPUT_AMOUNT');
        IUniswapV2Pair pair = IUniswapV2Pair(path[0].pair);
        if(path[0].token0In){
            IERC20Uniswap(pair.token0()).transferFrom(msg.sender, address(pair), amountIn);
        } else {
            IERC20Uniswap(pair.token1()).transferFrom(msg.sender, address(pair), amountIn);
        }
        //Make sure we get the amount out we wanted
        require(_swap(amountIn, path, to) == amountOut);
    }


    function quote(uint amountA, uint reserveA, uint reserveB) public pure  returns (uint amountB) {
        return amountA * reserveB / reserveA;
    }

    function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) public pure  returns (uint) {
        uint amountInWithFee = amountIn * 997;
        uint numerator = amountInWithFee * reserveOut;
        uint denominator = reserveIn * 1000 + amountInWithFee;
        return numerator / denominator;
    }

    function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) public pure  returns (uint) {
        uint numerator = reserveIn * amountOut * 1000;
        uint denominator = (reserveOut - amountOut) * 997;
        return numerator / denominator + 1;
    }
    /*
    function getAmountsOut(uint amountIn, address[] memory path) public view  returns (uint[] memory amounts) {
        return UniswapV2Library.getAmountsOut(factory, amountIn, path);
    }
    */

    function getAmountsIn(uint amountOut, HopStruct.Hop[] memory path) public view returns (uint) {
        uint amountIn = amountOut;
        for (uint i = path.length; i > 0; i--) {
            IUniswapV2Pair pair = IUniswapV2Pair(path[i-1].pair);
            (uint reserve0, uint reserve1,) = pair.getReserves();
            amountIn = path[i-1].token0In ? getAmountIn(amountIn, reserve0, reserve1) : getAmountIn(amountIn, reserve1, reserve0);
        }
        return amountIn;
    }
}
