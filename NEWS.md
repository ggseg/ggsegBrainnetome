# ggsegBrainnetome 2.0.5

- Rebuilt the subcortical atlas 2D geometry with per-atlas projection tuning:
  bounding-box-derived slabs (3 coronal + 4 axial) and structure dilation, so
  the 36 fine subcortical parcels render as coherent filled shapes instead of
  scattered slivers. 3D meshes are unchanged.

# ggsegBrainnetome 2.0.4

- Atlas 2D geometry migrated to the sf-optional `brain_polygons` format
  (`ggseg.formats` 0.0.3). The atlases now render without `sf` and its
  GDAL/GEOS/PROJ system libraries, enabling wasm and air-gapped installs.
  Plots are unchanged.

# ggsegBrainnetome 2.0.0

## Breaking changes

- `brainnetome` is now a `ggseg_atlas` object (from ggseg.formats) containing
  2D polygon geometry.

- Atlas recreated from scratch using `ggsegExtra::create_cortical_atlas()` from
  the BN_Atlas annotation on fsaverage5.

- Use `ggplot() + ggseg::geom_brain(atlas = brainnetome)` for 2D plots.

- `ggseg.formats` is now a hard dependency (in Depends).

- Package URLs updated from `LCBC-UiO` to `ggseg` GitHub organisation.
