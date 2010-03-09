Dir.chdir(File.dirname(__FILE__)) { (s = lambda { |f| File.exist?(f) ? require(f) : Dir.chdir("..") { s.call(f) } }).call("spec/spec_helper.rb") }

describe Puppet::Type.type(:remote_resource) do
    before do
        @type = Puppet::Type.type(:remote_resource)
    end

    it "should exist" do
        @type.should_not be_nil
    end

    it "should have a default provider" do
        @type.defaultprovider.should_not be_nil
    end

    describe "the name parameter" do
        it "should exist" do
            @type.attrclass(:name).should_not be_nil
        end
    end

    describe "the 'frequency' parameter" do
        it "should exist" do
            @type.attrclass(:frequency).should_not be_nil
        end

        it "should convert values to integers" do
            @type.new(:name => "foo", :frequency => "50")[:frequency].should == 50
        end

        it "should default to '10'" do
            @type.new(:name => "foo")[:frequency].should == 10
        end
    end

    describe "the 'timeout' parameter" do
        it "should exist" do
            @type.attrclass(:timeout).should_not be_nil
        end

        it "should convert values to integers" do
            @type.new(:name => "foo", :timeout => "10")[:timeout].should == 10
        end

        it "should default to '300'" do
            @type.new(:name => "foo")[:timeout].should == 300
        end
    end

    describe "when retrieving" do
        before do
            @resource = @type.new(:name => "foo", :check => "/bin/true")
        end

        it "should perform_check the check with the provider" do
            @resource.provider.expects(:perform_check).with("/bin/true")
            @resource.retrieve
        end

        it "should return '{}' if the check passes" do
            @resource.provider.expects(:perform_check)
            @resource.retrieve.should == {}
        end

        it "should sleep for the specified frequency and check again if the check fails" do
            @resource.provider.expects(:perform_check).times(2).raises(Puppet::ExecutionFailure.new("foo")).then.returns true
            @resource.expects(:sleep).with(@resource[:frequency])
            @resource.retrieve.should == {}
        end

        it "should fail if the check has not passed within the timeout" do
            @resource[:timeout] = 1
            @resource[:frequency] = 1
            @resource.provider.stubs(:perform_check).raises(Puppet::ExecutionFailure.new("foo"))
            @resource.stubs(:sleep).with(@resource[:frequency])
            lambda { @resource.retrieve }.should raise_error(Puppet::Error)
        end
    end
end
