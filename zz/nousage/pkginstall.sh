# install freebsd system from pkg_info
# create pkg_info > pkginfo first
# then run bash pkginstall.sh

while read line; do
    pkg=${line%% *}
    fn=${pkg%-*}
    echo now installing $fn
    pkg_add -r $fn
    sleep 1 
done < pkginfo


