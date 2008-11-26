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
    describe "on a fresh machine" do
      before(:each) do
        @result = @m.install_on(@s)
      end

      it "succeeds" do
        @result.should be_true
      end

      it "installs the mysql database" do
        output = @m.list_on(@s)
        output.should == "mysql"
      end
    end

    describe "on a machine with it already installed" do
      before(:each) do
        @m.install_on(@s)
      end

      it "raises an error" do
        lambda { @m.install_on(@s) }.
          should raise_error(MysqlServer::AlreadyInstalled, /already installed/)
      end
    end
  end

  describe "without being installed" do
    it "has no databases" do
      output = @m.list_on(@s)
      output.should == ""
    end
  end

  describe "creating a database" do
    describe "when the server is installed" do
      describe "when the database has not been created" do
        before(:each) do
          @m.install_on(@s)
          @result = @m.create_db_on("test", @s)
        end

        it "succeeds" do
          @result.should be_true
        end

        it "has the new database" do
          output = @m.list_on(@s)
          output.should == "mysql\ntest"
        end
      end

      describe "when the database has been created" do
        before(:each) do
          @m.install_on(@s)
          @m.create_db_on("test", @s)
        end

        it "raises an error" do
        lambda { @m.create_db_on("test", @s) }.
          should raise_error(MysqlServer::DbAlreadyExists, /already exists/)
        end
      end
    end

    describe "when the server is not installed" do
      it "raises an error" do
        lambda { @m.create_db_on("test", @s) }.
          should raise_error(MysqlServer::NotInstalled, /not installed/)
      end
    end
  end

  describe "removing a database" do
    describe "when the server is installed" do
      describe "when the database has been created" do
        before(:each) do
          @m.install_on(@s)
          @m.create_db_on("test", @s)
          @result = @m.remove_db_on("test", @s)
        end

        it "succeeds" do
          @result.should be_true
        end

        it "does not have the database anymore" do
          output = @m.list_on(@s)
          output.should == "mysql"
        end
      end

      describe "when the database has not been created" do
        before(:each) do
          @m.install_on(@s)
        end

        it "raises an error" do
          lambda { @m.remove_db_on("test", @s) }.
            should raise_error(MysqlServer::DbNonExistant, /non-existant/)
        end
      end
    end

    describe "when the server is not installed" do
      it "raises an error" do
        lambda { @m.remove_db_on("test", @s) }.
          should raise_error(MysqlServer::NotInstalled, /not installed/)
      end
    end
  end
end
