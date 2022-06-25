#!/usr/bin/env bash
case $BASH_VERSION in (""|[123].*) echo "Bash 4.0 or newer required" >&2; exit 1;; esac
#main folder
#下载的文件放置目录
s_folder=biblehtml
#处理后的文件放置目录
d_folder=bible

#创建文件夹
#参数1：文件夹名
function_folder_create()
{
	if [ ! -d "$1" ];then
  		mkdir -p $1
	else
  		echo "文件夹 $1 已经存在"
	fi
}

#下载文件
#参数1：key 经卷名
#参数2：num 经卷章数
#参数3：url 下载地址
function_download_file()
{
	function_folder_create ./$s_folder/$1
	for i in $(seq 1 $2)
        do
                echo "下载第$i个文件中..."
                wget $3$i.html -O ./$s_folder/$1/$1-$i.html
        done
}

#处理文件
#参数1：下载的文件放置目录
#参数2：目标子文件夹名，以key名命名
function_convert_file()
{
	function_folder_create ./$d_folder/$2
	for file in ./$1/$2/*
        do

                if test -f $file
                then
                        echo "正在处理文件：$file"
                        tac $file|sed '2,163d'|sed "2i\\<\/div><\/div><\/div>"|tac|sed '8,77d'|sed '748d'|sed '752d'|sed '757,798d'|sed '758d'|sed '/^\s*$/d' |sed '/<div class="strongs">/d'|sed -r 's/<a name="[0-9].*" href="[0-9].*-[0-9].*.html">([0-9].*)<br \/>([0-9].*)<\/a>/\1\2/g'|sed 's/34px/15px/g'|sed 's/"olt greek-hebrew"/"olt greek-hebrew fs-19"/g'|sed 's/\.translit{/\.translit{color\:green\;/g'|sed 's/\.greek-hebrew{/\.greek-hebrew{color\:red\;/g' >./$d_folder/$2/${file##*/}
		elif test -d $file
		then
			function_convert_file $file $2
		fi
        done
}

#进一步处理文件
function_convert_file2()
{
	for file in ./$1/$2/*
        do

                if test -f $file
                then
                        echo "正在进一步处理文件：$file"
                        sed -i '5,613d' $file	
						sed -i '4a\<link rel="stylesheet" type="text/css" href="../css/bible.css">' $file
						sed -i -E 's#<a name="(.*)" href="(.*.html)">([0-9]*)<br \/><\/a>#\3#g' $file
		elif test -d $file
		then
			function_convert_file2 $file $2
		fi
        done
}

#主逻辑
while IFS= read -r key && IFS= read -r num && IFS= read -r url; 
do
	#download file
	#function_download_file $key $num $url
	
	#deal with file
	function_convert_file $s_folder $key
	
	#deal with file
	#function_convert_file2 $s_folder $key
done < <(jq -r '.[] | (.key, .num, .url)' <./bible_hebrew.json)
