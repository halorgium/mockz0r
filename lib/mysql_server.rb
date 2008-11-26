class MysqlServer
  def install_on(slice)
    unless slice.run("bin/mysql_install #{MOUNT_POINT}") == "installed"
      raise "Failed to install"
    end
  end

  def list_on(slice)
    slice.run "bin/mysql_list #{MOUNT_POINT}"
  end

  def create_db_on(name, slice)
    unless slice.run("bin/mysql_create #{MOUNT_POINT} #{name}") == "created"
      raise "Failed to create"
    end
  end

  def remove_db_on(name, slice)
    unless slice.run("bin/mysql_rm #{MOUNT_POINT} #{name}") == "removed"
      raise "Failed to remove"
    end
  end
end
