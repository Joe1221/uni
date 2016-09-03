#/bin/bash

set -e

git clone https://gitlab.dune-project.org/core/dune-common.git
git clone https://gitlab.dune-project.org/core/dune-geometry.git
git clone https://gitlab.dune-project.org/core/dune-grid.git
git clone https://gitlab.dune-project.org/core/dune-istl.git
git clone https://gitlab.dune-project.org/core/dune-localfunctions.git
git clone https://gitlab.dune-project.org/extensions/dune-alugrid.git
git clone https://gitlab.dune-project.org/dune-fem/dune-fem.git
git clone https://gitlab.dune-project.org/dune-fem/dune-acfem.git

git clone hilbsn@nmh110.mathematik.uni-stuttgart.de:scratch/dune/eeinpaint
