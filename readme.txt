This directory contains programs to parse the nhx format file, and then draw the phylogeny tree, the exon and intron structure, as well as function text in a integrated figure, which were invoked in the FGF (Fishing Gene Family) package.

The main codes are in the Tree directory, which are organized in class and object style.  nhx is the basic class to parse the nhx format,  nhx_svg inherited from nhx to draw phylogeny tree in SVG, nhx_align_svg inherited from nhx_svg to add the exon and intron structure in the SVG figure, and the final nhx_align_func_svg  inherited from nhx_align_svg to add the function text in the SVG figure.   Note that nhx_align_func_svg is the class that invoked in FGF package.

Each class under the Tree directory can be used independantly, and tree_plot.pl is a program to draw phylogeny tree for a given input nhx format file, which invoked class nhx_svg.

Reference paper:
Hongkun Zheng, Junjie Shi, Xiaodong Fang, Yuan Li, S?ren Vang, Wei Fan, Junyi Wang, et al. FGF: A web tool for Fishing Gene Family in a whole genome database. Nucleic Acids Research, Vol. 35, W121-W125 (2007)
