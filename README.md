hclustext
============


[![Project Status: Active - The project has reached a stable, usable
state and is being actively
developed.](http://www.repostatus.org/badges/latest/active.svg)](http://www.repostatus.org/#active)
[![Build
Status](https://travis-ci.org/trinker/hclustext.svg?branch=master)](https://travis-ci.org/trinker/hclustext)
[![Coverage
Status](https://coveralls.io/repos/trinker/hclustext/badge.svg?branch=master)](https://coveralls.io/r/trinker/hclustext?branch=master)
<a href="https://img.shields.io/badge/Version-0.0.1-orange.svg"><img src="https://img.shields.io/badge/Version-0.0.1-orange.svg" alt="Version"/></a>
</p>
<img src="inst/hclustext_logo/r_hclustext.png" width="150" alt="readability Logo">

**hclustext** is a collection of optimized tools for clustering text
data via hierarchical clustering.


Table of Contents
============

-   [[Function Usage](#function-usage)](#[function-usage](#function-usage))
-   [[Installation](#installation)](#[installation](#installation))
-   [[Contact](#contact)](#[contact](#contact))

Function Usage
============


The main functions, task category, & descriptions are summarized in the
table below:

<table style="width:160%;">
<colgroup>
<col width="34%" />
<col width="23%" />
<col width="101%" />
</colgroup>
<thead>
<tr class="header">
<th align="left">Function</th>
<th align="left">Category</th>
<th align="left">Description</th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td align="left"><code>data_store</code></td>
<td align="left">data structure</td>
<td align="left"><strong>hclustext</strong>'s data structure (list of dtm + text)</td>
</tr>
<tr class="even">
<td align="left"><code>hierarchical_cluster</code></td>
<td align="left">cluster fit</td>
<td align="left">Fits a hierarchical cluster model</td>
</tr>
<tr class="odd">
<td align="left"><code>assign_cluster</code></td>
<td align="left">assignment</td>
<td align="left">Assigns cluster to document/text element</td>
</tr>
<tr class="even">
<td align="left"><code>get_text</code></td>
<td align="left">extraction</td>
<td align="left">Get text from various <strong>hclustext</strong> objects</td>
</tr>
<tr class="odd">
<td align="left"><code>get_dtm</code></td>
<td align="left">extraction</td>
<td align="left">Get <code>tm::DocumentTermMatrix</code> from various <strong>hclustext</strong> objects</td>
</tr>
<tr class="even">
<td align="left"><code>get_removed</code></td>
<td align="left">extraction</td>
<td align="left">Get removed text elements from various <strong>hclustext</strong> objects</td>
</tr>
</tbody>
</table>

Installation
============

To download the development version of **hclustext**:

Download the [zip
ball](https://github.com/trinker/hclustext/zipball/master) or [tar
ball](https://github.com/trinker/hclustext/tarball/master), decompress
and run `R CMD INSTALL` on it, or use the **pacman** package to install
the development version:

    if (!require("pacman")) install.packages("pacman")
    pacman::p_load_gh("trinker/hclustext")

Contact
=======

You are welcome to:   - submit suggestions and bug-reports at: <https://github.com/trinker/hclustext/issues>   - send a pull request on: <https://github.com/trinker/hclustext/>  

- compose a friendly e-mail to: <tyler.rinker@gmail.com>