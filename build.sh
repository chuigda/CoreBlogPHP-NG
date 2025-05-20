#!/usr/bin/env bash

rm -rf output
rm -rf tmp
mkdir tmp
mkdir output
mkdir output/research
mkdir output/literature
mkdir output/resume

echo "Generating TOC"
find content -iname "*.php" -o -iname "*.ini" -o -iname "*.html" > tmp/toc.txt
./toc-pregen.php > tmp/toc.json
./sitemap.php > output/sitemap.xml

for file in `find content -iname "*.php" -o -iname "*.html" -o -iname "*.md" -o -iname "*.pdf"`; do
    # replace all occurrences of "content/" with "output/" in the file
    output_file=${file/content\//output\/}
    # replace all suffix (any suffix, not only .php) to .html
    output_file=${output_file%%.*}.html
    echo "Processing $file -> $output_file"

    # get the folder the file is in. for example, file is content/literature/a.md,
    # the folder is literature
    folder=$(dirname "$file")
    filenav=$(basename "$folder")
    # if filenav == "content", then use the name of the file itself instead
    if [[ "$filenav" == "content" ]]; then
        filenav=$(basename "$file")
        # strip suffix
        filenav=${filenav%%.*}
    fi

    ./template.php "$file" "$filenav" > "$output_file"
done

for file in `find content -iname "*.pdf" -o -iname "*.typ"`; do
    # replace all occurrences of "content/" with "output/" in the file
    output_file=${file/content\//output\/}
    echo "Copying $file -> $output_file"
    cp "$file" "$output_file"
done

echo "Copying extra"
cp -r ./extra output/extra

echo "Copying robots.txt"
cp ./robots.txt output/robots.txt
