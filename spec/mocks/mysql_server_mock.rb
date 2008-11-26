class MysqlServerMock
  def initialize
    @databases = []
  end

  def locate(command)
    case command
    when /\/mysql_install /
      :install
    when /\/mysql_list /
      :list
    when /\/mysql_create /
      :create
    when /\/mysql_rm /
      :remove
    end
  end

  def install(command)
    @databases = ["mysql"]
    "installed"
  end

  def list(command)
    @databases.join("\n")
  end

  def create(command)
    if command =~ /mysql_create [^ ]+ (\w+)$/
      @databases << $1
      "created"
    else
      "FAILED"
    end
  end

  def remove(command)
    if command =~ /mysql_rm [^ ]+ (\w+)$/
      @databases.delete($1)
      "removed"
    else
      "FAILED"
    end
  end
end
