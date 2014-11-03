Inference on von Mises orientation maps
====


For a thorough guide to the theoretical background, see [pdf/theory.pdf](pdf/theory.pdf?raw=true).


Low rank models
----

So called low rank models, described in [Smith\_2012](http://bit.ly/1GcKKEW), are continuous joint distributions `p(X)` whose pairwise marginals `p(x_t,x_{t+1})` and conditionals `p(x_{t+1}|x_t)` can be expressed in terms of discrete random variables `Z` coupling the adjacent components; e.g. `z_t` couples `x_t` and `x_{t+1}`. Sampling, computation of moments, and smoothing of observations in these models are as efficient as in discrete Markov chains, provided that certain intermediate integrals can be computed.


Orientation maps
----

With one particular class of such models we may exploit the self-conjugacy of the von Mises distribution on the circle, to efficiently treat angular variables and data. For example, [Smith\_2012](http://bit.ly/1GcKKEW) use this kind of smoother to estimate joint angle movement from motion capture data. Other examples are imaginable, even in higher dimensions with a generalized form of the von Mises. In this material I'm describing and experimenting on a loopy low rank von Mises model to sample and estimate orientation maps like those found in primary visual cortex. 

