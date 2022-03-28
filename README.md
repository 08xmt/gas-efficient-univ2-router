# gas-efficient-univ2-router
## Foundry Gas Report
We see a: 
- 5.4% Gas reduction for adding liquidity
- 0.7% Gas reduction for removing liquidity
- 8.6% Gas reduction for swapping exact tokens
- 3.7% Gas reduction for swapping for exact tokens
<pre>╭─────────────────────────────┬─────────────────┬────────┬────────┬────────┬─────────╮
│<font color="#8AE234"><b> GasEfficientRouter contract </b></font>┆                 ┆        ┆        ┆        ┆         │
╞═════════════════════════════╪═════════════════╪════════╪════════╪════════╪═════════╡
│<font color="#34E2E2"><b> Deployment Cost             </b></font>┆<font color="#34E2E2"><b> Deployment Size </b></font>┆        ┆        ┆        ┆         │
├╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌┼╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌┼╌╌╌╌╌╌╌╌┼╌╌╌╌╌╌╌╌┼╌╌╌╌╌╌╌╌┼╌╌╌╌╌╌╌╌╌┤
│ 1140787                     ┆ 5730            ┆        ┆        ┆        ┆         │
├╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌┼╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌┼╌╌╌╌╌╌╌╌┼╌╌╌╌╌╌╌╌┼╌╌╌╌╌╌╌╌┼╌╌╌╌╌╌╌╌╌┤
│<font color="#AD7FA8"><b> Function Name               </b></font>┆<font color="#8AE234"><b> min             </b></font>┆<font color="#FCE94F"><b> avg    </b></font>┆<font color="#FCE94F"><b> median </b></font>┆<font color="#EF2929"><b> max    </b></font>┆<b> # calls </b>│
├╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌┼╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌┼╌╌╌╌╌╌╌╌┼╌╌╌╌╌╌╌╌┼╌╌╌╌╌╌╌╌┼╌╌╌╌╌╌╌╌╌┤
│<b> addLiquidity                </b>┆<font color="#8AE234"> 88264           </font>┆<font color="#FCE94F"> 132379 </font>┆<font color="#FCE94F"> 154437 </font>┆<font color="#EF2929"> 154437 </font>┆ 6       │
├╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌┼╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌┼╌╌╌╌╌╌╌╌┼╌╌╌╌╌╌╌╌┼╌╌╌╌╌╌╌╌┼╌╌╌╌╌╌╌╌╌┤
│<b> removeLiquidity             </b>┆<font color="#8AE234"> 56653           </font>┆<font color="#FCE94F"> 56653  </font>┆<font color="#FCE94F"> 56653  </font>┆<font color="#EF2929"> 56653  </font>┆ 1       │
├╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌┼╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌┼╌╌╌╌╌╌╌╌┼╌╌╌╌╌╌╌╌┼╌╌╌╌╌╌╌╌┼╌╌╌╌╌╌╌╌╌┤
│<b> swapExactTokensForTokens    </b>┆<font color="#8AE234"> 57487           </font>┆<font color="#FCE94F"> 57487  </font>┆<font color="#FCE94F"> 57487  </font>┆<font color="#EF2929"> 57487  </font>┆ 1       │
├╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌┼╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌┼╌╌╌╌╌╌╌╌┼╌╌╌╌╌╌╌╌┼╌╌╌╌╌╌╌╌┼╌╌╌╌╌╌╌╌╌┤
│<b> swapTokensForExactTokens    </b>┆<font color="#8AE234"> 59375           </font>┆<font color="#FCE94F"> 59375  </font>┆<font color="#FCE94F"> 59375  </font>┆<font color="#EF2929"> 59375  </font>┆ 1       │
╰─────────────────────────────┴─────────────────┴────────┴────────┴────────┴─────────╯
╭────────────────────────────┬─────────────────┬─────────┬─────────┬─────────┬─────────╮
│<font color="#8AE234"><b> UniswapV2Router02 contract </b></font>┆                 ┆         ┆         ┆         ┆         │
╞════════════════════════════╪═════════════════╪═════════╪═════════╪═════════╪═════════╡
│<font color="#34E2E2"><b> Deployment Cost            </b></font>┆<font color="#34E2E2"><b> Deployment Size </b></font>┆         ┆         ┆         ┆         │
├╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌┼╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌┼╌╌╌╌╌╌╌╌╌┼╌╌╌╌╌╌╌╌╌┼╌╌╌╌╌╌╌╌╌┼╌╌╌╌╌╌╌╌╌┤
│ 3557057                    ┆ 18215           ┆         ┆         ┆         ┆         │
├╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌┼╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌┼╌╌╌╌╌╌╌╌╌┼╌╌╌╌╌╌╌╌╌┼╌╌╌╌╌╌╌╌╌┼╌╌╌╌╌╌╌╌╌┤
│<font color="#AD7FA8"><b> Function Name              </b></font>┆<font color="#8AE234"><b> min             </b></font>┆<font color="#FCE94F"><b> avg     </b></font>┆<font color="#FCE94F"><b> median  </b></font>┆<font color="#EF2929"><b> max     </b></font>┆<b> # calls </b>│
├╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌┼╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌┼╌╌╌╌╌╌╌╌╌┼╌╌╌╌╌╌╌╌╌┼╌╌╌╌╌╌╌╌╌┼╌╌╌╌╌╌╌╌╌┤
│<b> addLiquidity               </b>┆<font color="#8AE234"> 94237           </font>┆<font color="#FCE94F"> 1508808 </font>┆<font color="#FCE94F"> 2216094 </font>┆<font color="#EF2929"> 2216094 </font>┆ 6       │
├╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌┼╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌┼╌╌╌╌╌╌╌╌╌┼╌╌╌╌╌╌╌╌╌┼╌╌╌╌╌╌╌╌╌┼╌╌╌╌╌╌╌╌╌┤
│<b> removeLiquidity            </b>┆<font color="#8AE234"> 57034           </font>┆<font color="#FCE94F"> 57034   </font>┆<font color="#FCE94F"> 57034   </font>┆<font color="#EF2929"> 57034   </font>┆ 1       │
├╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌┼╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌┼╌╌╌╌╌╌╌╌╌┼╌╌╌╌╌╌╌╌╌┼╌╌╌╌╌╌╌╌╌┼╌╌╌╌╌╌╌╌╌┤
│<b> swapExactTokensForTokens   </b>┆<font color="#8AE234"> 64592           </font>┆<font color="#FCE94F"> 64592   </font>┆<font color="#FCE94F"> 64592   </font>┆<font color="#EF2929"> 64592   </font>┆ 1       │
├╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌┼╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌┼╌╌╌╌╌╌╌╌╌┼╌╌╌╌╌╌╌╌╌┼╌╌╌╌╌╌╌╌╌┼╌╌╌╌╌╌╌╌╌┤
│<b> swapTokensForExactTokens   </b>┆<font color="#8AE234"> 64544           </font>┆<font color="#FCE94F"> 64544   </font>┆<font color="#FCE94F"> 64544   </font>┆<font color="#EF2929"> 64544   </font>┆ 1       │
╰────────────────────────────┴─────────────────┴─────────┴─────────┴─────────┴─────────╯
</pre>
