NEWS
====

Versioning
----------

Releases will be numbered with the following semantic versioning format:

&lt;major&gt;.&lt;minor&gt;.&lt;patch&gt;

And constructed with the following guidelines:

* Breaking backward compatibility bumps the major (and resets the minor
  and patch)
* New additions without breaking backward compatibility bumps the minor
  (and resets the patch)
* Bug fixes and misc changes bumps the patch


hclustext 0.1.0-
----------------------------------------------------------------

**BUG FIXES**

* `get_dtm` for `data_store` and `hierarchical_cluster` were reversed (code vs.
  documentation).

**NEW FEATURES**

* `assign_cluster` picks up a `join` attribute to allow for easy merging back to 
  the original data set.  `join` is a function (a closure) that captures 
  information about the `assign_cluster` that makes rejoining simple, requiring
  only the original data set.

**MINOR FEATURES**

**IMPROVEMENTS**

**CHANGES**



hclustext 0.0.1
----------------------------------------------------------------

This package is a collection of optimized tools for clustering text data via hierarchical clustering.