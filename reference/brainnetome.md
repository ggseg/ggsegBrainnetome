# Brainnetome Atlas

Brain atlas for the Brainnetome cortical parcellation with 105 regions
per hemisphere. Contains 2D polygon geometry for
[`ggseg::geom_brain()`](https://ggsegverse.github.io/ggseg/reference/ggbrain.html).

## Usage

``` r
brainnetome()
```

## Value

A
[ggseg.formats::ggseg_atlas](https://ggsegverse.github.io/ggseg.formats/reference/ggseg_atlas.html)
object (cortical).

## References

Fan L, Li H, Zhuo J, Zhang Y, Wang J, Chen L, Yang Z, Chu C, Xie S,
Laird AR, Fox PT, Eickhoff SB, Yu C, Jiang T (2016). The Human
Brainnetome Atlas: A New Brain Atlas Based on Connectional Architecture.
*Cerebral Cortex*, 26(8):3508-3526.
[doi:10.1093/cercor/bhw157](https://doi.org/10.1093/cercor/bhw157)

## See also

Other ggseg_atlases:
[`brainnetome_sub()`](https://ggsegverse.github.io/ggsegBrainnetome/reference/brainnetome_sub.md)

## Examples

``` r
brainnetome()
#> 
#> ── brainnetome ggseg atlas ─────────────────────────────────────────────────────
#> Type: cortical
#> Regions: 210
#> Hemispheres: left, right
#> Views: inferior, lateral, superior, medial
#> Palette: ✔
#> Rendering: ✔ ggseg
#> ✔ ggseg3d (vertices)
#> ────────────────────────────────────────────────────────────────────────────────
#>    hemi   region       label
#> 1  left    A8m_L    lh_A8m_L
#> 2  left   A8dl_L   lh_A8dl_L
#> 3  left    A9l_L    lh_A9l_L
#> 4  left   A6dl_L   lh_A6dl_L
#> 5  left    A6m_L    lh_A6m_L
#> 6  left    A9m_L    lh_A9m_L
#> 7  left   A10m_L   lh_A10m_L
#> 8  left A9/46d_L lh_A9-46d_L
#> 9  left    IFJ_L    lh_IFJ_L
#> 10 left    A46_L    lh_A46_L
#> ... with 200 more rows
if (FALSE) plot(brainnetome()) # \dontrun{}
```
