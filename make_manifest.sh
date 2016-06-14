REMOTE_FETCH="ssh://whgerrit01.archermind.com:29418/"
REMOTE_REVIEW="http://whgerrit01.archermind.com:8081/"
PROJECT_NAME="Lenovo_K900"
BRANCH="k900_branch"

echo "<?xml version=\"1.0\" encoding=\"UTF-8\"?>" > manifest.xml
echo "<manifest>" >> manifest.xml
echo "  <remote fetch=\"${REMOTE_FETCH}\" name=\"origin\" review=\"${REMOTE_REVIEW}\"/>" >> manifest.xml
echo "  <default remote=\"origin\" revision=\"${BRANCH}\"/>" >> manifest.xml
echo "" >> manifest.xml

GIT_PROJECTS=`cat project.list | xargs`

function create_project () {
	git_path=$1
	if [ ${git_path} == "build" ]
	then
		echo "  <project name=\"${PROJECT_NAME}/${git_path}\" path=\"${git_path}\" >" >> manifest.xml
        echo "      <copyfile dest=\"Makefile\" src=\"core/root.mk\"/>" >> manifest.xml
        echo "  </project>" >> manifest.xml
	elif [ ${git_path} == "vendor/intel/support" ]
	then
		echo "  <project name=\"${PROJECT_NAME}/${git_path}\" path=\"${git_path}\" >" >> manifest.xml
        echo "      <copyfile dest=\"device/intel/Android.mk\" src=\"x86_only_Android.mk\"/>" >> manifest.xml
		echo "      <copyfile dest=\"platform/vendor/intel/Android.mk\" src=\"x86_only_Android.mk\"/>" >> manifest.xml
		echo "  </project>" >> manifest.xml
	else
		echo "  <project name=\"${PROJECT_NAME}/${git_path}\" path=\"${git_path}\" />" >> manifest.xml
	fi
}

for git_project in ${GIT_PROJECTS}
do
    create_project ${git_project}
done

echo "" >> manifest.xml
echo "</manifest>" >> manifest.xml
