Dir.chdir(File.dirname(__FILE__)) { (s = lambda { |f| File.exist?(f) ? require(f) : Dir.chdir("..") { s.call(f) } }).call("spec/spec_helper.rb") }

describe Puppet::Type.type(:external_resource).provider(:shell) do
    before do
        @resource = stub 'resource'
        @provider = Puppet::Type.type(:external_resource).provider(:shell).new(@resource)
    end

    it "should exist" do
        @provider.should_not be_nil
    end

    it "should execute the provided shell command within an array" do
        @provider.expects(:execute).with(["/my/cmd"])
        @provider.perform_check("/my/cmd")
    end

    it "should pass on any encountered errors" do
        @provider.expects(:execute).with(["/my/cmd"]).raises Puppet::ExecutionFailure.new("foo")
        lambda { @provider.perform_check("/my/cmd") }.should raise_error(Puppet::ExecutionFailure)
    end
end
