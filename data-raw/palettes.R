library(ggsegExtra)
devtools::load_all("../ggsegExtra/")
library(ggseg)
library(ggseg3d)
library(tidyverse) # for cleaning the atlas data efficiently
devtools::load_all(".")


# convert DKT to fsaverage5
mri_surf2surf_rereg(subject = "fsaverage",
                    annot = "BN_Atlas",
                    hemi = "lh",
                    output_dir = here::here("data-raw/fsaverage5/"))

mri_surf2surf_rereg(subject = "fsaverage",
                    annot = "BN_Atlas",
                    hemi = "rh",
                    output_dir = here::here("data-raw/fsaverage5/"))


# Make  3d ----
brainnetome_3d <- make_aparc_2_3datlas(annot = "BN_Atlas",
                               output_dir = here::here("data-raw/"))
ggseg3d(atlas  = brainnetome_3d)

# fix atlas
brainnetome_n <- brainnetome_3d
brainnetome_n <- unnest(brainnetome_n, ggseg_3d)
brainnetome_n <- mutate(brainnetome_n,
                        region = gsub("_L$|_R$", "", region),
                        region = ifelse(grepl("Unknown", region), NA, region),
                        atlas = "brainnetome_3d"
)
brainnetome_3d <- as_ggseg3d_atlas(brainnetome_n)
ggseg3d(atlas  = brainnetome_3d)


# Make palette
brain_pals <- make_palette_ggseg(brainnetome_3d)
usethis::use_data(brain_pals, internal = TRUE, overwrite = TRUE)
devtools::load_all(".")


brainnetome <- make_ggseg3d_2_ggseg(brainnetome_3d, output_dir = here::here("data-raw/"))

plot(brainnetome)

brainnetome %>%
  ggseg(atlas = ., show.legend = TRUE,
        colour = "black",
        mapping = aes(fill=region)) +
  scale_fill_brain("brainnetome", package = "ggsegBrainnetome", na.value = "black")


usethis::use_data(brainnetome, brainnetome_3d,
                  internal = FALSE,
                  overwrite = TRUE,
                  compress="xz")


# make hex ----
atlas <- brainnetome

p <- ggseg(atlas = atlas,
           hemi = "left",
           view = "lateral",
           show.legend = FALSE,
           colour = "grey30",
           size = .2,
           mapping = aes(fill =  region)) +
  scale_fill_brain2(palette = atlas$palette) +
  theme_void() +
  hexSticker::theme_transparent()

hexSticker::sticker(p,
        package = "ggsegBrainnetome",
        filename="man/figures/logo.svg",
        s_y = 1.2,
        s_x = 1,
        s_width = 1.5,
        s_height = 1.5,
        p_family = "mono",
        p_size = 10,
        p_color = "grey30",
        p_y = .6,
        h_fill = "white",
        h_color = "grey30"
)

hexSticker::sticker(p,
        package = "ggsegBrainnetome",
        filename="man/figures/logo.png",
        s_y = 1.2,
        s_x = 1,
        s_width = 1.5,
        s_height = 1.5,
        p_family = "mono",
        p_size = 10,
        p_color = "grey30",
        p_y = .6,
        h_fill = "white",
        h_color = "grey30"
)

pkgdown::build_favicons(overwrite = TRUE)
