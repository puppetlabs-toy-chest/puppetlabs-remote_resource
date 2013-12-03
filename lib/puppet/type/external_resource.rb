Puppet::Type.newtype(:external_resource) do
    newparam(:name) do
        desc "The name of the remote resource."
    end

    newparam(:frequency) do
        desc "How often the check should be executed, in seconds."
        defaultto 10

        munge { |i| Integer(i) }
    end

    newparam(:check) do
        desc "The check to perform.  Usage and specifics are determined
            by the provider."
    end

    newparam(:timeout) do
        desc "How long the resource should wait for the remote resource
            to come up, in seconds."

        defaultto 300

        munge { |i| Integer(i) }
    end

    def retrieve
        start = Time.now
        while true
            return {} if external_resource_up?
            if Time.now - start > self[:timeout]
                fail "Remote resource not up within timeout #{self[:timeout]}"
            end

            info "Remote resource is not up; delaying for #{self[:frequency]} seconds before next check"
            sleep self[:frequency]
        end
    end

    private

    def external_resource_up?
        begin
            provider.perform_check(self[:check])
            return true
        rescue Puppet::ExecutionFailure
            return false
        end
    end
end
