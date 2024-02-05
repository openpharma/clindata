testthat::describe("caching logic", {

  testthat::describe("caching initialization", {
    it("initialize cache default", {
      cache_init()
      testthat::expect_true(
        dir.exists(cache_dir())
      )
      cache_destroy(verbose = FALSE)
    })

    it("initialize cache system variable", {
      tf <- file.path(tempdir(), "clindata")
      Sys.setenv(CLINDATA_CACHE_DIR = tf)
      cache_init()
      testthat::expect_true(
        dir.exists(tf)
      )
      cache_destroy(verbose = FALSE)
    })

    it("initialize cache user path", {
      tf <- file.path(tempdir(), "clindata")
      cache_init(path = tf)
      testthat::expect_true(
        dir.exists(tf)
      )
      cache_destroy(tf, verbose = FALSE)
    })

  })

  testthat::describe("add data to cache", {
    it("add data from package", {
      cache_init()
      load_data("fev_data")
      cache_data("fev_data")
      testthat::expect_true(
        file.exists(file.path(cache_dir(), "fev_data.rds"))
      )
    })
  })

})