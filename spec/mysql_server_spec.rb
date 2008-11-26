MOUNT_POINT = File.expand_path(File.dirname(__FILE__) + '/../mount')
require File.dirname(__FILE__) + '/spec_helper'
require 'fileutils'

describe "A mysql server" do
  before(:each) do
    Dir["#{MOUNT_POINT}/lib/*"].each do |f|
      FileUtils.rm(f)
    end
    klass = ENV["MOCK"] ? MockSlice : Slice
    @s = klass.new
    @m = MysqlServer.new
  end

  describe "being installed" do
    before(:each) do
      @m.install_on(@s)
    end

    it "installs the mysql database" do
      output = @m.list_on(@s)
      output.should == "mysql"
    end
  end

  describe "without being installed" do
    it "has no databases" do
      output = @m.list_on(@s)
      output.should == ""
    end
  end

  describe "creating a database" do
    before(:each) do
      @m.install_on(@s)
      @m.create_db_on("test", @s)
    end

    it "has the new database" do
      output = @m.list_on(@s)
      output.should == "mysql\ntest"
    end
  end

  describe "removing a database" do
    before(:each) do
      @m.install_on(@s)
      @m.create_db_on("test", @s)
      @m.remove_db_on("test", @s)
    end

    it "does not have the database anymore" do
      output = @m.list_on(@s)
      output.should == "mysql"
    end
  end
end
