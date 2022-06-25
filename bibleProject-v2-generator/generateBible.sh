#！/bin/bash

#创建文件夹
#参数1：文件夹名
function_folder_create()
{
	if [ ! -d "$1" ];then
  		mkdir -p $1
	fi
}

function finddir(){
    for element in `ls $1`
    do
        dir_or_file=$1"/"$element
        if [ -d $dir_or_file ]
        then
            echo "当前文件夹 $dir_or_file"
			#文件夹内文件数量
			files_num=`ls $dir_or_file |wc -l`
			for file in `ls $dir_or_file`
			do
					the_num=`echo $element|awk -F '[-]' '{print $1}'`
					chapter_num=`echo $file|awk -F '[- .]' '{print $2}'`
					part_file_name=`echo $file|awk -F '[- .]' '{print $1}'`
					echo "file---$file, the_num---- $the_num, chapter_num---$chapter_num"
					#新文件名
					new_file=./new_bible/$element/$file
					#创建文件夹
					function_folder_create ./new_bible/$element
					echo "生成新文件：$new_file"
					
					#获取内容
					cat $dir_or_file/$file |sed '1,10d' |sed '$d' |sed '$d'|sed '$d' >content_temp

					#写入第一部分
					cat part1.html > $new_file
					#写入sidebar内容
					cat sidebar-$the_num.txt >> $new_file
					#写入第二部分
					cat part2.html >> $new_file
					#写入章节
					for i in `seq $files_num`
					do
					  echo "<li><a href=\"$part_file_name-$i.html\">第$i章</a></li>" >> $new_file
					done
					#写入第三部分
					cat part3.html >> $new_file
					#写入title
					
					name=`grep -v '\.\.' sidebar-$the_num.txt |awk -F '[《》]' '{print $2}'`

					echo "《$name》第$chapter_num章" >> $new_file
					
					#写入第四部分
					cat part4.html >> $new_file					
					
					#追加写入content
					cat content_temp >> $new_file
					#写入第五部分
					cat part5.html >> $new_file	
			done
        else
            echo '文件' $dir_or_file
        fi
    done
}

root_dir="./bible"
finddir $root_dir

