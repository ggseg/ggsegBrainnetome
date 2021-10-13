devtools::load_all("../../ggsegExtra/")
devtools::load_all(".")

# Make palette
brain_pals <- make_palette_ggseg(brainnetome_3d)
usethis::use_data(brain_pals, internal = TRUE, overwrite = TRUE)
devtools::load_all(".")

# fix atlas
brainnetome_n <- brainnetome
brainnetome_n <- unnest(brainnetome_n, ggseg)
brainnetome_n <- group_by(brainnetome_n, label, hemi,  side, region, .id)
brainnetome_n <- nest(brainnetome_n)
brainnetome_n <- group_by(brainnetome_n, hemi,  side, region)
brainnetome_n <- mutate(brainnetome_n, .subid = row_number())
brainnetome_n <- unnest(brainnetome_n, data)
brainnetome_n <- ungroup(brainnetome_n)
brainnetome_n <- mutate(brainnetome_n,
                region = as.character(region),
                region = gsub("angular bundle", "hippocampus", region),
                region = ifelse(grepl("fluid", region), NA, region))
brainnetome_n <- as_ggseg_atlas(brainnetome_n)

brainnetome_n %>%
  ggseg(atlas = ., show.legend = TRUE,
        colour = "black",
        mapping = aes(fill=region)) +
  scale_fill_brain("brainnetome", package = "ggsegBrainnetome", na.value = "black")


brainnetome <- brainnetome_n
usethis::use_data(brainnetome,
                  internal = FALSE,
                  overwrite = TRUE,
                  compress="xz")
