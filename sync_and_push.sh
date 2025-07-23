# !/bin/bash
# script bash to sync and push the changes to the remote repository
# update pubspec.yaml file version: 0.0.x
# version number is in the format x.y.z
# x is the major version number
# y is the minor version number
# z is the patch version number
# the script will increment the patch number
# and push the changes to the remote repository

# get the current version number
version=$(grep "version:" pubspec.yaml | cut -d ' ' -f 2)
# log to the console
echo "current version is $version"

# get the patch number from the version number and increment it
patch=$(echo $version | cut -d '.' -f 3 | awk '{print $1+1}')


# change version patch number
# keep major and minor version number
# example: 0.1.0 -> 0.1.1
new_version=$(echo $version | cut -d '.' -f 1,2).$patch
echo "new version is $new_version"
echo "old $version"

# replace the old version number with the new version number
sed -i '' "s/version: 0.1.1/version: 0.1.2/g" pubspec.yaml &> /dev/null
# the previous command is not working on mac, not change the version number

# log to the console
echo "pubspec.yaml file updated"
# commit the changes
git commit -am "version: $new_version"
# push the changes to the remote repository
git status
git push origin master
# log to the console
echo "changes pushed to the remote repository"
# log to the console
echo "done"
