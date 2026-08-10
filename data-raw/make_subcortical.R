# Create Brainnetome Subcortical Atlas (fsaverage5, grey-brain context)
#
# The Brainnetome subcortical parcels (labels 211-246 of the volumetric atlas)
# ship as a published FSL-MNI152 volume with no anatomical context. To render
# them the way the FreeSurfer subcortical atlases do -- coloured structures
# inside a grey brain silhouette -- we embed them into the fsaverage5 aseg with
# ggseg.extra::prepare_subcortical_mni152(): it registers the MNI152 parcels
# into fs5 aseg space via the fixed mni152.register.dat transform, replaces the
# lumped aseg structures they subdivide, and returns the merged volume plus a
# combined colour table ready for the subcortical pipeline. aseg_context() then
# demotes the surrounding brain to grey.
#
# The 36 parcels cover amygdala, hippocampus, thalamus, caudate, putamen,
# pallidum and nucleus accumbens.
#
# Source: http://atlas.brainnetome.org/download.html (BN_Atlas_246_1mm.nii.gz)
# Reference: Fan L, et al. (2016), Cerebral Cortex 26(8):3508-3526.
#   DOI: 10.1093/cercor/bhw157
#
# Requires: ggseg.extra, ggseg.formats, FreeSurfer 7.4.1 with fsaverage5.
#
# Run with: Rscript data-raw/make_subcortical.R

library(dplyr)
library(ggseg.extra)
library(ggseg.formats)

future::plan(future::sequential)
progressr::handlers("cli")
progressr::handlers(global = TRUE)

data_raw <- here::here("data-raw")
vol_file <- here::here("data-raw", "BN_Atlas_246_1mm.nii.gz")
stopifnot("BN_Atlas_246_1mm.nii.gz not found" = file.exists(vol_file))

# ── Parcel colour table (labels 211-246) ────────────────────────────────
bn_labels <- 211:246
set.seed(42)
parcel_cols <- grDevices::hcl.colors(length(bn_labels), palette = "Set 3")
parcel_rgb <- grDevices::col2rgb(parcel_cols)
parcel_lut <- data.frame(
  idx = bn_labels,
  label = sprintf("region_%04d", bn_labels),
  R = as.integer(parcel_rgb[1, ]),
  G = as.integer(parcel_rgb[2, ]),
  B = as.integer(parcel_rgb[3, ]),
  A = 0L,
  stringsAsFactors = FALSE
)

# ── Embed the parcels in the fsaverage5 aseg (grey-brain context) ────────
cli::cli_h1("Embedding Brainnetome subcortical parcels in fsaverage5 aseg")
merged <- prepare_subcortical_mni152(
  input_volume = vol_file,
  labels = bn_labels,
  lut = parcel_lut
)

# ── Build the atlas: bbox-framed slabs + parcel dilation ─────────────────
subcort_slabs <- subcortical_slabs(
  merged$volume,
  labels = bn_labels,
  coronal = 3,
  axial = 4,
  pad = 2
)

bn_raw <- create_subcortical_from_volume(
  input_volume = merged,
  atlas_name = "brainnetome_sub",
  output_dir = data_raw,
  slabs = subcort_slabs,
  dilate = 2L,
  skip_existing = TRUE,
  cleanup = FALSE
)

# ── Reduce to the parcels on grey anatomical context ────────────────────
# Close first (the morphological buffer adds vertices), then simplify last so
# the final vertex count stays small: the cortex silhouette gets a heavier
# close, then a single simplify pass trims the whole atlas under the
# large-atlas threshold.
brainnetome_sub <- bn_raw |>
  aseg_context(focus = "region_0", match_on = "label") |>
  atlas_view_gather() |>
  atlas_smooth(smoothness = 2, exclude = "^cortex") |>
  atlas_smooth(smoothness = 5, labels = "^cortex") |>
  atlas_smooth(keep = 0.15)

cli::cli_alert_success("brainnetome_sub: {nrow(brainnetome_sub$core)} regions")
print(brainnetome_sub)

# ── Save alongside the cortical atlas ────────────────────────────────────
sysdata_path <- here::here("R/sysdata.rda")
if (file.exists(sysdata_path)) {
  load(sysdata_path)
}
.brainnetome_sub <- brainnetome_sub

usethis::use_data(
  .brainnetome,
  .brainnetome_sub,
  overwrite = TRUE,
  compress = "xz",
  internal = TRUE
)
