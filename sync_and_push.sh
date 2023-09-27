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
version=$(grep version: pubspec.yaml | awk '{print $2}')
# log to the console
echo "current version is $version"
# get the patch number using grep and awk
patch=$(grep version: pubspec.yaml | awk -F. '{print $NF}')
# increment the patch number using echo, awk and sed
patch=$(echo $patch | awk '{$NF = $NF + 1;} 1' | sed 's/ /./g')
# increment the patch number using sed
new_version=$(echo $version | awk -F. '{$NF = $NF + 1;} 1' | sed 's/ /./g')
# replace the old version number with the new version number
echo "changing version from $version to $new_version in pubspec.yaml "

sed -i "s/version: $version/version: $new_version/g" pubspec.yaml

# commit the changes
git commit -am "version: 0.0.$patch"
# push the changes to the remote repository
git push

# log to the console
echo "$new_version pushed to the remote repository"
# end of script
