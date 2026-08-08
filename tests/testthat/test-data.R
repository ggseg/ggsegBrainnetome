describe("brainnetome atlas", {
  it("is a ggseg_atlas", {
    expect_s3_class(brainnetome(), "ggseg_atlas")
    expect_s3_class(brainnetome(), "cortical_atlas")
  })

  it("is valid", {
    expect_true(ggseg.formats::is_ggseg_atlas(brainnetome()))
  })

  it("renders with ggseg", {
    vdiffr::expect_doppelganger(
      "brainnetome-2d",
      ggseg::brain_test_plot(brainnetome())
    )
  })
})

describe("brainnetome_sub atlas", {
  it("is a ggseg_atlas", {
    expect_s3_class(brainnetome_sub(), "ggseg_atlas")
    expect_s3_class(brainnetome_sub(), "subcortical_atlas")
  })

  it("is valid", {
    expect_true(ggseg.formats::is_ggseg_atlas(brainnetome_sub()))
  })

  it("has brain_polygons 2D geometry", {
    expect_true(ggseg.formats::is_atlas_polygon(brainnetome_sub()))
  })

  it("has a named palette", {
    pal <- ggseg.formats::atlas_palette(brainnetome_sub())
    expect_type(pal, "character")
    expect_named(pal)
  })

  it("exposes meshes via atlas_meshes", {
    meshes <- ggseg.formats::atlas_meshes(brainnetome_sub())
    expect_s3_class(meshes, "ggseg_meshes")
  })

  it("renders with ggseg", {
    skip_if_not_installed("ggseg")
    p <- ggplot2::ggplot() +
      ggseg::geom_brain(
        atlas = brainnetome_sub(),
        mapping = ggplot2::aes(fill = label),
        show.legend = FALSE
      ) +
      ggplot2::theme_void()
    expect_s3_class(p, "ggplot")
  })
})
