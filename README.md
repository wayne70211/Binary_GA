# Binary GA
This is the optimization program to find the maximum value of 2-D function which based on the genetic algorithm (GA) with binary method.

<!-- wp:paragraph {"align":"center"} -->
<p style="text-align:center">Institute of Aeronautics &amp; Astronautics course in NCKU at May 2018</p>
<!-- /wp:paragraph -->

<!-- wp:heading {"align":"center"} -->
<h2 class="has-text-align-center"><strong>Binary GA</strong></h2>
<!-- /wp:heading -->

<!-- wp:paragraph -->
<p>This is the optimisation program to find the maximum value of 2-D function which used the&nbsp;<strong>genetic algorithm (GA)</strong> with binary method.</p>
<!-- /wp:paragraph -->

<!-- wp:heading {"align":"center"} -->
<h2 class="has-text-align-center"><strong>Algorithm</strong></h2>
<!-- /wp:heading -->

<!-- wp:separator -->
<hr class="wp-block-separator"/>
<!-- /wp:separator -->

<!-- wp:heading {"level":3} -->
<h3><strong>1. Initialise</strong></h3>
<!-- /wp:heading -->

<!-- wp:list -->
<ul><li>Create each parents by random generation of each bit. If the random value is less than 0.5 , the bit value is <strong>0</strong>. Otherwise, the bit value is <strong>1</strong>.</li></ul>
<!-- /wp:list -->

<!-- wp:heading {"level":3} -->
<h3><strong>2. Decode</strong></h3>
<!-- /wp:heading -->

<!-- wp:list -->
<ul><li>Decode all the parents bits (<strong>Gene</strong>) to real value. Notice that it need to mapping by subject value.</li></ul>
<!-- /wp:list -->

<!-- wp:heading {"level":3} -->
<h3><strong>3. Function Evaluation</strong></h3>
<!-- /wp:heading -->

<!-- wp:list -->
<ul><li>Use the decoded real value to calculate the function value (or <strong>fitness value</strong>)</li></ul>
<!-- /wp:list -->

<!-- wp:heading {"level":3} -->
<h3><strong>4. Get Best</strong></h3>
<!-- /wp:heading -->

<!-- wp:list -->
<ul><li>Save the best fitness value and the parents bits&nbsp;<strong>(Gene)</strong></li></ul>
<!-- /wp:list -->

<!-- wp:separator -->
<hr class="wp-block-separator"/>
<!-- /wp:separator -->

<!-- wp:heading {"level":3} -->
<h3><strong>5. RW Selection</strong></h3>
<!-- /wp:heading -->

<!-- wp:list -->
<ul><li>Use the fitness value to rank all the parents bits (<strong>Gene</strong>) and select 2 parents by call random select. <span style="color:#ff0000;">The fitness is larger, the probability to be selected is larger</span>. And the gene with less fitness still has chance to be selected.</li></ul>
<!-- /wp:list -->

<!-- wp:heading {"level":3} -->
<h3><strong>6. Single Point Crossover</strong></h3>
<!-- /wp:heading -->

<!-- wp:list -->
<ul><li>Call a random number, if the value less than the <strong><span style="color:#ff0000;">P_cross</span>&nbsp;</strong>(which between [0,1]) , then do the crossover. The crossover is to cut the selected 2 parent genes and exchange the bit value on the same side from the 2 selected parent genes. The final are the child genes.</li></ul>
<!-- /wp:list -->

<!-- wp:heading {"level":3} -->
<h3><strong>7. Jump Mutation</strong></h3>
<!-- /wp:heading -->

<!-- wp:list -->
<ul><li>Call a random number, if the value less than the <strong><span style="color:#ff0000;">P_mutation</span>&nbsp;</strong>(which between [0,1]) , then do the mutation. The mutation is to changed the child genes bit from 0 to 1 or 1 to 0. Each bit has probability to mutation.</li></ul>
<!-- /wp:list -->

<!-- wp:heading {"level":3} -->
<h3><strong>8. Decode</strong></h3>
<!-- /wp:heading -->

<!-- wp:list -->
<ul><li>Decode all the child bits (<strong>Gene</strong>) to real value</li></ul>
<!-- /wp:list -->

<!-- wp:heading {"level":3} -->
<h3><strong>9. Function Evaluation</strong></h3>
<!-- /wp:heading -->

<!-- wp:list -->
<ul><li>Use the decoded real value to calculate the function value (or <strong>fitness value</strong>)</li></ul>
<!-- /wp:list -->

<!-- wp:heading {"level":3} -->
<h3><strong>10. Get Best</strong></h3>
<!-- /wp:heading -->

<!-- wp:list -->
<ul><li>Save the best fitness value and the child bits&nbsp;<strong>(Gene)</strong></li></ul>
<!-- /wp:list -->

<!-- wp:separator -->
<hr class="wp-block-separator"/>
<!-- /wp:separator -->

<!-- wp:heading {"align":"center","level":4} -->
<h4 class="has-text-align-center"><span style="color:#800080;">Do the loop from Process 5 to 10 when get the best fitness&nbsp;</span></h4>
<!-- /wp:heading -->

<!-- wp:separator -->
<hr class="wp-block-separator"/>
<!-- /wp:separator -->

<!-- wp:heading {"level":3} -->
<h3><strong>11. Elitism</strong></h3>
<!-- /wp:heading -->

<!-- wp:list -->
<ul><li>Compare the best value from each loop and save the best fitness value and gene bits</li></ul>
<!-- /wp:list -->

<!-- wp:heading {"level":3} -->
<h3><strong>12. Creeping</strong></h3>
<!-- /wp:heading -->

<!-- wp:list -->
<ul><li>Finally, let's creep the gene value by used <span style="color:#ff6600;">Elitism gene</span>, try to find larger fitness</li></ul>
<!-- /wp:list -->

<!-- wp:separator -->
<hr class="wp-block-separator"/>
<!-- /wp:separator -->
