#！/bin/bash

function finddir(){
     yearm="201704"
    for element in `ls $1`
    do
        dir_or_file=$1"/"$element
        if [ -d $dir_or_file ]
        then
            echo '文件夹' $dir_or_file
	    for file in `ls $dir_or_file`
	    do
	        echo "正在进一步处理文件：$dir_or_file/$file"
	#	sed -i '5,613d' $dir_or_file/$file
	#	sed -i '4a\<link rel="stylesheet" type="text/css" href="../css/bible.css">' $dir_or_file/$file
	#	sed -i -E 's#<a name="(.*)" href="(.*.html)">([0-9]*)<br \/><\/a>#\3#g' $dir_or_file/$file
	#	sed -i 's/ with Book Summary - Interlinear Study Bible - StudyLight.org//g' $dir_or_file/$file
		sed -i '$d' $dir_or_file/$file
		sed -i 's#</html>#\t\t</div>\n\t</body>\n</html>#' $dir_or_file/$file
	    done
        else
            echo '文件' $dir_or_file
        fi
    done
}
root_dir="./bible"
finddir $root_dir
