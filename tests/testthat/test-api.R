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
      Sys.setenv(CLINDATA_CACHE_DIR = "")
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
      cache_destroy(verbose = FALSE)
    })

    it("add data from environment", {
      tbl <- data.frame(x = seq(10))
      cache_data("tbl")
      testthat::expect_equal(cache_ls(), "tbl.rds")
    })
  })

  testthat::describe("remove data from cache", {
    it("remove data from cache", {
      tbl2 <- data.frame(x = seq(20))
      cache_data("tbl2")
      cache_rm()
      testthat::expect_true(
        length(cache_ls()) == 0
      )
    })

    it("verbose message on destroy", {
      testthat::expect_message(
        cache_destroy(),
        sprintf("%s directory removed", cache_dir())
      )
    })

  })

})