class MysqlServer
  class Error < StandardError; end
  class NotInstalled < Error; end
  class AlreadyInstalled < Error; end
  class DbAlreadyExists < Error; end
  class DbNonExistant < Error; end

  def install_on(slice)
    case slice.run("bin/mysql_install #{MOUNT_POINT}")
    when "installed"
      true
    when "already installed"
      raise AlreadyInstalled, "mysql is already installed"
    else
      raise Error
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
    case slice.run("bin/mysql_create #{MOUNT_POINT} #{name}")
    when "created"
      true
    when "db already exists"
      raise DbAlreadyExists, "db already exists"
    else
      raise Error
    end
  end

  def remove_db_on(name, slice)
    raise NotInstalled, "mysql is not installed" unless installed_on?(slice)
    case slice.run("bin/mysql_rm #{MOUNT_POINT} #{name}")
    when "removed"
      true
    when "db non-existant"
      raise DbNonExistant, "db non-existant"
    else
      raise Error
    end
  end
end
