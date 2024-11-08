testthat::describe("data api logic", {

  testthat::describe("read data from cache", {

    it("read existing data", {
      cache_init()
      load_data("fev_data")
      cache_data(fev_data)
      testthat::expect_equal(
        fev_data,
        read_data("fev_data", use_cache = TRUE)
      )
    })

    it("error on missing data", {
      testthat::expect_error(
        read_data("bcva_data", use_cache = TRUE),
        "bcva_data not in cache"
      )
    })

  })

  testthat::describe("stored data", {
    it("count internal simulated data", {
      testthat::expect_length(list_data(), 2L)
    })

    it("benchmark data",{
      bench_data <- test_data("fev_data")
      testthat::expect_equal(sum(is.na(bench_data$FEV1)), 263L)
    })
  })

})