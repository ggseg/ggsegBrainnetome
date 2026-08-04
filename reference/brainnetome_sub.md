# Brainnetome Subcortical Atlas

Brain atlas for the Brainnetome subcortical parcellation with 36
subregions covering amygdala, hippocampus, thalamus, caudate, putamen,
pallidum, and nucleus accumbens.

## Usage

``` r
brainnetome_sub()
```

## Value

A
[ggseg.formats::ggseg_atlas](https://ggsegverse.github.io/ggseg.formats/reference/ggseg_atlas.html)
object (subcortical).

## References

Fan L, Li H, Zhuo J, Zhang Y, Wang J, Chen L, Yang Z, Chu C, Xie S,
Laird AR, Fox PT, Eickhoff SB, Yu C, Jiang T (2016). The Human
Brainnetome Atlas: A New Brain Atlas Based on Connectional Architecture.
*Cerebral Cortex*, 26(8):3508-3526.
[doi:10.1093/cercor/bhw157](https://doi.org/10.1093/cercor/bhw157)

## See also

Other ggseg_atlases:
[`brainnetome()`](https://ggsegverse.github.io/ggsegBrainnetome/reference/brainnetome.md)

## Examples

``` r
brainnetome_sub()
#> 
#> ── brainnetome_sub ggseg atlas ─────────────────────────────────────────────────
#> Type: subcortical
#> Regions: 36
#> Hemispheres: NA
#> Views: axial_1, axial_2, coronal_2, coronal_3, coronal_4, axial_3, coronal_1,
#> axial_4, sagittal, axial_5
#> Palette: ✔
#> Rendering: ✔ ggseg
#> ✔ ggseg3d (meshes)
#> ────────────────────────────────────────────────────────────────────────────────
#>    hemi      region       label
#> 1  <NA> region 0211 region_0211
#> 2  <NA> region 0212 region_0212
#> 3  <NA> region 0213 region_0213
#> 4  <NA> region 0214 region_0214
#> 5  <NA> region 0215 region_0215
#> 6  <NA> region 0216 region_0216
#> 7  <NA> region 0217 region_0217
#> 8  <NA> region 0218 region_0218
#> 9  <NA> region 0219 region_0219
#> 10 <NA> region 0220 region_0220
#> ... with 26 more rows
if (FALSE) plot(brainnetome_sub()) # \dontrun{}
```
