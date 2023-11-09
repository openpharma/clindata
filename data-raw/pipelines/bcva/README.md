
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
    xd43dfdb5801bc879(["outcome_covar_mat"]):::uptodate --> x4c7a5e98fa3b78c2(["covars_tbl"]):::uptodate
    x9c9d5e52f9f1598c(["scenario"]):::uptodate --> x4c7a5e98fa3b78c2(["covars_tbl"]):::uptodate
    x93f0351b56007198(["bcva_tbl_mising"]):::uptodate --> x1d2bdffc623bf54f(["bcva_data"]):::uptodate
    xdf79c40940b53ca5(["bcva_outcomes"]):::uptodate --> xeee7b39e65da373f(["bcva_tbl"]):::uptodate
    x4c7a5e98fa3b78c2(["covars_tbl"]):::uptodate --> xeee7b39e65da373f(["bcva_tbl"]):::uptodate
    xeee7b39e65da373f(["bcva_tbl"]):::uptodate --> x93f0351b56007198(["bcva_tbl_mising"]):::uptodate
    x9c9d5e52f9f1598c(["scenario"]):::uptodate --> x93f0351b56007198(["bcva_tbl_mising"]):::uptodate
    x4c7a5e98fa3b78c2(["covars_tbl"]):::uptodate --> xdf79c40940b53ca5(["bcva_outcomes"]):::uptodate
    xd43dfdb5801bc879(["outcome_covar_mat"]):::uptodate --> xdf79c40940b53ca5(["bcva_outcomes"]):::uptodate
    x9c9d5e52f9f1598c(["scenario"]):::uptodate --> xdf79c40940b53ca5(["bcva_outcomes"]):::uptodate
    x1d2bdffc623bf54f(["bcva_data"]):::uptodate --> x8affe731b708cae5(["bcva_deploy"]):::uptodate
  end
  classDef uptodate stroke:#000000,color:#ffffff,fill:#354823;
  classDef none stroke:#000000,color:#000000,fill:#94a4ac;
  linkStyle 0 stroke-width:0px;
```
