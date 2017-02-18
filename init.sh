

function download() {

if [ ! -f $2/$1 ];
then
echo "正在下载${1}..."
curl "http://oh32pp4u5.bkt.clouddn.com/${1}" --create-dirs -o $2/$1
fi

if [ ! -f $2/$1 ];
then
echo "下载失败: ${1}"
exit -1
fi

unzip -o $2/$1 -d $2

}

download "ijkplayer-k0.7.7.1.zip" "Frameworks"
download "ESMediaPlayer.zip" "Frameworks"

