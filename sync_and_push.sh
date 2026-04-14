#!/bin/zsh
# script zsh to sync and push the changes to the remote repository
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
patch=$(echo "$version" | cut -d '.' -f 3 | awk '{print $1+1}')
# change version patch number
# keep major and minor version number
# example: 0.1.0 -> 0.1.1
new_version=$(echo "$version" | cut -d '.' -f 1,2).$patch
echo "new version is $new_version"
echo "old $version"
echo "os type is $OSTYPE"
if [[ "$OSTYPE" == "darwin"* ]]; then
  sed -i '' "s/version: $version/version: $new_version/" pubspec.yaml
else
  sed -i "s/version: $version/version: $new_version/" pubspec.yaml
fi
# log to the console
echo "pubspec.yaml file updated"
# check version in pubspec.yaml
check_version=$(grep "version:" pubspec.yaml | cut -d ' ' -f 2)
final_check=$(grep "version:" pubspec.yaml | cut -d ' ' -f 2)
# commit the changes
git commit -a -m "version: $new_version"
# push the changes to the remote repository
git status
git push origin master
# log to the console
echo "changes pushed to the remote repository"
# log to the console
echo "done"
