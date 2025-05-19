#!/usr/bin/env bash

# remove output folder if exists
rm -rf output

mkdir output
mkdir output/blogs
mkdir output/resume

cp resume/resume-cn.pdf output/resume/
cp resume/resume.pdf output/resume/

php index.php > output/index.html
