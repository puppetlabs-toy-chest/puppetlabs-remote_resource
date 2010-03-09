#!/usr/bin/env puppet --verbose

remote_resource { "file exists":
    frequency => 1,
    timeout => 30,
    check => "/bin/ls /tmp/myfile"
}

notify { "File exists": require => Remote_resource["file exists"] }
