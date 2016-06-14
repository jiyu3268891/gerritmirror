#/bin/sh

src_k900="/work/k900_gerrit"
mirror_k900="/work/k900_mirror"

GIT_PROJECTS=`cat project.list | xargs`
echo ${GIT_PROJECTS}

function create_git() {
	git_path=$1
	cd $src_k900/$git_path/
	git checkout -b k900_branch
	base_path=`basename $git_path`
	echo $base_path
    cd ../
	git clone $base_path/.git --mirror
	mkdir -p $mirror_k900/$git_path
    mv $base_path.git $mirror_k900/$git_path/../
	rm -r $mirror_k900/$git_path
}

for git_project in ${GIT_PROJECTS}
do
	echo ${git_project}
	create_git ${git_project}
done

