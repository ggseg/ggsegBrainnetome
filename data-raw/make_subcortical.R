# Create Brainnetome Subcortical Atlas (fsaverage5, grey-brain context)
#
# The Brainnetome subcortical parcels (labels 211-246 of the volumetric atlas)
# ship as a published MNI152 volume with no anatomical context. To render them
# the way the FreeSurfer subcortical atlases do -- coloured structures inside a
# grey brain silhouette -- we register the MNI152 volume into fsaverage5 aseg
# space, stamp the parcels into the full aseg (replacing the lumped subcortical
# labels they subdivide), and hand the combined volume to the pipeline with
# aseg_context() demoting the surrounding brain to grey.
#
# The 36 parcels cover amygdala, hippocampus, thalamus, caudate, putamen,
# pallidum and nucleus accumbens.
#
# Source: http://atlas.brainnetome.org/download.html (BN_Atlas_246_1mm.nii.gz)
# Reference: Fan L, et al. (2016), Cerebral Cortex 26(8):3508-3526.
#   DOI: 10.1093/cercor/bhw157
#
# Requires: ggseg.extra, ggseg.formats, FreeSurfer 7.4.1 (mri_vol2vol,
#   tessellation) with fsaverage5.
#
# Run with: Rscript data-raw/make_subcortical.R

library(dplyr)
library(ggseg.extra)
library(ggseg.formats)

future::plan(future::sequential)
progressr::handlers("cli")
progressr::handlers(global = TRUE)

data_raw <- here::here("data-raw")
fs_home <- Sys.getenv("FREESURFER_HOME", "/Applications/freesurfer/7.4.1")
fs5_aseg <- file.path(fs_home, "subjects/fsaverage5/mri/aseg.mgz")
mni_reg <- file.path(fs_home, "average/mni152.register.dat")
lut_file <- file.path(fs_home, "FreeSurferColorLUT.txt")

vol_file <- here::here("data-raw", "BN_Atlas_246_1mm.nii.gz")
sub_vol_file <- here::here("data-raw", "BN_Atlas_subcortical_1mm.nii.gz")
bn_fs5 <- here::here("data-raw", "BN_sub_fs5.mgz")
seg_file <- here::here("data-raw", "BN_sub_fs5_embedded.nii.gz")

stopifnot(
  "BN_Atlas_246_1mm.nii.gz not found" = file.exists(vol_file),
  "fsaverage5 aseg.mgz not found" = file.exists(fs5_aseg),
  "mni152.register.dat not found" = file.exists(mni_reg),
  "FreeSurferColorLUT.txt not found" = file.exists(lut_file)
)

fs <- function(...) {
  system2(
    file.path(fs_home, "bin", ..1),
    c(...)[-1],
    stdout = FALSE,
    stderr = FALSE
  )
}

# ── 1. Extract the subcortical parcels (labels 211-246) ─────────────────
if (!file.exists(sub_vol_file)) {
  cli::cli_alert_info("Extracting subcortical labels (211-246)")
  vol <- RNifti::readNifti(vol_file)
  vol[vol <= 210] <- 0L
  RNifti::writeNifti(vol, sub_vol_file)
}

# ── 2. Register the MNI152 parcels into fsaverage5 aseg space ────────────
# The Brainnetome atlas ships in FSL MNI152 1mm space (182x218x182);
# FreeSurfer's mni152.register.dat maps that template to fsaverage/MNI305, so a
# single nearest-neighbour vol2vol lands the labels on the fs5 aseg grid.
if (!file.exists(bn_fs5)) {
  cli::cli_alert_info("Registering parcels: MNI152 -> fsaverage5")
  fs(
    "mri_vol2vol",
    "--mov",
    sub_vol_file,
    "--targ",
    fs5_aseg,
    "--reg",
    mni_reg,
    "--o",
    bn_fs5,
    "--nearest"
  )
}

# ── 3. Embed the parcels in the fsaverage5 aseg ─────────────────────────
# Replace the lumped aseg structures the parcels subdivide (thalamus, caudate,
# putamen, pallidum, hippocampus, amygdala, accumbens; L/R) with the parcels,
# keeping cortex, white matter, cerebellum, brainstem, ventral DC and
# ventricles as context. Brainnetome ids (211-246) never collide with aseg ids.
if (!file.exists(seg_file)) {
  cli::cli_alert_info("Embedding parcels in the fsaverage5 aseg")
  aseg_nii <- file.path(tempdir(), "fs5_aseg.nii.gz")
  fs("mri_convert", "-ot", "nii", fs5_aseg, aseg_nii)
  bn_nii <- file.path(tempdir(), "bn_fs5.nii.gz")
  fs("mri_convert", "-ot", "nii", bn_fs5, bn_nii)

  aseg <- RNifti::readNifti(aseg_nii)
  bn <- RNifti::readNifti(bn_nii)
  out <- as.integer(round(aseg))
  dim(out) <- dim(aseg)
  replaced <- c(10, 49, 11, 50, 12, 51, 13, 52, 17, 53, 18, 54, 26, 58)
  out[out %in% replaced] <- 0L
  bn_i <- as.integer(round(bn))
  mask <- bn_i > 0L
  out[mask] <- bn_i[mask]
  RNifti::writeNifti(out, seg_file, template = aseg_nii, datatype = "int32")
}

# ── 4. Combined LUT: aseg context names/colours + parcel entries ────────
parse_fs_lut <- function(path) {
  lines <- trimws(readLines(path, warn = FALSE))
  lines <- lines[nzchar(lines) & !startsWith(lines, "#")]
  parts <- strsplit(lines, "[[:space:]]+")
  parts <- parts[lengths(parts) >= 5]
  data.frame(
    idx = as.integer(vapply(parts, `[`, "", 1)),
    label = vapply(parts, `[`, "", 2),
    R = as.integer(vapply(parts, `[`, "", 3)),
    G = as.integer(vapply(parts, `[`, "", 4)),
    B = as.integer(vapply(parts, `[`, "", 5)),
    A = 0L,
    stringsAsFactors = FALSE
  )
}

embedded <- as.integer(round(RNifti::readNifti(seg_file)))
present <- sort(setdiff(unique(embedded), 0))
bn_labels <- present[present >= 211L & present <= 246L]
ctx_labels <- present[present < 211L]

std_lut <- parse_fs_lut(lut_file)
std_lut <- std_lut[std_lut$idx %in% ctx_labels, ]

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
combined_lut <- rbind(std_lut, parcel_lut)

# ── 5. Build the atlas: bbox-framed slabs + parcel dilation ─────────────
cli::cli_h1("Creating brainnetome subcortical atlas with context")

subcort_slabs <- subcortical_slabs(
  seg_file,
  labels = bn_labels,
  coronal = 3,
  axial = 4,
  pad = 2
)

bn_raw <- create_subcortical_from_volume(
  input_volume = seg_file,
  input_lut = combined_lut,
  atlas_name = "brainnetome_sub",
  output_dir = data_raw,
  slabs = subcort_slabs,
  dilate = 2L,
  skip_existing = TRUE,
  cleanup = FALSE
)

# ── 6. Reduce to the parcels on grey anatomical context ─────────────────
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

# ── 7. Save alongside the cortical atlas ────────────────────────────────
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
