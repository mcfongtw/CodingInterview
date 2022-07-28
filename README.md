## Github Page

The coding interview book is deployed and and previewed at (https://mcfongtw.github.io/CodingInterview/)

## Build Process

1. On dev local, execute
```
sh build.sh
```
which will create necessary changes in HTML page under docs/ directory. 
2. Commit the change to master branch. 
3. The Github action will deploy the static content under docs/ directory to the Github Page. 

## Dev Setup
It's recommended to use RStudio to create a work on a new solution in (R) Markdown format. 

## Reference
This is based off the minimal example of a bookdown (https://github.com/rstudio/bookdown). 

## Work In Progress

- [ ] Able to execute pandoc and rscript in build env.
- [ ] Change build infrastructure to execute build.sh as part of deployment pipeline instead of executing build.sh offline and deploy content statically. 


<!--
## Leetcode Progress
![LeetCode Stats](https://leetcard.jacoblin.cool/shannaracat?theme=dark&font=Marcellus%20SC&ext=activity)
-->
