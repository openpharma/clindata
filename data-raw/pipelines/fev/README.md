
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
    x409d546b87b4d201(["fev_covars_tbl"]):::uptodate --> x203a9f3747753c63(["fev_tbl"]):::uptodate
    x406fd8fbbe8f7323(["fev_outcomes"]):::uptodate --> x203a9f3747753c63(["fev_tbl"]):::uptodate
    x409d546b87b4d201(["fev_covars_tbl"]):::uptodate --> x406fd8fbbe8f7323(["fev_outcomes"]):::uptodate
    xaa978ee742b5fc7b(["fev_outcome_covar_mat"]):::uptodate --> x406fd8fbbe8f7323(["fev_outcomes"]):::uptodate
    xc8496217a2afd247(["fev_scenario"]):::uptodate --> x406fd8fbbe8f7323(["fev_outcomes"]):::uptodate
    xc8496217a2afd247(["fev_scenario"]):::uptodate --> x6d5c8319ce1721c9(["fev_data"]):::uptodate
    x203a9f3747753c63(["fev_tbl"]):::uptodate --> x6d5c8319ce1721c9(["fev_data"]):::uptodate
    xaa978ee742b5fc7b(["fev_outcome_covar_mat"]):::uptodate --> x409d546b87b4d201(["fev_covars_tbl"]):::uptodate
    xc8496217a2afd247(["fev_scenario"]):::uptodate --> x409d546b87b4d201(["fev_covars_tbl"]):::uptodate
    x6d5c8319ce1721c9(["fev_data"]):::uptodate --> xb15cf928995c95c9(["fev_deploy"]):::uptodate
  end
  classDef uptodate stroke:#000000,color:#ffffff,fill:#354823;
  classDef none stroke:#000000,color:#000000,fill:#94a4ac;
  linkStyle 0 stroke-width:0px;
```
