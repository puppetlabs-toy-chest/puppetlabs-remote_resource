require 'puppet/util'

Puppet::Type.type(:external_resource).provide(:shell) do
    desc "Check the state of an external resource using a shell script.
        If the script exits with a non-zero code, the resource is considered
        to not be up."

    include Puppet::Util

    def perform_check(command)
        execute([command])
    end
end
