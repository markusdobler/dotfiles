DIR=$(echo $0 | sed 's!/[^/]\+$!!')
for FILE in $(ls "$DIR" | grep -e "_")
do
    TARGET=$(echo "$FILE" | sed 's/^_/./')
    echo "ln -s \"$DIR/$FILE\" \"$TARGET\""
done
