
<!-- README.md is generated from README.Rmd. Please edit that file -->

``` mermaid
graph LR
  style Legend fill:#FFFFFF00,stroke:#000000;
  style Graph fill:#FFFFFF00,stroke:#000000;
  subgraph Legend
    direction LR
    x7420bd9270f8d27d([""Up to date""]):::uptodate --- xbf4603d6c2c2ad6b([""Stem""]):::none
  end
  subgraph Graph
    direction LR
    xba581ff8ec20748f(["bcva_tbl_missing"]):::uptodate --> x1d2bdffc623bf54f(["bcva_data"]):::uptodate
    xff50554f3d0eb3a9(["bcva_covars_tbl"]):::uptodate --> xeee7b39e65da373f(["bcva_tbl"]):::uptodate
    xdf79c40940b53ca5(["bcva_outcomes"]):::uptodate --> xeee7b39e65da373f(["bcva_tbl"]):::uptodate
    xff50554f3d0eb3a9(["bcva_covars_tbl"]):::uptodate --> xdf79c40940b53ca5(["bcva_outcomes"]):::uptodate
    x56b0170cd836b5f5(["bcva_outcome_covar_mat"]):::uptodate --> xdf79c40940b53ca5(["bcva_outcomes"]):::uptodate
    x5c1f6932edbdc566(["bcva_scenario"]):::uptodate --> xdf79c40940b53ca5(["bcva_outcomes"]):::uptodate
    x5c1f6932edbdc566(["bcva_scenario"]):::uptodate --> xba581ff8ec20748f(["bcva_tbl_missing"]):::uptodate
    xeee7b39e65da373f(["bcva_tbl"]):::uptodate --> xba581ff8ec20748f(["bcva_tbl_missing"]):::uptodate
    x56b0170cd836b5f5(["bcva_outcome_covar_mat"]):::uptodate --> xff50554f3d0eb3a9(["bcva_covars_tbl"]):::uptodate
    x5c1f6932edbdc566(["bcva_scenario"]):::uptodate --> xff50554f3d0eb3a9(["bcva_covars_tbl"]):::uptodate
    x1d2bdffc623bf54f(["bcva_data"]):::uptodate --> x8affe731b708cae5(["bcva_deploy"]):::uptodate
  end
  classDef uptodate stroke:#000000,color:#ffffff,fill:#354823;
  classDef none stroke:#000000,color:#000000,fill:#94a4ac;
  linkStyle 0 stroke-width:0px;
```
