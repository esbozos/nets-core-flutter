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
# get the patch number
patch=$(echo $version | awk -F. '{print $3}')
# increment the patch number parsing it to integer
patch=$((patch+1))
echo "version: 0.0.$patch"
# update the version number only first occurrence
sed -i "s/$version/version: 0.0.$patch/" pubspec.yaml
# commit the changes
git commit -am "version: 0.0.$patch"
# push the changes to the remote repository
git push

# log to the console
echo "version: 0.0.$patch pushed to the remote repository"
# end of script
