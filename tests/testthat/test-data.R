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
  })

  it("is valid", {
    expect_true(ggseg.formats::is_ggseg_atlas(brainnetome_sub()))
  })

  it("renders with ggseg", {
    p <- ggplot2::ggplot() +
      ggseg::geom_brain(
        atlas = brainnetome_sub(),
        mapping = ggplot2::aes(fill = label),
        show.legend = FALSE
      ) +
      ggplot2::theme_void()
    vdiffr::expect_doppelganger("brainnetome_sub-2d", p)
  })
})
