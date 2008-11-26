class MysqlServer
  class Error < StandardError; end
  class NotInstalled < Error; end

  def install_on(slice)
    unless slice.run("bin/mysql_install #{MOUNT_POINT}") == "installed"
      raise "Failed to install"
    end
  end

  def installed_on?(slice)
    databases_on(slice).include?("mysql")
  end

  def list_on(slice)
    slice.run "bin/mysql_list #{MOUNT_POINT}"
  end

  def databases_on(slice)
    list_on(slice).split(/\n/)
  end

  def create_db_on(name, slice)
    raise NotInstalled, "mysql is not installed" unless installed_on?(slice)
    unless slice.run("bin/mysql_create #{MOUNT_POINT} #{name}") == "created"
      raise "Failed to create"
    end
  end

  def remove_db_on(name, slice)
    raise NotInstalled, "mysql is not installed" unless installed_on?(slice)
    unless slice.run("bin/mysql_rm #{MOUNT_POINT} #{name}") == "removed"
      raise "Failed to remove"
    end
  end
end
