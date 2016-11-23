# Notes on setup

1. Makefile seems to have wrong find command. Fixed
2. make seems to require a local repo for helm.

   helm serve --repo-path .
   helm repo add local-charts http://localhost-8879/charts


