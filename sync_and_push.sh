# /bin/bash
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

# log to the console
echo "new patch number is $patch"
# create the new version number
new_version="version: 0.0.$patch"
# log to the console
echo "new version is $new_version"
# replace the old version number with the new version number ")syntax error: invalid arithmetic operator (error token is "
sed -i '' "s/version: $version/$new_version/g" pubspec.yaml
# log to the console
echo "pubspec.yaml file updated"
# commit the changes
git commit -am "version: 0.0.$patch"
# push the changes to the remote repository
git push

# log to the console
echo "$new_version pushed to the remote repository"
# end of script
