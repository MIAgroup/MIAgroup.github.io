git_username=`git config user.name`
git_email=`git config user.email`
warning=(
    'Please run `git config --global user.name` and `git config --global user.email` to set up your github username and email, and RERUN script'  \
    'Please add commit message when running script,\neg. `sh submit.sh "add article written by Lincoln"`' \
    'Generate web files faile, make sure everything works by local_test script' \
)

# test git config setting for submit
if [ -z $git_username -o -z $git_email ]; then
    echo ${warning[0]}
    exit 1
fi


# test commit message, null is unpermitted
if [ -z "$1" ]; then
    echo ${warning[1]}
    exit 1
fi

## clean && generate
#hexo_clean_generate=`hexo clean && hexo generate &> /dev/null`

#if [ $? -ne 0 ]; then
#    echo ${warning[2]}
#    exit 1
#fi

# add file
gadd=`git add .`
gcommit=`git commit -m "$1"`
if [ -z $gadd -a "$gcommit" ]; then
    git push origin hexo
    echo "SUBMIT SUBCESS!!!"
fi


